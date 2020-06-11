package main

import (
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"reflect"
	"strings"
	"testing"
)

type loaderMock struct {
	mockFindLatestResourcesFolder func() (string, error)
	mockBucketExists              func() (bool, error)
	mockGetResourceBundle         func(pathPrefix string) (resourceBundle, error)
}

type mockResourceBundle struct {
	mockGet func(name string) (io.ReadCloser, error)
}

func (rb *mockResourceBundle) get(name string) (io.ReadCloser, error) {
	return rb.mockGet(name)
}

func (l *loaderMock) FindLatestResourcesFolder() (string, error) {
	return l.mockFindLatestResourcesFolder()
}

func (l *loaderMock) BucketExists() (bool, error) {
	return l.mockBucketExists()
}

func (l *loaderMock) GetResourceBundle(pathPrefix string) (resourceBundle, error) {
	return l.mockGetResourceBundle(pathPrefix)
}

type parserMock struct {
	mockParseFIs       func() (map[string]rawFinancialInstrument, error)
	mockParseFIGICodes func() (map[string]string, error)
	mockParseListings  func() map[string]string
	mockParseEntities  func(r io.ReadCloser) map[string]bool
}

func (p *parserMock) parseFIs(r1, r2 io.Reader) (map[string]rawFinancialInstrument, error) {
	return p.mockParseFIs()
}

func (p *parserMock) parseFIGICodes(r io.Reader, m map[string]string) (map[string]string, error) {
	return p.mockParseFIGICodes()
}

func (p *parserMock) parseListings(r io.Reader, m map[string]rawFinancialInstrument) map[string]string {
	return p.mockParseListings()
}

func (p *parserMock) parseEntityFunc() func(r io.ReadCloser) map[string]bool {
	return p.mockParseEntities
}

type s3LoaderMock struct {
	mockLoad func(name string) (io.Reader, error)
}

func (s3 *s3LoaderMock) LoadResource(name string) (io.Reader, error) {
	return s3.mockLoad(name)
}

func (s3 *s3LoaderMock) GetResourceBundle(name string) (resourceBundle, error) {
	return nil, nil
}

var lm = &loaderMock{
	mockFindLatestResourcesFolder: func() (string, error) {
		return "", nil
	},
	mockGetResourceBundle: func(pathPrefix string) (resourceBundle, error) {
		return &mockResourceBundle{
			mockGet: func(name string) (io.ReadCloser, error) {
				return ioutil.NopCloser(strings.NewReader("")), nil
			},
		}, nil
	},
}

type errorCloser struct {
	reader io.Reader
}

func (errorCloser) Close() error {
	return errCloser
}

var errCloser = errors.New("Error while reading from the reader")
var errLoader = errors.New("Error loading resource")

func TestGetMappings(t *testing.T) {
	var tests = []struct {
		nm       string
		lm       loader
		pm       *parserMock
		err      error
		expected fiMappings
	}{
		// loader error
		{
			nm: "loader error",
			lm: &loaderMock{
				mockFindLatestResourcesFolder: func() (string, error) {
					return "", nil
				},
				mockGetResourceBundle: func(pathPrefix string) (resourceBundle, error) {
					return nil, errLoader
				},
			},
			pm:       &parserMock{},
			err:      errLoader,
			expected: fiMappings{},
		},
		// nil & empty cases
		{
			nm: "nil",
			lm: lm,
			pm: &parserMock{
				mockParseFIs: func() (map[string]rawFinancialInstrument, error) {
					return nil, nil
				},
				mockParseListings: func() map[string]string {
					return nil
				},
				mockParseFIGICodes: func() (map[string]string, error) {
					return nil, nil
				},
				mockParseEntities: nil,
			},
			err:      nil,
			expected: fiMappings{},
		},
		{
			nm: "empty cases",
			lm: lm,
			pm: &parserMock{
				mockParseFIs: func() (map[string]rawFinancialInstrument, error) {
					return map[string]rawFinancialInstrument{}, nil
				},
				mockParseListings: func() map[string]string {
					return map[string]string{}
				},
				mockParseFIGICodes: func() (map[string]string, error) {
					return map[string]string{}, nil
				},
			},
			err: nil,
			expected: fiMappings{
				figiCodeToSecurityIDs:               map[string]string{},
				securityIDtoRawFinancialInstruments: map[string]rawFinancialInstrument{},
			},
		},
		// happy case
		{
			nm: "happy case",
			lm: lm,
			pm: &parserMock{
				mockParseFIs: func() (map[string]rawFinancialInstrument, error) {
					return map[string]rawFinancialInstrument{
						"ABCDEF-S": {
							securityID:       "ABCDEF-S",
							orgID:            "MNBVCX-E",
							fiType:           "EQ",
							securityName:     "foobar INC",
							primaryListingID: "LKJHHM-L",
						},
					}, nil
				},
				mockParseListings: func() map[string]string {
					return map[string]string{
						"LKJHHM-L": "ABCDEF-S",
					}
				},
				mockParseFIGICodes: func() (map[string]string, error) {
					return map[string]string{
						"BBG000123NMAV": "ABCDEF-S",
					}, nil
				},
			},
			err: nil,
			expected: fiMappings{
				figiCodeToSecurityIDs: map[string]string{
					"BBG000123NMAV": "ABCDEF-S",
				},
				securityIDtoRawFinancialInstruments: map[string]rawFinancialInstrument{
					"ABCDEF-S": {
						securityID:       "ABCDEF-S",
						orgID:            "MNBVCX-E",
						fiType:           "EQ",
						securityName:     "foobar INC",
						primaryListingID: "LKJHHM-L",
					},
				},
			},
		},
	}

	for _, tc := range tests {
		t.Run(fmt.Sprintf("Case [%v]", tc.nm), func(t *testing.T) {
			m, err := getMappings(fiTransformerImpl{tc.lm, tc.pm})
			if err != tc.err {
				t.Errorf("Expected error: [%v]. Actual: [%v]", tc.err, err)
			}
			if !reflect.DeepEqual(m, tc.expected) {
				t.Errorf("Expected: [%v]. Actual: [%v]", tc.expected, m)
			}
		})
	}
}

func TestApplyPublicEntityFiltering(t *testing.T) {
	var tests = []struct {
		rawFIs   map[string]rawFinancialInstrument
		pubEnts  map[string]bool
		expected map[string]rawFinancialInstrument
	}{
		{
			rawFIs:   map[string]rawFinancialInstrument{},
			pubEnts:  map[string]bool{},
			expected: map[string]rawFinancialInstrument{},
		},
		// empty orgID
		{
			rawFIs: map[string]rawFinancialInstrument{
				"ABCDEF-S": {
					securityID:       "ABCDEF-S",
					orgID:            "",
					fiType:           "EQ",
					securityName:     "foobar INC",
					primaryListingID: "LKJHHM-L",
				},
			},
			pubEnts: map[string]bool{
				"MNBVCX-E": true,
			},
			expected: map[string]rawFinancialInstrument{},
		},
		// no matching orgID
		{
			rawFIs: map[string]rawFinancialInstrument{
				"ABCDEF-S": {
					securityID:       "ABCDEF-S",
					orgID:            "MNBVCX-E",
					fiType:           "EQ",
					securityName:     "foobar INC",
					primaryListingID: "LKJHHM-L",
				},
			},
			pubEnts: map[string]bool{
				"MNBVCX-EE": true,
			},
			expected: map[string]rawFinancialInstrument{},
		},
		// fi with pub entity is retained
		{
			rawFIs: map[string]rawFinancialInstrument{
				"ABCDEF-S": {
					securityID:       "ABCDEF-S",
					orgID:            "MNBVCX-E",
					fiType:           "EQ",
					securityName:     "foobar INC",
					primaryListingID: "LKJHHM-L",
				},
			},
			pubEnts: map[string]bool{
				"MNBVCX-E": true,
			},
			expected: map[string]rawFinancialInstrument{
				"ABCDEF-S": {
					securityID:       "ABCDEF-S",
					orgID:            "MNBVCX-E",
					fiType:           "EQ",
					securityName:     "foobar INC",
					primaryListingID: "LKJHHM-L",
				},
			},
		},
		// fi w/ pub entity is retained, other is deleted
		{
			rawFIs: map[string]rawFinancialInstrument{
				"ABCDEF-S": {
					securityID:       "ABCDEF-S",
					orgID:            "MNBVCX-E",
					fiType:           "EQ",
					securityName:     "foobar INC",
					primaryListingID: "LKJHHM-L",
				},
				"FEDCBA-S": {
					securityID:       "FEDCBA-S",
					orgID:            "MNBVCX-EE",
					fiType:           "EQ",
					securityName:     "barfoo INC",
					primaryListingID: "LKJHHM-L",
				},
			},
			pubEnts: map[string]bool{
				"MNBVCX-E": true,
			},
			expected: map[string]rawFinancialInstrument{
				"ABCDEF-S": {
					securityID:       "ABCDEF-S",
					orgID:            "MNBVCX-E",
					fiType:           "EQ",
					securityName:     "foobar INC",
					primaryListingID: "LKJHHM-L",
				},
			},
		},
	}

	for _, tc := range tests {
		applyPublicEntityFilter(tc.rawFIs, tc.pubEnts)
	}

}

func TestTransformMappings(t *testing.T) {
	var tests = []struct {
		figisToSecIDs  map[string]string
		secIDstoRawFIs map[string]rawFinancialInstrument
		expected       map[string]financialInstrument
	}{
		// edge cases
		{
			figisToSecIDs:  nil,
			secIDstoRawFIs: nil,
			expected:       map[string]financialInstrument{},
		},
		{
			figisToSecIDs:  map[string]string{},
			secIDstoRawFIs: map[string]rawFinancialInstrument{},
			expected:       map[string]financialInstrument{},
		},
		// happy case
		{
			figisToSecIDs: map[string]string{
				"BBG000123NMAV": "ABCDEF-S",
			},
			secIDstoRawFIs: map[string]rawFinancialInstrument{
				"ABCDEF-S": {
					securityID:       "ABCDEF-S",
					orgID:            "MNBVCX-E",
					fiType:           "EQ",
					securityName:     "foobar INC",
					primaryListingID: "LKJHHM-L",
				},
			},
			expected: map[string]financialInstrument{
				"fd0d50ba-7031-3ebf-a594-4806b65a74bd": {
					figiCode:     "BBG000123NMAV",
					securityID:   "ABCDEF-S",
					orgID:        "6f2a22e5-2fb6-304e-b92b-1438f306dc94",
					securityName: "foobar INC",
				},
			},
		},
	}

	for _, tc := range tests {
		tcM := fiMappings{tc.figisToSecIDs, tc.secIDstoRawFIs}

		fis := transformMappings(tcM)
		if !reflect.DeepEqual(fis, tc.expected) {
			t.Errorf("Expected: [%v]. Actual: [%v]", tc.expected, fis)
		}
	}
}

func TestDoubleMD5Hash(t *testing.T) {
	var testCases = []struct {
		input    string
		expected string
	}{
		{
			"0F03DX-E",
			"5a9c7643-31e4-3bad-b6ba-a7676f43da9f",
		},
		{
			"0D1MLR-F",
			"385972c6-f8c1-3878-8e5f-7dd05a20f01b",
		},
	}

	for _, tc := range testCases {
		actual := doubleMD5Hash(tc.input)
		if tc.expected != actual {
			t.Errorf("Expected: [%s]. Actual: [%s]", tc.expected, actual)
		}
	}
}

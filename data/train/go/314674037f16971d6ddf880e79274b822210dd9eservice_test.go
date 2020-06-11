package financialinstruments

import (
	"fmt"
	"github.com/Financial-Times/neo-utils-go/neoutils"
	"github.com/jmcvetta/neoism"
	"github.com/stretchr/testify/assert"
	"os"
	"sort"
	"testing"
	"github.com/Financial-Times/up-rw-app-api-go/rwapi"
)

const (
	testFinancialInstrumentUUID = "6562674e-dbfa-4cb0-85b2-41b0948b7cc2"
	testIncompleteFinancialInstrumentUUID = "38431a92-dda3-4eb9-a367-60145a8e659f"
	specialCharactersFinancialInstrumentUUID = "bb596d64-78c5-4b00-a88f-e8248c956073"
	duplicateFinancialInstrumentUUID = "bb596d64-78c5-4b00-a88f-e8248c956073"
	facsetIdentifier = "B000BB-S"
	figiCode = "BBG000Y1HJT8"
	orgUUID = "4e484678-cf47-4168-b844-6adb47f8eb58"
	upToDateOrgUUID = "fbe74159-f4a0-4aa0-9cca-c2bbb9e8bffe"
	test_trans_id = "test_tid"
)

var uuidsToBeDeleted = []string{
	testFinancialInstrumentUUID,
	testIncompleteFinancialInstrumentUUID,
	specialCharactersFinancialInstrumentUUID,
	duplicateFinancialInstrumentUUID,
	orgUUID,
	upToDateOrgUUID,
}

var testFinancialInstrument = financialInstrument{
	UUID:      testFinancialInstrumentUUID,
	PrefLabel: "GREENWICH CAP ACCEPTANCE  1991-B B1",
	AlternativeIdentifiers: alternativeIdentifiers{
		UUIDS:             []string{testFinancialInstrumentUUID},
		FactsetIdentifier: facsetIdentifier,
		FIGICode:          figiCode,
	},
	IssuedBy: orgUUID,
}

var incompleteFinancialInstrument = financialInstrument{
	UUID: testIncompleteFinancialInstrumentUUID,
	AlternativeIdentifiers: alternativeIdentifiers{
		UUIDS:             []string{testIncompleteFinancialInstrumentUUID},
		FactsetIdentifier: facsetIdentifier,
	},
}

var specialCharactersFinancialInstrument = financialInstrument{
	UUID:      specialCharactersFinancialInstrumentUUID,
	PrefLabel: "A&B GEOSCIENCE'S CORP.  COM",
	AlternativeIdentifiers: alternativeIdentifiers{
		UUIDS:             []string{specialCharactersFinancialInstrumentUUID},
		FactsetIdentifier: facsetIdentifier,
		FIGICode:          figiCode,
	},
	IssuedBy: orgUUID,
}

func WriteValueAndTestResult(t *testing.T, value financialInstrument) {
	assert := assert.New(t)

	db := getDatabaseConnectionAndCheckClean(t, assert)
	cypherDriver := getCypherDriver(db)
	defer cleanDB(db, assert)

	assert.NoError(cypherDriver.Write(value, test_trans_id), "Failed to create financial instrument")

	readAndCompare(value, t, db)
}

func TestWrite(t *testing.T) {
	WriteValueAndTestResult(t, testFinancialInstrument)
}

func TestWriteWithIncompleteModel(t *testing.T) {
	WriteValueAndTestResult(t, incompleteFinancialInstrument)
}

func TestWriteWithSpecialCharacters(t *testing.T) {
	WriteValueAndTestResult(t, specialCharactersFinancialInstrument)
}

func TestWriteWillUpdateModel(t *testing.T) {
	assert := assert.New(t)

	db := getDatabaseConnectionAndCheckClean(t, assert)
	cypherDriver := getCypherDriver(db)
	defer cleanDB(db, assert)

	assert.NoError(cypherDriver.Write(testFinancialInstrument, test_trans_id), "Failed to create financial instrument")
	storedFinancialInstrument, _, err := cypherDriver.Read(testFinancialInstrumentUUID, test_trans_id)

	assert.NoError(err)
	assert.NotEmpty(storedFinancialInstrument)

	var upToDateFinancialInstrument = financialInstrument{
		UUID:      testFinancialInstrumentUUID,
		PrefLabel: "A&E CAPITAL FUNDING CORP  MULTI-VTG",
		AlternativeIdentifiers: alternativeIdentifiers{
			UUIDS:             []string{testFinancialInstrumentUUID},
			FactsetIdentifier: "QX6S54-S",
			FIGICode:          "BBG0066578X7",
		},
		IssuedBy: upToDateOrgUUID,
	}

	assert.NoError(cypherDriver.Write(upToDateFinancialInstrument, test_trans_id), "Failed to create financial instrument")

	readAndCompare(upToDateFinancialInstrument, t, db)
}

func TestUpdateWillRemoveNoLongerPresentProps(t *testing.T) {
	assert := assert.New(t)

	db := getDatabaseConnectionAndCheckClean(t, assert)
	cypherDriver := getCypherDriver(db)
	defer cleanDB(db, assert)

	assert.NoError(cypherDriver.Write(testFinancialInstrument, test_trans_id), "Failed to create financial instrument")
	storedFinancialInstrument, _, err := cypherDriver.Read(testFinancialInstrumentUUID, test_trans_id)

	assert.NoError(err)
	assert.NotEmpty(storedFinancialInstrument)

	var upToDateFinancialInstrument = financialInstrument{
		UUID: testFinancialInstrumentUUID,
		AlternativeIdentifiers: alternativeIdentifiers{
			UUIDS: []string{testFinancialInstrumentUUID},
		},
		IssuedBy: orgUUID,
	}

	assert.NoError(cypherDriver.Write(upToDateFinancialInstrument, test_trans_id), "Failed to create financial instrument")

	readAndCompare(upToDateFinancialInstrument, t, db)
}

func TestWriteFinancialInstrumentsWithSameFacsetIdentifierFails(t *testing.T) {
	assert := assert.New(t)

	db := getDatabaseConnectionAndCheckClean(t, assert)
	cypherDriver := getCypherDriver(db)
	defer cleanDB(db, assert)

	assert.NoError(cypherDriver.Write(testFinancialInstrument, test_trans_id), "Failed to create financial instrument")

	duplicateFinancialInstrument := financialInstrument{
		UUID:      duplicateFinancialInstrumentUUID,
		PrefLabel: testFinancialInstrument.PrefLabel,
		AlternativeIdentifiers: alternativeIdentifiers{
			UUIDS:             []string{duplicateFinancialInstrumentUUID},
			FactsetIdentifier: testFinancialInstrument.AlternativeIdentifiers.FactsetIdentifier,
		},
	}
	err := cypherDriver.Write(duplicateFinancialInstrument, test_trans_id)
	assert.Error(err)
	assert.IsType(rwapi.ConstraintOrTransactionError{}, err)
}

func TestWriteFinancialInstrumentsWithSameFigiCodesFails(t *testing.T) {
	assert := assert.New(t)

	db := getDatabaseConnectionAndCheckClean(t, assert)
	cypherDriver := getCypherDriver(db)
	defer cleanDB(db, assert)

	assert.NoError(cypherDriver.Write(testFinancialInstrument, test_trans_id), "Failed to create financial instrument")

	duplicateFinancialInstrument := financialInstrument{
		UUID:      duplicateFinancialInstrumentUUID,
		PrefLabel: testFinancialInstrument.PrefLabel,
		AlternativeIdentifiers: alternativeIdentifiers{
			UUIDS:    []string{duplicateFinancialInstrumentUUID},
			FIGICode: testFinancialInstrument.AlternativeIdentifiers.FIGICode,
		},
	}
	err := cypherDriver.Write(duplicateFinancialInstrument, test_trans_id)
	assert.Error(err)
	assert.IsType(rwapi.ConstraintOrTransactionError{}, err)
}

func TestDeletingNotExistingFinancialInstrument(t *testing.T) {
	assert := assert.New(t)
	db := getDatabaseConnectionAndCheckClean(t, assert)
	defer cleanDB(db, assert)

	cypherDriver := getCypherDriver(db)
	res, err := cypherDriver.Delete(testFinancialInstrumentUUID, test_trans_id)

	assert.NoError(err)
	assert.False(res)
}

func TestDelete(t *testing.T) {
	assert := assert.New(t)
	db := getDatabaseConnectionAndCheckClean(t, assert)
	cypherDriver := getCypherDriver(db)
	defer cleanDB(db, assert)

	assert.NoError(cypherDriver.Write(testFinancialInstrument, test_trans_id), "Failed to write person")

	found, err := cypherDriver.Delete(testFinancialInstrumentUUID, test_trans_id)
	assert.True(found, "Failed to delete financial instrument with uuid: %s", testFinancialInstrumentUUID)
	assert.NoError(err, "Error occurred while trying to delete financial instrument with uuid: %s", testFinancialInstrumentUUID)

	fi, found, err := cypherDriver.Read(testFinancialInstrumentUUID, test_trans_id)
	assert.Equal(financialInstrument{}, fi, "The financial instrument with uuid: %s should have been deleted.", testFinancialInstrumentUUID)
	assert.False(found, "Found financial instrument for uuid: %s which should have been deleted", testFinancialInstrumentUUID)
	assert.NoError(err, "Error trying to find financial instrument for uuid: %s", testFinancialInstrumentUUID)

}

func TestCount(t *testing.T) {
	assert := assert.New(t)
	db := getDatabaseConnectionAndCheckClean(t, assert)
	cypherDriver := getCypherDriver(db)
	defer cleanDB(db, assert)

	assert.NoError(cypherDriver.Write(testFinancialInstrument, test_trans_id), "Failed to write person")
	incompleteFinancialInstrument.AlternativeIdentifiers.FactsetIdentifier = "LQ6FS3-S"
	assert.NoError(cypherDriver.Write(incompleteFinancialInstrument, test_trans_id), "Failed to write person")

	count, err := cypherDriver.Count()
	assert.NoError(err, "Error trying to find the number of financial instruments")
	assert.Equal(count, 2, "Expeting two results but got %d", count)
}

func readAndCompare(expectedValue financialInstrument, t *testing.T, db neoutils.NeoConnection) {
	sort.Strings(expectedValue.AlternativeIdentifiers.UUIDS)

	dbValue, found, err := getCypherDriver(db).Read(expectedValue.UUID, test_trans_id)
	assert.NoError(t, err)
	assert.True(t, found)

	foundValue := dbValue.(financialInstrument)
	sort.Strings(foundValue.AlternativeIdentifiers.UUIDS)

	assert.EqualValues(t, expectedValue, foundValue)
}

func getDatabaseConnectionAndCheckClean(t *testing.T, assert *assert.Assertions) neoutils.NeoConnection {
	db := getDatabaseConnection(assert)
	cleanDB(db, assert)
	checkDbClean(db, t)
	return db
}

func getDatabaseConnection(assert *assert.Assertions) neoutils.NeoConnection {
	url := os.Getenv("NEO4J_TEST_URL")
	if url == "" {
		url = "http://localhost:7474/db/data"
	}

	conf := neoutils.DefaultConnectionConfig()
	conf.Transactional = false
	db, err := neoutils.Connect(url, conf)
	assert.NoError(err, "Failed to connect to Neo4j")
	return db
}

func cleanDB(db neoutils.CypherRunner, assert *assert.Assertions) {
	qs := []*neoism.CypherQuery{}

	for _, uuid := range uuidsToBeDeleted {
		qs = append(qs, &neoism.CypherQuery{Statement: fmt.Sprintf("MATCH (org:Thing {uuid: '%v'})<-[:IDENTIFIES*0..]-(i:Identifier) DETACH DELETE org, i", uuid)})
		qs = append(qs, &neoism.CypherQuery{Statement: fmt.Sprintf("MATCH (org:Thing {uuid: '%v'}) DETACH DELETE org", uuid)})
	}

	err := db.CypherBatch(qs)
	assert.NoError(err)
}

func checkDbClean(db neoutils.CypherRunner, t *testing.T) {
	assert := assert.New(t)

	result := []struct {
		UUID string `json:"fi.uuid"`
	}{}

	checkGraph := neoism.CypherQuery{
		Statement: `MATCH (fi:Thing) WHERE fi.uuid in {uuids} RETURN fi.uuid`,
		Parameters: neoism.Props{
			"uuids": []string{
				testFinancialInstrumentUUID,
				testIncompleteFinancialInstrumentUUID,
				specialCharactersFinancialInstrumentUUID,
				duplicateFinancialInstrumentUUID,
			},
		},
		Result: &result,
	}
	err := db.CypherBatch([]*neoism.CypherQuery{&checkGraph})
	assert.NoError(err)
	assert.Empty(result)
}

func getCypherDriver(db neoutils.NeoConnection) service {
	cr := NewCypherFinancialInstrumentService(db)
	cr.Initialise()
	return cr
}

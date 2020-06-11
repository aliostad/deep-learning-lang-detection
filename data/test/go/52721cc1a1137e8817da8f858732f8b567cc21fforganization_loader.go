package mocks

import "github.com/cloudfoundry-incubator/notifications/cf"

type OrganizationLoader struct {
	LoadCall struct {
		CallCount int
		Receives  struct {
			OrganizationGUID string
			Token            string
		}
		Returns struct {
			Organizations []cf.CloudControllerOrganization
			Errors        []error
		}
	}
}

func NewOrganizationLoader() *OrganizationLoader {
	return &OrganizationLoader{}
}

func (ol *OrganizationLoader) Load(organizationGUID, token string) (cf.CloudControllerOrganization, error) {
	ol.LoadCall.Receives.OrganizationGUID = organizationGUID
	ol.LoadCall.Receives.Token = token

	if len(ol.LoadCall.Returns.Organizations) <= ol.LoadCall.CallCount {
		ol.LoadCall.Returns.Organizations = append(ol.LoadCall.Returns.Organizations, cf.CloudControllerOrganization{})
	}

	if len(ol.LoadCall.Returns.Errors) <= ol.LoadCall.CallCount {
		ol.LoadCall.Returns.Errors = append(ol.LoadCall.Returns.Errors, nil)
	}

	org, err := ol.LoadCall.Returns.Organizations[ol.LoadCall.CallCount], ol.LoadCall.Returns.Errors[ol.LoadCall.CallCount]
	ol.LoadCall.CallCount++

	return org, err
}

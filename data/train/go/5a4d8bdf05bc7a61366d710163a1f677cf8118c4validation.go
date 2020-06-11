package validation

import (

	"k8s.io/kubernetes/pkg/api/validation"
	"k8s.io/kubernetes/pkg/util/validation/field"

	oapi "github.com/openshift/origin/pkg/api"
	servicebrokerapi "github.com/openshift/origin/pkg/servicebroker/api"
)

func ValidateServiceBrokerName(name string, prefix bool) (bool, string) {
	if ok, reason := oapi.MinimalNameRequirements(name, prefix); !ok {
		return ok, reason
	}

	if len(name) < 2 {
		return false, "must be at least 2 characters long"
	}

	return true, ""
}

// ValidateServiceBroker tests required fields for a ServiceBroker.
// This should only be called when creating a servicebroker (not on update),
// since its name validation is more restrictive than default namespace name validation
func ValidateServiceBroker(servicebroker *servicebrokerapi.ServiceBroker) field.ErrorList {
	result := validation.ValidateObjectMeta(&servicebroker.ObjectMeta, false, ValidateServiceBrokerName, field.NewPath("metadata"))

	return result
}

// ValidateServiceBrokerUpdate tests to make sure a servicebroker update can be applied.  Modifies newServiceBroker with immutable fields.
func ValidateServiceBrokerUpdate(newServiceBroker *servicebrokerapi.ServiceBroker, oldServiceBroker *servicebrokerapi.ServiceBroker) field.ErrorList {

	allErrs := validation.ValidateObjectMetaUpdate(&newServiceBroker.ObjectMeta, &oldServiceBroker.ObjectMeta, field.NewPath("metadata"))

	allErrs = append(allErrs, ValidateServiceBroker(newServiceBroker)...)

	return allErrs
}

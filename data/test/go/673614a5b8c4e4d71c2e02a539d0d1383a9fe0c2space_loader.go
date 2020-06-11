package mocks

import "github.com/cloudfoundry-incubator/notifications/cf"

type SpaceLoader struct {
	LoadCall struct {
		CallCount int
		Receives  struct {
			SpaceGUID string
			Token     string
		}
		Returns struct {
			Spaces []cf.CloudControllerSpace
			Errors []error
		}
	}
}

func NewSpaceLoader() *SpaceLoader {
	return &SpaceLoader{}
}

func (sl *SpaceLoader) Load(spaceGUID, token string) (cf.CloudControllerSpace, error) {
	sl.LoadCall.Receives.SpaceGUID = spaceGUID
	sl.LoadCall.Receives.Token = token

	if len(sl.LoadCall.Returns.Spaces) <= sl.LoadCall.CallCount {
		sl.LoadCall.Returns.Spaces = append(sl.LoadCall.Returns.Spaces, cf.CloudControllerSpace{})
	}

	if len(sl.LoadCall.Returns.Errors) <= sl.LoadCall.CallCount {
		sl.LoadCall.Returns.Errors = append(sl.LoadCall.Returns.Errors, nil)
	}

	space, err := sl.LoadCall.Returns.Spaces[sl.LoadCall.CallCount], sl.LoadCall.Returns.Errors[sl.LoadCall.CallCount]
	sl.LoadCall.CallCount++

	return space, err
}

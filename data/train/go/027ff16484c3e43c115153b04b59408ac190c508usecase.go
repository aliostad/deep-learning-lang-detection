package usecases

import (
	"errors"
	"fmt"
	"github.com/acazau/docker_vulcand_sidekick/domain"
	"log"
)

type IUseCaseManager interface {
	Execute(config *domain.Config) error
}

type UseCaseManager struct {
	InjectedUseCaseManager IUseCaseManager
}

func (manager *UseCaseManager) Execute(config *domain.Config) error {
	if manager.InjectedUseCaseManager == nil {
		return errors.New("Injected InjectedUseCaseManager cannot be null")
	}

	if err := manager.InjectedUseCaseManager.Execute(config); err != nil {
		log.Println(fmt.Sprintf("Error executing UseCaseManager %s", err.Error()))
		return err
	}

	return nil
}

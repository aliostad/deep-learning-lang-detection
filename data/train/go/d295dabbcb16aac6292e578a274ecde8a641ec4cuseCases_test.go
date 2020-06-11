package goUseCases

import (
	"reflect"
	"testing"
)

type SimpleUseCase Base

func (useCase *SimpleUseCase) Perform() {
	useCase.Set("MyVal", 1)
}

func TestSimpleUseCase(t *testing.T) {
	useCase := SimpleUseCase{EmptyContext()}
	useCase.Perform()

	if got := useCase.Context.Get("MyVal"); !reflect.DeepEqual(got, 1) {
		t.Errorf("Unmatched result, got %v, want %v", got, 1)
	}
}

type DependsSuccessUseCase Base

func (useCase *DependsSuccessUseCase) Perform() {
	useCase.Depends(&SimpleUseCase{})

	value := useCase.Context.Get("MyVal").(int)
	useCase.Context.Set("MyChangedVal", value+1)
}

func TestDependsSuccessUseCase(t *testing.T) {

	useCase := DependsSuccessUseCase{EmptyContext()}
	useCase.Perform()

	if got := useCase.Context.Get("MyChangedVal"); !reflect.DeepEqual(got, 2) {
		t.Errorf("Unmatched result, got %v, want %v", got, 2)
	}
}

type FailingUseCase Base

func (useCase *FailingUseCase) Perform() {
	useCase.Failure("not_found", "This failing use case didnt find what was looking for")
}

type FailingUseCaseShouldnExecute Base

func (useCase *FailingUseCaseShouldnExecute) Perform() {
	useCase.Set("ShouldNotUpdate", true)
}

type FailingUseCaseBase Base

func (useCase *FailingUseCaseBase) Perform() {
	useCase.Depends(
		&FailingUseCase{},
		&FailingUseCaseShouldnExecute{},
	)
}

func TestDependsFailingUseCase(t *testing.T) {

	useCase := FailingUseCaseBase{EmptyContext()}
	useCase.Perform()

	if got := useCase.Context.Get("ShouldNotUpdate"); !reflect.DeepEqual(got, nil) {
		t.Errorf("Unmatched result, got %v, want %v", got, nil)
	}
}

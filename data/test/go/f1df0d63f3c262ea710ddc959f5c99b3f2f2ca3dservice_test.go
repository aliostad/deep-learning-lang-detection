package main

import (
	"reflect"
	"testing"
)

type transformerMock struct {
	mockTransform             func() (map[string]financialInstrument, error)
	mockCheckConnectivityToS3 func() error
}

func (tm *transformerMock) Transform() (map[string]financialInstrument, error) {
	return tm.mockTransform()
}

func (tm *transformerMock) checkConnectivityToS3() error {
	return tm.mockCheckConnectivityToS3()
}

func TestFiServiceImpl_Read(t *testing.T) {
	UUID := "7d4fdd8b-3bad-3766-af4a-b26a7bc56f10"

	expected := financialInstrument{
		securityID:   "S10JZW-S-CA",
		securityName: "QUIZAM MEDIA CORP COM",
		figiCode:     "BBG000D9Y7X",
		orgID:        "6745b841-6f2f-3741-bf2f-80d13ec68bdd",
	}

	fis := fiServiceImpl{
		financialInstruments: map[string]financialInstrument{
			UUID: expected,
		},
	}

	fi, present := fis.Read(UUID)

	if present == false {
		t.Errorf("expecting that financial instrument [%v] to be found", expected)
	}

	if !reflect.DeepEqual(fi, expected) {
		t.Errorf("Expected: [%v]. Actual: [%v]", expected, fi)
	}

}

func TestFiServiceImpl_Read_NotExistingValue(t *testing.T) {
	UUID := "7d4fdd8b-3bad-3766-af4a-b26a7bc56f10"
	searchedUUID := "24d7f133-d30b-394f-970c-5a5e3ed66061"

	expected := financialInstrument{
		securityID:   "S10JZW-S-CA",
		securityName: "QUIZAM MEDIA CORP COM",
		figiCode:     "BBG000D9Y7X",
		orgID:        "6745b841-6f2f-3741-bf2f-80d13ec68bdd",
	}

	fis := fiServiceImpl{
		financialInstruments: map[string]financialInstrument{
			UUID: expected,
		},
	}

	_, present := fis.Read(searchedUUID)

	if present != false {
		t.Errorf("Expecting that financial instrument [%v] to be not found", expected)
	}
}

func TestFiServiceImpl_Read_NotInitialisedService(t *testing.T) {
	searchedUUID := "24d7f133-d30b-394f-970c-5a5e3ed66061"

	fis := fiServiceImpl{}

	_, present := fis.Read(searchedUUID)

	if present != false {
		t.Error("Not expecting to find any financial instrument")
	}
}

func TestFiServiceImpl_Count(t *testing.T) {
	UUID1 := "7d4fdd8b-3bad-3766-af4a-b26a7bc56f10"
	UUID2 := "24d7f133-d30b-394f-970c-5a5e3ed66061"

	expected := financialInstrument{
		securityID:   "S10JZW-S-CA",
		securityName: "QUIZAM MEDIA CORP COM",
		figiCode:     "BBG000D9Y7X",
		orgID:        "6745b841-6f2f-3741-bf2f-80d13ec68bdd",
	}

	fis := fiServiceImpl{
		financialInstruments: map[string]financialInstrument{
			UUID1: expected,
			UUID2: expected,
		},
	}

	count := fis.Count()

	if count != 2 {
		t.Errorf("Expecting to found 2 financial instruments, but found [%d]", count)
	}
}

func TestFiServiceImpl_Count_NotInitialisedService(t *testing.T) {
	fis := fiServiceImpl{}

	count := fis.Count()

	if count != 0 {
		t.Errorf("Expecting to found 0 financial instruments, but found [%d]", count)
	}
}

func TestFiServiceImpl_IsInitialised(t *testing.T) {
	UUID := "7d4fdd8b-3bad-3766-af4a-b26a7bc56f10"

	expected := financialInstrument{
		securityID:   "S10JZW-S-CA",
		securityName: "QUIZAM MEDIA CORP COM",
		figiCode:     "BBG000D9Y7X",
		orgID:        "6745b841-6f2f-3741-bf2f-80d13ec68bdd",
	}

	fis := fiServiceImpl{
		financialInstruments: map[string]financialInstrument{
			UUID: expected,
		},
	}

	initialised := fis.IsInitialised()

	if initialised != true {
		t.Error("Expecting that financial instruments service to be initialised")
	}
}

func TestFiServiceImpl_IsInitialised_NotInitialisedService(t *testing.T) {
	fis := fiServiceImpl{}

	initialised := fis.IsInitialised()

	if initialised != false {
		t.Error("Expecting that financial instruments service to be not initialised")
	}
}

func TestFiServiceImpl_IDs(t *testing.T) {
	UUID1 := "7d4fdd8b-3bad-3766-af4a-b26a7bc56f10"
	UUID2 := "24d7f133-d30b-394f-970c-5a5e3ed66061"

	fi := financialInstrument{
		securityID:   "S10JZW-S-CA",
		securityName: "QUIZAM MEDIA CORP COM",
		figiCode:     "BBG000D9Y7X",
		orgID:        "6745b841-6f2f-3741-bf2f-80d13ec68bdd",
	}

	fis := fiServiceImpl{
		financialInstruments: map[string]financialInstrument{
			UUID1: fi,
			UUID2: fi,
		},
	}

	expected1 := []string{"7d4fdd8b-3bad-3766-af4a-b26a7bc56f10", "24d7f133-d30b-394f-970c-5a5e3ed66061"}
	expected2 := []string{"24d7f133-d30b-394f-970c-5a5e3ed66061", "7d4fdd8b-3bad-3766-af4a-b26a7bc56f10"}

	IDs := fis.IDs()

	if !reflect.DeepEqual(IDs, expected1) && !reflect.DeepEqual(IDs, expected2) {
		t.Errorf("Expected: [%v] or [%v]. Actual: [%v]", expected1, expected2, IDs)
	}
}

func TestFiServiceImpl_IDs_NotInitialisedService(t *testing.T) {
	fis := fiServiceImpl{}
	expected := []string{}

	IDs := fis.IDs()

	if !reflect.DeepEqual(IDs, expected) {
		t.Errorf("Expected: [%v]. Actual: [%v]", expected, IDs)
	}
}

func TestFiServiceImpl_Init(t *testing.T) {
	UUID1 := "7d4fdd8b-3bad-3766-af4a-b26a7bc56f10"
	UUID2 := "24d7f133-d30b-394f-970c-5a5e3ed66061"

	fi := financialInstrument{
		securityID:   "S10JZW-S-CA",
		securityName: "QUIZAM MEDIA CORP COM",
		figiCode:     "BBG000D9Y7X",
		orgID:        "6745b841-6f2f-3741-bf2f-80d13ec68bdd",
	}

	tm := &transformerMock{
		mockTransform: func() (map[string]financialInstrument, error) {
			return map[string]financialInstrument{
				UUID1: fi,
				UUID2: fi,
			}, nil
		},
	}

	expected := map[string]financialInstrument{
		UUID1: fi,
		UUID2: fi,
	}

	fis := fiServiceImpl{fit: tm}
	fis.Init()

	if !reflect.DeepEqual(fis.financialInstruments, expected) {
		t.Errorf("Expected: [%v]. Actual: [%v]", expected, fis.financialInstruments)
	}
}

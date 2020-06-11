package main

//mockStorageManagerForDD Mock StorageManager to work with the
//linux command dd
type mockStorageManagerForDD struct {
	mockStorageManager
}

func (m *mockStorageManagerForDD) GetNextFileName() string {
	return "of=/tmp/e"
}

//GetMockStorageManagerDD returns a mockStorageManagerForDD
// struct for testing with 'dd'
func GetMockStorageManagerDD() *mockStorageManagerForDD {
	return new(mockStorageManagerForDD)
}

//mockStorageManagerForLs Mock StorageManager
// to work with the linux command 'ls'
type mockStorageManagerForLs struct {
	mockStorageManager
}

func (m *mockStorageManagerForLs) GetNextFileName() string {
	return "/tmp"
}

//GetMockStorageManagerLS returns mockStorageManagerForLs
// struct for testing with the linux command 'ls'
func GetMockStorageManagerLS() *mockStorageManagerForLs {
	return new(mockStorageManagerForLs)
}

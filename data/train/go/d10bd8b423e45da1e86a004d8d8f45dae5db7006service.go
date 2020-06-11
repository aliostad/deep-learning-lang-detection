package main

type fiService interface {
	Init()
	Read(UUID string) (financialInstrument, bool)
	IDs() []string
	Count() int
	IsInitialised() bool
	checkConnectivity() error
}

type fiServiceImpl struct {
	fit                  fiTransformer
	config               s3Config
	financialInstruments map[string]financialInstrument
}

func (fis *fiServiceImpl) Init() {
	financialInstruments, err := fis.fit.Transform()
	if err != nil {
		errorLogger.Println(err)
		return
	}
	fis.financialInstruments = financialInstruments
}

func (fis *fiServiceImpl) Read(UUID string) (financialInstrument, bool) {
	fi, present := fis.financialInstruments[UUID]
	return fi, present
}

func (fis *fiServiceImpl) IDs() []string {
	var UUIDs = []string{}
	for UUID := range fis.financialInstruments {
		UUIDs = append(UUIDs, UUID)
	}
	return UUIDs
}

func (fis *fiServiceImpl) Count() int {
	count := len(fis.financialInstruments)
	return count
}

func (fis *fiServiceImpl) IsInitialised() bool {
	return fis.financialInstruments != nil
}

func (fis *fiServiceImpl) checkConnectivity() error {
	return fis.fit.checkConnectivityToS3()
}

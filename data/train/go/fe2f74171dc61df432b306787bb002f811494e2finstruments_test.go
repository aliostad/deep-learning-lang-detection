package brato

import "testing"

func newTestInstrumentsService() *InstrumentsService {
	r := &instrumentsRepository{}
	return &InstrumentsService{InstrumentsRepository: r}
}

func TestInstrumentsService_Create(t *testing.T) {
	s := newTestInstrumentsService()

	_, err := s.Create(&Instrument{Name: "r101-api: Response Times"})
	if err != nil {
		t.Fatal(err)
	}
}

func TestInstrumentsService_Create_Existing(t *testing.T) {
	s := newTestInstrumentsService()
	r := s.InstrumentsRepository

	i := &Instrument{Name: "r101-api: Response Times"}
	r.Create(i)

	_, err := s.Create(i)
	if err != nil {
		t.Fatal(err)
	}

	e, err := r.Find(i.Name)
	if err != nil {
		t.Fatal(err)
	}

	if e != i {
		t.Errorf("Expected the existing instrument to be updated.")
	}
}

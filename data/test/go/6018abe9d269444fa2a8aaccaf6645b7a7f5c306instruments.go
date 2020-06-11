package brato

var (
	DefaultInstrumentsRepository = &instrumentsRepository{}
	DefaultInstrumentsService    = &InstrumentsService{}
)

type Stream struct {
	Composite string `json:"composite"`
}

type Instrument struct {
	Name    string    `json:"name"`
	Color   string    `json:"color"`
	Streams []*Stream `json:"streams"`
}

type InstrumentsRepository interface {
	// Find an existing instrument by name
	Find(name string) (*Instrument, error)
	// Create a new instrument.
	Create(*Instrument) (*Instrument, error)
	// Update an existing instrument.
	Update(*Instrument) (*Instrument, error)
}

type instrumentsRepository struct {
	instruments map[string]*Instrument
}

func (r *instrumentsRepository) Find(name string) (*Instrument, error) {
	return r.instruments[name], nil
}

func (r *instrumentsRepository) Create(i *Instrument) (*Instrument, error) {
	return r.save(i)
}

func (r *instrumentsRepository) Update(i *Instrument) (*Instrument, error) {
	return r.save(i)
}

func (r *instrumentsRepository) save(i *Instrument) (*Instrument, error) {
	if r.instruments == nil {
		r.instruments = make(map[string]*Instrument)
	}

	r.instruments[i.Name] = i
	return i, nil
}

type InstrumentsService struct {
	InstrumentsRepository
}

// Create creates the instrument in Librato, first checking if it exists and
// updating it, else falling back to creating a new instrument.
func (s *InstrumentsService) Create(i *Instrument) (*Instrument, error) {
	r := s.repository()

	e, err := r.Find(i.Name)
	if err != nil {
		return &Instrument{}, err
	}

	if e != nil {
		return r.Update(i)
	}

	return r.Create(i)
}

func (s *InstrumentsService) repository() InstrumentsRepository {
	if s.InstrumentsRepository == nil {
		return DefaultInstrumentsRepository
	}

	return s.InstrumentsRepository
}

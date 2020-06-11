package testcase

// NewCase create test case instance
func NewCase(
	name string,
	setup SetupFunc,
) CaseBuilder {
	return &CaseType{
		name:  name,
		setup: setup,
	}
}

// SetupFunc define testcase setup function type
type SetupFunc func(c Context, t Case) (value interface{})

// TearDownFunc define testcase teardown function type
type TearDownFunc func(c Context, t Case, value interface{})

// Case define test case info
type Case interface {
	Name() string
	Depends() []Case
	Setup(c Context, t Case) (value interface{})
	TearDown(c Context, t Case, value interface{})
}

// CaseBuilder is a helper for setup test case
type CaseBuilder interface {
	Case

	SetDepends(depends ...Case) CaseBuilder
	SetTearDown(teardown TearDownFunc) CaseBuilder
}

// CaseType implement Case
type CaseType struct {
	name     string
	depends  []Case
	setup    SetupFunc
	teardown TearDownFunc
}

// Name of test case
func (t *CaseType) Name() string {
	return t.name
}

// Depends list all dependency of test case
func (t *CaseType) Depends() []Case {
	return t.depends
}

// Setup of test case
func (t *CaseType) Setup(c Context, testcase Case) (value interface{}) {
	return t.setup(c, testcase)
}

// TearDown of test case
func (t *CaseType) TearDown(c Context, testcase Case, value interface{}) {
	if t.teardown != nil {
		t.teardown(c, testcase, value)
	}
}

// SetDepends set depends
func (t *CaseType) SetDepends(depends ...Case) CaseBuilder {
	t.depends = depends
	return t
}

// SetTearDown set teardown
func (t *CaseType) SetTearDown(teardown TearDownFunc) CaseBuilder {
	t.teardown = teardown
	return t
}

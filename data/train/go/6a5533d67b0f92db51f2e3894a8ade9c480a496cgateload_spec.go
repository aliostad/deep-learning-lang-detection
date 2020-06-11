package sgload

import (
	"fmt"
	"log"
)

type GateLoadSpec struct {
	LoadSpec
	WriteLoadSpec
	ReadLoadSpec
	UpdateLoadSpec
}

func (gls GateLoadSpec) Validate() error {

	if err := gls.LoadSpec.Validate(); err != nil {
		return err
	}

	if err := gls.ReadLoadSpec.Validate(); err != nil {
		return err
	}

	if err := gls.WriteLoadSpec.Validate(); err != nil {
		return err
	}

	if err := gls.UpdateLoadSpec.Validate(); err != nil {
		return err
	}

	// Currently we need at least as many writers as updaters, since
	// they use writer credentials, and if more updaters than writers
	// the writer creds will be non-existent for some updaters
	if gls.UpdateLoadSpec.NumUpdaters > gls.WriteLoadSpec.NumWriters {
		return fmt.Errorf("Need at least as many writers as updaters")
	}

	return nil
}

// Validate this spec or panic
func (gls GateLoadSpec) MustValidate() {
	if err := gls.Validate(); err != nil {
		log.Panicf("Invalid GateLoadSpec: %+v. Error: %v", gls, err)
	}
}

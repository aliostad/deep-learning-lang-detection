namespace XLCatlin.DataLab.XCBRA.DomainModel

// ==========================================
// Domain type
// ==========================================

type DazzleCalculationInput = string //TODO define DazzleCalculation input

type DazzleCalculationOutput = string //TODO define DazzleCalculation output

/// the status is updated by the long-running process
type DazzleCalculationStatus = 
    | InProcess of DurationInMs
    | Completed of DurationInMs * DazzleCalculationOutput 

type DazzleCalculation = {
    Id : DazzleCalculationId
    Input: DazzleCalculationInput 
    Status : DazzleCalculationStatus 
    }

// ==========================
// ReadModel
// ==========================

// DazzleStatus is the only output, so no need for a special read model

// ==========================
// Commands
// ==========================

// Dazzle calculations do not use the standard Command process.
// Instead they have their own API -- see ApiDazzleService

// ==========================
// Events
// ==========================

// Calculations are transient and event sourcing is not used to reconstruct state.


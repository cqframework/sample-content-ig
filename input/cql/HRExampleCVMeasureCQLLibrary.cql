library HRExampleCVMeasureCQLLibrary version '0.5.3-cibuild'

using QICore version '4.1.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include CQMCommonExample called CQMCommon
include QICoreCommonExample called QICoreCommon
include SupplementalDataElementsExample called SDE

parameter "Measurement Period" Interval<DateTime>

context Patient

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
  SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
  SDE."SDE Sex"

define "Initial Population":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  ) in Interval[18, 75]

define "Measure Population":
  "Initial Population"

define "Measure Population Exclusions":
  "Initial Population"

define "Measure Observation":
  "Initial Population"

define "Observation that patients are 19 years or older":
  AgeInYearsAt(date from start of "Measurement Period") >= 18

define "Patient Age 18 Years or Older at Start of Measurement Period":
  AgeInYearsAt(date from start of "Measurement Period") >= 18

define "Patient Age Less than 18 Years Start of Measurement Period":
  AgeInYearsAt(date from start of "Measurement Period") < 18

define "RAV Patient Too Young at Start of Measurement Period":
  AgeInYearsAt(date from start of "Measurement Period") < 5

define "RAV Patient Too Old at Start of Measurement Period":
  AgeInYearsAt(date from start of "Measurement Period") > 80

define function "Measure Observation 1"():
  if AgeInYearsAt(date from start of "Measurement Period") >= 18 then 1 
    else 0
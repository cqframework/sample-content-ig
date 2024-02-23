library CovidLabResults version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include FHIRCommon version '1.0.0' called FC
include USCoreFHIRElements version '1.0.0' called UE
include CovidConcepts called Cx

context Patient

/// Report QA analysis with count of resources, no PHI.
define ReportLabResultsQA: 
{
  "Lab Results Count": Count(UE."All Laboratory Results"),
  "COVID19 Lab Tests": Count("COVID19 Lab Tests"),
  // "Prediabetes HbA1c Tests": Count("Prediabetes HbA1c Tests"),
  "Hemoglobin A1C": Count("Hemoglobin A1C"),
  "Estimated Glomerular Filtration Rate": Count("Estimated Glomerular Filtration Rate"),

  "Lab Results Without Preferred Code": Count("Lab Results Without Preferred Code")
}

// Most recent FHIR Observation for each laboratory data element.
define ReportLabResults: {
  "COVID19 Lab Tests": "COVID19 Lab Tests".mostRecentResult(),
  // "Prediabetes HbA1c Tests": "Prediabetes HbA1c Tests".mostRecentResult(),
  "Hemoglobin A1C": "Hemoglobin A1C".mostRecentResult(),
  "Estimated Glomerular Filtration Rate": "Estimated Glomerular Filtration Rate".mostRecentResult()
}

define "Lab Results Without Preferred Code":
  UE."All Laboratory Results" obs
    where obs.preferredCode() is null

// Returns a System.Code with sytem and code parameters
define fluent function preferredCode(observation Observation):
  First(
    observation.code.coding c
      let preferredCode: c.preferredCoding()
      where preferredCode.code is not null
      return preferredCode
  )

define fluent function preferredCoding(c FHIR.Coding):
  case
    when c.system.value = 'http://loinc.org' then
      System.Code { system: 'http://loinc.org', code: c.code.value, display: c.display.value }
    else
      null
  end

// TODO: omit the units
define fluent function mostRecentResult(observations List<Observation>):
  FC.ResultText(observations.mostRecent())

// Lab Result FHIR Observations sorted in descending order by issue date.

define "COVID19 Lab Tests":
  ([Observation: Cx."COVID19 Lab Tests"]).resulted()

// define "Prediabetes HbA1c Tests":
//   ([Observation: Cx."Prediabetes HbA1c Tests"]).resulted()

define "Hemoglobin A1C":
  ([Observation: Cx."Hemoglobin A1C"]).resulted()

define "Estimated Glomerular Filtration Rate":
  ([Observation: Cx."Estimated Glomerular Filtration Rate"]).resulted()

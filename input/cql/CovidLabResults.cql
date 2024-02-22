library CovidLabResults version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include FHIRCommon version '1.0.0' called FC
include USCoreFHIRElements version '1.0.0' called UE
include CovidConcepts called Cx
include DataElementHelpers called DE

context Patient

/// Report QA analysis with count of resources, no PHI.
define ReportLabResultsQA: 
{
  "Lab Results Count": Count(UE."All Laboratory Results"),
  "COVID19 Lab Tests": Count("COVID19 Lab Tests"),
  "Prediabetes HbA1c Tests": Count("Prediabetes HbA1c Tests"),
  // "Hemoglobin A1C": Count("Hemoglobin A1C"),
  "Estimated Glomerular Filtration Rate": Count("Estimated Glomerular Filtration Rate"),

  "Lab Results Without Preferred Code": null
}

// Most recent FHIR Observation for each laboratory data element.
define ReportLabResults: {
  "COVID19 Lab Tests": ReportMostRecentResult("COVID19 Lab Tests"),
  "Prediabetes HbA1c Tests": ReportMostRecentResult("Prediabetes HbA1c Tests"),
  // "Hemoglobin A1C": ReportMostRecentResult("Hemoglobin A1C"),
  "Estimated Glomerular Filtration Rate": ReportMostRecentResult("Estimated Glomerular Filtration Rate")
}

define function ReportMostRecentResult(observations List<Observation>):
  ReportObservation(DE.MostRecent(observations))

// TODO convert all units to metric, omit the units
define function ReportObservation(o FHIR.Observation):
  DE.ResultText(o)

// Lab Result FHIR Observations sorted in descending order by issue date.

define "COVID19 Lab Tests":
  DE.SelectByStatus([Observation: Cx."COVID19 Lab Tests"])

define "Prediabetes HbA1c Tests":
  DE.SelectByStatus([Observation: Cx."Prediabetes HbA1c Tests"])

define "Hemoglobin A1C":
  DE.SelectByStatus([Observation: Cx."Hemoglobin A1C"])

define "Estimated Glomerular Filtration Rate":
  DE.SelectByStatus([Observation: Cx."Estimated Glomerular Filtration Rate"])

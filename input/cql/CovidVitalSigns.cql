library CovidVitalSigns version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include FHIRCommon version '1.0.0' called FC
include USCoreFHIRElements version '1.0.0' called UE
include CovidConcepts called Cx
include DataElementHelpers called DE

context Patient

/// Report QA analysis with count of resources, no PHI.
define ReportVitalSignsQA: 
{
  "Vital Signs Count": Count(UE."All Vital Signs"),
  "Blood Pressure Count": Count("Blood Pressure Observations"),
  "Oxygen Saturation Count": Count("Oxygen Saturation Observations"),
  "Body Weight Count": Count("Body Weight Observations"),
  "Body Height Count": Count("Body Height Observations"),
  "BMI Count": Count("Body Mass Index Observations"),

  "Vital Signs Without Preferred Code": null
}

// Most recent FHIR Observation for each vital sign data element.
define ReportVitalSigns: {
  "Blood Pressure": ReportMostRecentResult("Blood Pressure Observations"),
  "Systolic Blood Pressure": null,
  "Diastolic Blood Pressure": null,
  "Body Height": ReportMostRecentResult("Body Height Observations"),
  "Body Weight": ReportMostRecentResult("Body Weight Observations"),
  "BMI": ReportMostRecentResult("Body Mass Index Observations"),
  "Body Temperature": ReportMostRecentResult("Body Temperature Observations"),
  "Heart Rate": ReportMostRecentResult("Heart Rate Observations"),
  "Oxygen Saturation": ReportMostRecentResult("Oxygen Saturation Observations"),
  "Respiratory Rate": ReportMostRecentResult("Respiratory Rate Observations")
}

define function ReportMostRecentResult(observations List<Observation>):
  ReportObservation(DE.MostRecent(observations))

// TODO convert all units to metric, omit the units
define function ReportObservation(o FHIR.Observation):
  DE.ResultText(o)

// Vital Sign FHIR Observations sorted in descending order by issue date.

define "Blood Pressure Observations":
  DE.SelectByStatus([Observation: Cx."Blood pressure"])

define "Body Temperature Observations":
  DE.SelectByStatus([Observation: Cx."Body temperature"])

define "Body Height Observations":
  DE.SelectByStatus([Observation: Cx."Body height"])

define "Body Weight Observations":
  DE.SelectByStatus([Observation: Cx."Body weight"])

define "Body Mass Index Observations":
  DE.SelectByStatus([Observation: Cx."Body mass index"])

define "Heart Rate Observations":
  DE.SelectByStatus([Observation: Cx."Heart rate"])

define "Oxygen Saturation Observations":
  DE.SelectByStatus([Observation: Cx."Oxygen saturation"])

define "Respiratory Rate Observations":
  DE.SelectByStatus([Observation: Cx."Respiratory rate"])

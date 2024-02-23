library CovidVitalSigns version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include FHIRCommon version '1.0.0' called FC
include USCoreFHIRElements version '1.0.0' called UE
include CovidConcepts called Cx

context Patient

/// Report QA analysis with count of resources, no PHI.
define ReportVitalSignsQA: 
{
  "All Vital Signs": Count(UE."All Vital Signs"),
  "Blood Pressure": Count("Blood Pressure"),
  "Body Weight": Count("Body Weight"),
  "Body Height": Count("Body Height"),
  "BMI": Count("Body Mass Index"),
  "Body Temperature": Count("Body Temperature"),
  "Heart Rate": Count("Heart Rate"),
  "Oxygen Saturation": Count("Oxygen Saturation"),
  "Respiratory Rate": Count("Respiratory Rate"),

  "Vital Signs Without Preferred Code": Count("Vital Signs Without Preferred Code")
}

// Most recent FHIR Observation for each vital sign data element.
define ReportVitalSigns: {
  "Blood Pressure": "Blood Pressure".mostRecentResult(),
  "Systolic Blood Pressure": ToString("Blood Pressure".mostRecent().systolicValue()),
  "Diastolic Blood Pressure": ToString("Blood Pressure".mostRecent().diastolicValue()),
  "Body Weight": "Body Weight".mostRecentResult(),
  "Body Height": "Body Height".mostRecentResult(),
  "BMI": "Body Mass Index".mostRecentResult(),
  "Body Temperature": "Body Temperature".mostRecentResult(),
  "Heart Rate": "Heart Rate".mostRecentResult(),
  "Oxygen Saturation": "Oxygen Saturation".mostRecentResult(),
  "Respiratory Rate": "Respiratory Rate".mostRecentResult()
}

define "Vital Signs Without Preferred Code":
  UE."All Vital Signs" obs
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

// TODO convert all units to metric, omit the units
define fluent function mostRecentResult(observations List<Observation>):
  FC.ResultText(observations.mostRecent())

define fluent function systolicValue(o Observation): 
  if o.code ~ Cx."Blood pressure" then
    (singleton from (o.component C where (C.code ~ Cx."Systolic blood pressure"))).value as FHIR.Quantity
  else
    null

define fluent function diastolicValue(o Observation): 
  if o.code ~ Cx."Blood pressure" then
    (singleton from (o.component C where (C.code ~ Cx."Diastolic blood pressure"))).value as FHIR.Quantity
  else
    null

define "Blood Pressure":
  ([Observation: Cx."Blood pressure"]).resulted()

define "Body Temperature":
  ([Observation: Cx."Body temperature"]).resulted()

define "Body Height":
  ([Observation: Cx."Body height"]).resulted()

define "Body Weight":
  ([Observation: Cx."Body weight"]).resulted()

define "Body Mass Index":
  ([Observation: Cx."Body mass index"]).resulted()

define "Heart Rate":
  ([Observation: Cx."Heart rate"]).resulted()

define "Oxygen Saturation":
  ([Observation: Cx."Oxygen saturation"]).resulted()

define "Respiratory Rate":
  ([Observation: Cx."Respiratory rate"]).resulted()

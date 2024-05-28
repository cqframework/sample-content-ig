library TJCOverallExample version '8.9.000'

using QICore version '4.1.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include CQMCommonExample called CQMCommon
include QICoreCommonExample called QICoreCommon

valueset "Comfort Measures": 'http://cts.nlm.nih.gov/fhir/ValueSet/1.3.6.1.4.1.33895.1.3.0.45'
valueset "Discharge To Acute Care Facility": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.87'
valueset "Discharged to Health Care Facility for Hospice Care": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.207'
valueset "Discharged to Home for Hospice Care": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.209'
valueset "Hemorrhagic Stroke": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.212'
valueset "Ischemic Stroke": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.247'
valueset "Left Against Medical Advice": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.308'
valueset "Nonelective Inpatient Encounter": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.424'
valueset "Patient Expired": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.309'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2024-01-01T00:00:00.0, @2025-01-01T00:00:00.0)

context Patient

define "Non Elective Inpatient Encounter":
  ["Encounter": "Nonelective Inpatient Encounter"] NonElectiveEncounter
        where NonElectiveEncounter.period ends during day of "Measurement Period"

define "All Stroke Encounter":
  "Non Elective Inpatient Encounter" NonElectiveEncounter
  let ConditionCode: NonElectiveEncounter.principalDiagnosis().code
    where ( ConditionCode in "Hemorrhagic Stroke"
       or   ConditionCode in "Ischemic Stroke" )  

define "Ischemic Stroke Encounter":
  "Encounter with Principal Diagnosis and Age" EncounterWithAge
    where EncounterWithAge.principalDiagnosis().code in "Ischemic Stroke"

define "Ischemic Stroke Encounters with Discharge Disposition":
  "Ischemic Stroke Encounter" IschemicStrokeEncounter
  let DischDisp: IschemicStrokeEncounter.hospitalization.dischargeDisposition
  	where  DischDisp in "Discharge To Acute Care Facility"
		or DischDisp in "Left Against Medical Advice"
		or DischDisp in "Patient Expired"
		or DischDisp in "Discharged to Home for Hospice Care"
		or DischDisp in "Discharged to Health Care Facility for Hospice Care"			

define "Encounter with Principal Diagnosis and Age":
  "All Stroke Encounter" AllStrokeEncounter
    where AgeInYearsAt(date from start of AllStrokeEncounter.period ) >= 18

define "Comfort Measures during Hospitalization":
  "Ischemic Stroke Encounter" IschemicStrokeEncounter
    with "Intervention Comfort Measures" ComfortMeasure
     such that Coalesce(start of ComfortMeasure.performed.toInterval(), ComfortMeasure.authoredOn) during IschemicStrokeEncounter.hospitalizationWithObservation()

define "Encounter with Comfort Measures during Hospitalization":
  "Ischemic Stroke Encounter" IschemicStrokeEncounter
    with "Intervention Comfort Measures" ComfortMeasure
     such that Coalesce(start of ComfortMeasure.performed.toInterval(), ComfortMeasure.authoredOn) during IschemicStrokeEncounter.hospitalizationWithObservation()

define "Intervention Comfort Measures":
  ( ["ServiceRequest": code in "Comfort Measures"] SR
    where SR.status in { 'active', 'completed', 'on-hold' }
      and SR.intent in { 'order', 'original-order', 'reflex-order', 'filler-order', 'instance-order' }
      and SR.doNotPerform is not true
  )  
  union ( ["Procedure": "Comfort Measures"] InterventionPerformed
        where InterventionPerformed.status in { 'completed', 'in-progress' }
  )
  
define fluent function "TruncateTime"(Value DateTime ):
  DateTime(year from Value, month from Value, day from Value, 0, 0, 0, 0, timezoneoffset from Value)

define fluent function CalendarDayOfOrDayAfter(StartValue DateTime ):
  Interval[StartValue.TruncateTime(), StartValue.TruncateTime() + 2 days )
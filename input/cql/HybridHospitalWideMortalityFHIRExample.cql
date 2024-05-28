library HybridHospitalWideMortalityFHIRExample version '0.4.1'

/*This FHIR-based measure has been derived from CMS844v4.0.0 - QDM 5.6 Specifications*/

using QICore version '4.1.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers
include SupplementalDataElementsExample called SDE
include CQMCommonExample called CQMCommon
include QICoreCommonExample called QICoreCommon

codesystem "LOINC": 'http://loinc.org'
codesystem "ActCode": 'http://terminology.hl7.org/CodeSystem/v3-ActCode'
codesystem "Source of Payment Typology": 'https://nahdo.org/sopt'

valueset "Bicarbonate lab test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.139'
valueset "birth date": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.560.100.4'
valueset "Body temperature": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.152'
valueset "Creatinine lab test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.2363'
valueset "Emergency Department Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292'
valueset "Encounter Inpatient": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.666.5.307'
valueset "Ethnicity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.837'
valueset "Heart Rate": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.149'
valueset "Hematocrit lab test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.114'
valueset "Medicare payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1104.10'
valueset "Observation Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1111.143'
valueset "ONC Administrative Sex": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1'
valueset "Oxygen Saturation by Pulse Oximetry": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.151'
valueset "Payer": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591'
valueset "Platelet count lab test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.127'
valueset "Race": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.836'
valueset "Sodium lab test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.119'
valueset "Systolic Blood Pressure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.163'
valueset "White blood cells count lab test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1045.129'

code "Birthdate": '21112-8' from "LOINC" display 'Birthdate'
code "IMP": 'IMP' from "ActCode" display 'Inpatient'
code "ACUTE": 'ACUTE' from "ActCode" display 'Acute'
code "NONAC": 'NONAC' from "ActCode" display 'Nonacute'
code "OBSENC": 'OBSENC' from "ActCode" display 'Observation Encounter'

parameter "Measurement Period" Interval<DateTime>
  default Interval[@2024-01-01T00:00:00.0, @2025-01-01T00:00:00.0)

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
  "Inpatient Encounters"

define "Inpatient Encounters":
  from
    ["Encounter": "Encounter Inpatient"] InpatientEncounter,
    ["Coverage": "Medicare payer"] Payer
    where InpatientEncounter.status = 'finished'
      and ( InpatientEncounter.class ~ "IMP"
          or InpatientEncounter.class ~ "ACUTE"
          or InpatientEncounter.class ~ "NONAC"
          or InpatientEncounter.class ~ "OBSENC"
      )
      and AgeInYearsAt(date from start of InpatientEncounter.period) in Interval[65, 94]
      and InpatientEncounter.hospitalizationWithObservationLengthofStay ( ) < 365
      and InpatientEncounter.period ends during day of "Measurement Period"
    return InpatientEncounter
/*Inpatient encounter initially listed as AMB class; changed this to inpatient classes as discussed with CORE team- AM*/


define "Results":
  flatten {
    //First physical exams (vital signs)       
  "FirstPhysicalExamWithEncounterId"([Observation: "Heart Rate"], 'FirstHeartRate'), "FirstPhysicalExamWithEncounterId"([Observation: "Systolic Blood Pressure"], 'FirstSystolicBP'), "FirstPhysicalExamWithEncounterId"([Observation: "Body temperature"], 'FirstTemperature'), "FirstPhysicalExamWithEncounterId"([Observation: "Oxygen Saturation by Pulse Oximetry"], 'FirstO2Saturation'),
    //First lab tests
  "FirstLabTestWithEncounterId"([Observation: "Hematocrit lab test"], 'FirstHematocrit'), "FirstLabTestWithEncounterId"([Observation: "Platelet count lab test"], 'FirstPlateletCount'), "FirstLabTestWithEncounterId"([Observation: "White blood cells count lab test"], 'FirstWhiteBloodCell'), "FirstLabTestWithEncounterId"([Observation: "Sodium lab test"], 'FirstSodium'), "FirstLabTestWithEncounterId"([Observation: "Bicarbonate lab test"], 'FirstBicarbonate'), "FirstLabTestWithEncounterId"([Observation: "Creatinine lab test"], 'FirstCreatinine') }

define function "FirstLabTestWithEncounterId"(LabList List<Observation>, CCDE String):
  "Inpatient Encounters" Encounter
    let firstlab: First(LabList Lab
        where Lab.issued is not null
          and Lab.issued during Interval[start of Encounter.period - 1440 minutes, start of Encounter.period + 1440 minutes]
          and Lab.status in { 'final', 'amended', 'preliminary' }
          and Lab.value is not null
        sort by issued
    )
    return '\r\n' & CCDE & ',' & Encounter.id & ',' & ( ToString(firstlab.value as Quantity) ) & ',' & ToString(firstlab.issued)

define function "FirstPhysicalExamWithEncounterId"(ExamList List<Observation>, CCDE String):
  "Inpatient Encounters" Encounter
    let firstexam: First(ExamList Exam
        where start of QICoreCommon."ToInterval"(Exam.effective) is not null
          and start of QICoreCommon."ToInterval"(Exam.effective) during Interval[start of Encounter.period - 1440 minutes, start of Encounter.period + 120 minutes]
          and Exam.status in { 'final', 'amended', 'preliminary' }
          and Exam.value is not null
        sort by start of QICoreCommon."ToInterval"(effective)
    )
    return '\r\n' & CCDE & ',' & Encounter.id & ' , ' & ( ToString(firstexam.value as Quantity) ) & ',' & ToString(start of QICoreCommon."ToInterval"(firstexam.effective))
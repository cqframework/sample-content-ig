library CovidConditions version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include FHIRCommon version '4.0.1' called FC
include DataElementHelpers called DE
include CovidConcepts called Cx

context Patient

// TODO: iterate over CategorizedConditions and insert count for each (don't duplicate condition name here)
define ReportConditions: 
{
  "Acute COVID 19 Diagnosis": Count("Acute COVID 19 Diagnosis") > 0,
  "Post Acute Sequelae of Sars Cov 2 infection (PASC)": Count("Post Acute Sequelae of Sars Cov 2 infection (PASC)") > 0,
  "Acute Myocardial Infarction": Count("Acute Myocardial Infarction") > 0,
  "Ischemic Heart Disease": Count("Ischemic Heart Disease") > 0,
  "Acute Coronary Syndromes": Count("Acute Coronary Syndromes") > 0,
  "Hypertension, Primary and Secondary Diagnosis": Count("Hypertension, Primary and Secondary Diagnosis") > 0,
  "Type 1 Diabetes": Count("Type 1 Diabetes") > 0,
  "Type II Diabetes": Count("Type II Diabetes") > 0,
  "Chronic kidney disease all stages (1 through 5)": Count("Chronic kidney disease all stages (1 through 5)") > 0,

  "Chronic Pain Conditions": Count("Chronic Pain Conditions") > 0,
  "PostTraumatic stress disorder PTSD": Count("PostTraumatic stress disorder PTSD") > 0,
  "Food insecurity diagnoses": Count("Food insecurity diagnoses") > 0,

  OtherConditions: PreferredConditionCodes(OtherConditions)
}

define CategorizedConditions: 
  "Acute COVID 19 Diagnosis"
  union "Post Acute Sequelae of Sars Cov 2 infection (PASC)"
  union "Acute Myocardial Infarction"
  union "Ischemic Heart Disease"
  union "Acute Coronary Syndromes"
  union "Hypertension, Primary and Secondary Diagnosis"
  union "Type 1 Diabetes"
  union "Type II Diabetes"
  union "Chronic kidney disease all stages (1 through 5)"

/// Returns a list of Resource.id for all categorized conditions.
define CategorizedConditionIds:
  flatten( CategorizedConditions C
    return { C.id }
  )

/// Returns a list of Conditions that are not classified into CategorizedConditions.
define OtherConditions:
  AllActiveConditions C
    where not (C.id in CategorizedConditionIds)

define ReportOtherConditions: 
  OtherConditions C
    return ReportCondition(C)
  
define function ReportCondition(condition Condition):
  {
    id: condition.id.value,
    code: PreferredConditionConcept(condition.code).code,
    display: DE.ConceptText(condition.code)
  }

define function PreferredConditionCodes(conditions List<Condition>):
  conditions C
    where PreferredConditionConcept(C.code) is not null
    return PreferredConditionConcept(C.code).code
  
// Returns a System.Code with sytem and code parameters
define function PreferredConditionConcept(concept FHIR.CodeableConcept):
  First(
    concept.coding c
      let preferredCode: PreferredConditionCoding(c)
      where preferredCode.code is not null
      return preferredCode
  )

define function PreferredConditionCoding(c FHIR.Coding):
  case
    when c.system.value = 'http://snomed.info/sct' or c.system.value = 'urn:oid:2.16.840.1.113883.6.96' then
      System.Code { system: 'http://snomed.info/sct', code: c.code.value, display: c.display.value }
    when c.system.value = 'http://hl7.org/fhir/sid/icd-10-cm' or c.system.value = 'urn:oid:2.16.840.1.113883.6.90' then
      System.Code { system: 'http://hl7.org/fhir/sid/icd-10-cm', code: c.code.value, display: c.display.value }
    else
      null
  end

define function SelectActiveConditions(conditions List<Condition>):
  conditions Cond
    where (Cond.clinicalStatus ~ FC."active"
          or Cond.clinicalStatus ~ FC."relapse"
          or Cond.clinicalStatus ~ FC."recurrence")
      and Cond.verificationStatus ~ FC."confirmed"
    sort by recordedDate.value descending

/// All active conditions sorted in descending order by recorded or onset date.
define AllActiveConditions:
  [Condition] C
    sort by Coalesce(recordedDate.value, (onset as FHIR.dateTime).value) descending

//
// Select all active Conditions
//

define "Acute COVID 19 Diagnosis":
  SelectActiveConditions([Condition: Cx."Acute COVID 19 Diagnosis"])

define "Post Acute Sequelae of Sars Cov 2 infection (PASC)":
  SelectActiveConditions([Condition: Cx."Post Acute Sequelae of Sars Cov 2 infection (PASC)"])

define "Acute Myocardial Infarction":
  SelectActiveConditions([Condition: Cx."Acute Myocardial Infarction"])

define "Ischemic Heart Disease":
  SelectActiveConditions([Condition: Cx."Ischemic Heart Disease"])

define "Acute Coronary Syndromes":
  SelectActiveConditions([Condition: Cx."Acute Coronary Syndromes"])

define "Bronchiectasis Diagnosis":
  SelectActiveConditions([Condition: Cx."Bronchiectasis Diagnosis"])



define "Chronic kidney disease all stages (1 through 5)":
  SelectActiveConditions([Condition: Cx."Chronic kidney disease all stages (1 through 5)"])

define "Type 1 Diabetes":
  SelectActiveConditions([Condition: Cx."Type 1 Diabetes"])

define "Type II Diabetes":
  SelectActiveConditions([Condition: Cx."Type II Diabetes"])

define "Hypertension, Primary and Secondary Diagnosis":
  SelectActiveConditions([Condition: Cx."Hypertension, Primary and Secondary Diagnosis"])



define "Chronic Pain Conditions":
  SelectActiveConditions([Condition: Cx."Chronic Pain Conditions"])

define "PostTraumatic stress disorder PTSD":
  SelectActiveConditions([Condition: Cx."PostTraumatic stress disorder PTSD"])

define "Food insecurity diagnoses":
  SelectActiveConditions([Condition: Cx."Food insecurity diagnoses"])


// valueset "Bronchiectasis Diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.1463'
// valueset "Hypertension, Pulmonary hypertension": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.1484'
// valueset "Pulmonary embolism diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.1481'
// valueset "Cerebrovascular disease diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.1549'
// valueset "Chronic kidney disease all stages (1 through 5)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.159'
// valueset "Cirrhosis or other liver disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1029.63'
// valueset "Chronic obstructive pulmonary disease (COPD) Diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.1466'
// valueset "Type 1 Diabetes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.103.12.1020'
// valueset "Type II Diabetes": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.103.12.1021'
// valueset "Heart Failure Diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.1543'
// valueset "Coronary Artery Disease No MI": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.369'
// valueset "Cardiomyopathy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.579'
// valueset "Interstitial lung disease diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.1469'
// valueset "Ever tobacco smoker": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1078.504'
// valueset "Tuberculosis Disorders": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.43'
// valueset "Obesity Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.36'
// valueset "Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.1566'
// valueset "Depression Diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.600.145'
// valueset "Schizophrenia": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.105.12.1205'
// valueset "HIV ": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.120.12.1003'
// valueset "Dementia and Related Intracranial Pathologies": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.3157.4043'
// valueset "Overweight or Obese": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1047.502'
// valueset "Sickle cell disease and related blood disorders": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1029.35'
// valueset "Substance abuse": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.106.12.1004'
// valueset "Cystic fibrosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.102.12.1002'
// valueset "Thalassemia": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.773'
// valueset "Asthma diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.1472'
// valueset "Hypertension, Primary and Secondary Diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.1547'
// valueset "Chronic Pain Conditions": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.76'
// valueset "PostTraumatic stress disorder PTSD": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.103'
// valueset "Myalgic Encephalomyelitis or Chronic Fatigue Syndrome": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.675'
// valueset "Postural tachycardia syndrome (POTS) Diagnosis": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.1488'
// valueset "Ehlers-Danlos syndrome": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.1505'
// valueset "Stroke": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.618'
// valueset "Food insecurity diagnoses": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1247.17'
// valueset "Housing insecurity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1222.1290'
// valueset "Transportation insecurity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1247.26'

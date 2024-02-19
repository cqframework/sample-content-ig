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

define "Hypertension, Primary and Secondary Diagnosis":
  SelectActiveConditions([Condition: Cx."Hypertension, Primary and Secondary Diagnosis"])

define "Chronic kidney disease all stages (1 through 5)":
  SelectActiveConditions([Condition: Cx."Chronic kidney disease all stages (1 through 5)"])

define "Type 1 Diabetes":
  SelectActiveConditions([Condition: Cx."Type 1 Diabetes"])

define "Type II Diabetes":
  SelectActiveConditions([Condition: Cx."Type II Diabetes"])

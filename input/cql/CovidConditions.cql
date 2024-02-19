library CovidConditions version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include FHIRCommon version '4.0.1' called FC
include DataElementHelpers called DE
include CovidConcepts called Cx

context Patient

define ReportConditions: 
{
  CardiovascularDisease: Count(CardiovascularDiseaseConditions) > 0,
  Diabetes: Count(DiabetesConditions) > 0,
  CKD: Count(ChronicKidneyDiseaseConditions) > 0,
  OtherConditions: PreferredConditionCodes(OtherConditions)
}

define CategorizedConditions: 
  CardiovascularDiseaseConditions
  union DiabetesConditions
  union ChronicKidneyDiseaseConditions

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
// Cardiovascular Conditions
//

define CardiovascularDiseaseConditions:
  "Hypertension Conditions"
  union "Heart Attack Conditions"
  union "Heart Failure"

define "Hypertension Conditions":
  "Hypertension, Persistent"
    union "Hypertension, Primary and Secondary"
    union "Hypertension, Essential or Primary"
    union "Hypertension, Pulmonary Hypertension"

define "Heart Attack Conditions":
  "Acute Coronary Syndromes"
    union "Acute Myocardial Infarction"

define "Acute Coronary Syndromes":
  SelectActiveConditions([Condition: Cx."Acute Coronary Syndromes"])

define "Acute Myocardial Infarction":
  SelectActiveConditions([Condition: Cx."Acute Myocardial Infarction"])

define "Heart Failure":
  SelectActiveConditions([Condition: Cx."Heart Failure"])

define "Hypertension, Persistent":
  SelectActiveConditions([Condition: Cx."Hypertension, Persistent"])

define "Hypertension, Primary and Secondary":
  SelectActiveConditions([Condition: Cx."Hypertension, Primary and Secondary"])

define "Hypertension, Essential or Primary":
  SelectActiveConditions([Condition: Cx."Hypertension, Essential or Primary"])

define "Hypertension, Pulmonary Hypertension":
  SelectActiveConditions([Condition: Cx."Hypertension, Pulmonary Hypertension"])

define ChronicKidneyDiseaseConditions:
  SelectActiveConditions([Condition: Cx."Chronic Kidney Disease All Stages"])
    // union "Acute Renal Failure"

define DiabetesConditions:
  SelectActiveConditions([Condition: Cx."Type 1 Diabetes"])
  union SelectActiveConditions([Condition: Cx."Type II Diabetes"])

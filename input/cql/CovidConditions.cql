library CovidConditions version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include FHIRCommon version '1.0.0' called FC
include USCoreFHIRElements version '1.0.0' called UE
include CovidConcepts called Cx

context Patient

/// Report QA analysis with count of resources, no PHI.
define ReportConditionsQA: 
{
  "All Conditions": Count(UE."All Conditions"),
  "Active Problem List": Count(UE."Active Confirmed Problem List Items"),
  "Inactive Problem List": Count("Inactive Problem List"),
  "Encounter Diagnoses": Count(UE."All Encounter Diagnoses"),
  "Uncategorized Conditions": Count("Uncategorized Conditions"),
  "Conditions Without Preferred Code": Count("Conditions Without Preferred Code")
}

/// Report boolean values for input to ML model. Also list of codes for active problem list items.
define ReportConditions: 
{
  "Acute COVID 19 Diagnosis": Count("Acute COVID 19 Diagnosis") > 0,
  "Post Acute Sequelae of Sars Cov 2 infection (PASC)": Count("Post Acute Sequelae of Sars Cov 2 infection (PASC)") > 0,
  "Acute Myocardial Infarction": Count("Acute Myocardial Infarction") > 0,
  "Ischemic Heart Disease": Count("Ischemic Heart Disease") > 0,
  "Acute Coronary Syndromes": Count("Acute Coronary Syndromes") > 0,
  "Bronchiectasis Diagnosis": Count("Bronchiectasis Diagnosis") > 0,
  "Hypertension, Pulmonary hypertension": Count("Hypertension, Pulmonary hypertension") > 0,
  "Pulmonary embolism diagnosis": Count("Pulmonary embolism diagnosis") > 0,
  "Cerebrovascular disease diagnosis": Count("Cerebrovascular disease diagnosis") > 0,
  "Chronic kidney disease all stages (1 through 5)": Count("Chronic kidney disease all stages (1 through 5)") > 0,
  "Cirrhosis or other liver disease": Count("Cirrhosis or other liver disease") > 0,
  "Chronic obstructive pulmonary disease (COPD) Diagnosis": Count("Chronic obstructive pulmonary disease (COPD) Diagnosis") > 0,
  "Type 1 Diabetes": Count("Type 1 Diabetes") > 0,
  "Type II Diabetes": Count("Type II Diabetes") > 0,
  "Heart Failure Diagnosis": Count("Heart Failure Diagnosis") > 0,
  "Coronary Artery Disease No MI": Count("Coronary Artery Disease No MI") > 0,
  "Cardiomyopathy": Count("Cardiomyopathy") > 0,
  "Interstitial lung disease diagnosis": Count("Interstitial lung disease diagnosis") > 0,
  "Ever tobacco smoker": Count("Ever tobacco smoker") > 0,
  "Tuberculosis Disorders": Count("Tuberculosis Disorders") > 0,
  "Obesity Conditions": Count("Obesity Conditions") > 0,
  "Pregnancy": Count("Pregnancy") > 0,
  "Depression Diagnosis": Count("Depression Diagnosis") > 0,
  "Schizophrenia": Count("Schizophrenia") > 0,
  "HIV": Count("HIV") > 0,
  "Dementia and Related Intracranial Pathologies": Count("Dementia and Related Intracranial Pathologies") > 0,
  "Overweight or Obese": Count("Overweight or Obese") > 0,
  "Sickle cell disease and related blood disorders": Count("Sickle cell disease and related blood disorders") > 0,
  "Substance abuse": Count("Substance abuse") > 0,
  "Cystic fibrosis": Count("Cystic fibrosis") > 0,
  "Thalassemia": Count("Thalassemia") > 0,
  "Asthma diagnosis": Count("Asthma diagnosis") > 0,
  "Hypertension, Primary and Secondary Diagnosis": Count("Hypertension, Primary and Secondary Diagnosis") > 0,
  "Chronic Pain Conditions": Count("Chronic Pain Conditions") > 0,
  "PostTraumatic stress disorder PTSD": Count("PostTraumatic stress disorder PTSD") > 0,
  "Myalgic Encephalomyelitis or Chronic Fatigue Syndrome": Count("Myalgic Encephalomyelitis or Chronic Fatigue Syndrome") > 0,
  "Postural tachycardia syndrome (POTS) Diagnosis": Count("Postural tachycardia syndrome (POTS) Diagnosis") > 0,
  "Ehlers-Danlos syndrome": Count("Ehlers-Danlos syndrome") > 0,
  "Stroke": Count("Stroke") > 0,
  "Food insecurity diagnoses": Count("Food insecurity diagnoses") > 0,
  "Housing insecurity": Count("Housing insecurity") > 0,
  "Transportation insecurity": Count("Transportation insecurity") > 0,

  "Problem List Codes": UE."Active Confirmed Problem List Items".preferredCodes()
}

define "Inactive Problem List":
  UE."All Problem List Items" condition
    where condition.isActive() is not true
      or condition.isConfirmed() is not true

define "Uncategorized Conditions":
  UE."All Conditions" condition
    where condition.isProblemListItem() is not true
      and condition.isEncounterDiagnosis() is not true

define "Conditions Without Preferred Code":
  UE."All Conditions" condition
    where condition.preferredCode() is null

define fluent function preferredCodes(conditions List<Condition>):
  conditions condition
    where condition.preferredCode() is not null
    return condition.preferredCode().code
  
// Returns a System.Code with sytem and code parameters
define fluent function preferredCode(condition Condition):
  First(
    condition.code.coding c
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

//
// Use value sets to categorize active, confirmed Conditions
//

define "Acute COVID 19 Diagnosis":
  ([Condition: Cx."Acute COVID 19 Diagnosis"]).active().confirmed()

define "Post Acute Sequelae of Sars Cov 2 infection (PASC)":
  ([Condition: Cx."Post Acute Sequelae of Sars Cov 2 infection (PASC)"]).active().confirmed()

define "Acute Myocardial Infarction":
  ([Condition: Cx."Acute Myocardial Infarction"]).active().confirmed()

define "Ischemic Heart Disease":
  ([Condition: Cx."Ischemic Heart Disease"]).active().confirmed()

define "Acute Coronary Syndromes":
  ([Condition: Cx."Acute Coronary Syndromes"]).active().confirmed()

define "Bronchiectasis Diagnosis":
  ([Condition: Cx."Bronchiectasis Diagnosis"]).active().confirmed()

define "Hypertension, Pulmonary hypertension":
  ([Condition: Cx."Hypertension, Pulmonary hypertension"]).active().confirmed()

define "Pulmonary embolism diagnosis":
  ([Condition: Cx."Pulmonary embolism diagnosis"]).active().confirmed()

define "Cerebrovascular disease diagnosis":
  ([Condition: Cx."Cerebrovascular disease diagnosis"]).active().confirmed()

define "Chronic kidney disease all stages (1 through 5)":
  ([Condition: Cx."Chronic kidney disease all stages (1 through 5)"]).active().confirmed()

define "Cirrhosis or other liver disease":
  ([Condition: Cx."Cirrhosis or other liver disease"]).active().confirmed()

define "Chronic obstructive pulmonary disease (COPD) Diagnosis":
  ([Condition: Cx."Chronic obstructive pulmonary disease (COPD) Diagnosis"]).active().confirmed()

define "Type 1 Diabetes":
  ([Condition: Cx."Type 1 Diabetes"]).active().confirmed()

define "Type II Diabetes":
  ([Condition: Cx."Type II Diabetes"]).active().confirmed()

define "Heart Failure Diagnosis":
  ([Condition: Cx."Heart Failure Diagnosis"]).active().confirmed()

define "Coronary Artery Disease No MI":
  ([Condition: Cx."Coronary Artery Disease No MI"]).active().confirmed()

define "Cardiomyopathy":
  ([Condition: Cx."Cardiomyopathy"]).active().confirmed()

define "Interstitial lung disease diagnosis":
  ([Condition: Cx."Interstitial lung disease diagnosis"]).active().confirmed()

define "Ever tobacco smoker":
  ([Condition: Cx."Ever tobacco smoker"]).active().confirmed()

define "Tuberculosis Disorders":
  ([Condition: Cx."Tuberculosis Disorders"]).active().confirmed()

define "Obesity Conditions":
  ([Condition: Cx."Obesity Conditions"]).active().confirmed()

define "Pregnancy":
  ([Condition: Cx."Pregnancy"]).active().confirmed()

define "Depression Diagnosis":
  ([Condition: Cx."Depression Diagnosis"]).active().confirmed()

define "Schizophrenia":
  ([Condition: Cx."Schizophrenia"]).active().confirmed()

define "HIV":
  ([Condition: Cx."HIV"]).active().confirmed()

define "Dementia and Related Intracranial Pathologies":
  ([Condition: Cx."Dementia and Related Intracranial Pathologies"]).active().confirmed()

define "Overweight or Obese":
  ([Condition: Cx."Overweight or Obese"]).active().confirmed()

define "Sickle cell disease and related blood disorders":
  ([Condition: Cx."Sickle cell disease and related blood disorders"]).active().confirmed()

define "Substance abuse":
  ([Condition: Cx."Substance abuse"]).active().confirmed()

define "Cystic fibrosis":
  ([Condition: Cx."Cystic fibrosis"]).active().confirmed()

define "Thalassemia":
  ([Condition: Cx."Thalassemia"]).active().confirmed()

define "Asthma diagnosis":
  ([Condition: Cx."Asthma diagnosis"]).active().confirmed()

define "Hypertension, Primary and Secondary Diagnosis":
  ([Condition: Cx."Hypertension, Primary and Secondary Diagnosis"]).active().confirmed()

define "Chronic Pain Conditions":
  ([Condition: Cx."Chronic Pain Conditions"]).active().confirmed()

define "PostTraumatic stress disorder PTSD":
  ([Condition: Cx."PostTraumatic stress disorder PTSD"]).active().confirmed()

define "Myalgic Encephalomyelitis or Chronic Fatigue Syndrome":
  ([Condition: Cx."Myalgic Encephalomyelitis or Chronic Fatigue Syndrome"]).active().confirmed()

define "Postural tachycardia syndrome (POTS) Diagnosis":
  ([Condition: Cx."Postural tachycardia syndrome (POTS) Diagnosis"]).active().confirmed()

define "Ehlers-Danlos syndrome":
  ([Condition: Cx."Ehlers-Danlos syndrome"]).active().confirmed()

define "Stroke":
  ([Condition: Cx."Stroke"]).active().confirmed()

define "Food insecurity diagnoses":
  ([Condition: Cx."Food insecurity diagnoses"]).active().confirmed()

define "Housing insecurity":
  ([Condition: Cx."Housing insecurity"]).active().confirmed()

define "Transportation insecurity":
  ([Condition: Cx."Transportation insecurity"]).active().confirmed()


/*
// TODO complete this list of all categorized conditions if you want a separate list of other, uncategorized conditions.
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
*/

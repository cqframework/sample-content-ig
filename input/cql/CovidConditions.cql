library CovidConditions version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include FHIRCommon version '4.0.1' called FC
include DataElementHelpers called DE
include CovidConcepts called Cx

context Patient

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

  "Condition Codes": PreferredConditionCodes(AllActiveConditions)
}

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

//
// Use value sets to categorize active Conditions
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

define "Hypertension, Pulmonary hypertension":
  SelectActiveConditions([Condition: Cx."Hypertension, Pulmonary hypertension"])

define "Pulmonary embolism diagnosis":
  SelectActiveConditions([Condition: Cx."Pulmonary embolism diagnosis"])

define "Cerebrovascular disease diagnosis":
  SelectActiveConditions([Condition: Cx."Cerebrovascular disease diagnosis"])

define "Chronic kidney disease all stages (1 through 5)":
  SelectActiveConditions([Condition: Cx."Chronic kidney disease all stages (1 through 5)"])

define "Cirrhosis or other liver disease":
  SelectActiveConditions([Condition: Cx."Cirrhosis or other liver disease"])

define "Chronic obstructive pulmonary disease (COPD) Diagnosis":
  SelectActiveConditions([Condition: Cx."Chronic obstructive pulmonary disease (COPD) Diagnosis"])

define "Type 1 Diabetes":
  SelectActiveConditions([Condition: Cx."Type 1 Diabetes"])

define "Type II Diabetes":
  SelectActiveConditions([Condition: Cx."Type II Diabetes"])

define "Heart Failure Diagnosis":
  SelectActiveConditions([Condition: Cx."Heart Failure Diagnosis"])

define "Coronary Artery Disease No MI":
  SelectActiveConditions([Condition: Cx."Coronary Artery Disease No MI"])

define "Cardiomyopathy":
  SelectActiveConditions([Condition: Cx."Cardiomyopathy"])

define "Interstitial lung disease diagnosis":
  SelectActiveConditions([Condition: Cx."Interstitial lung disease diagnosis"])

define "Ever tobacco smoker":
  SelectActiveConditions([Condition: Cx."Ever tobacco smoker"])

define "Tuberculosis Disorders":
  SelectActiveConditions([Condition: Cx."Tuberculosis Disorders"])

define "Obesity Conditions":
  SelectActiveConditions([Condition: Cx."Obesity Conditions"])

define "Pregnancy":
  SelectActiveConditions([Condition: Cx."Pregnancy"])

define "Depression Diagnosis":
  SelectActiveConditions([Condition: Cx."Depression Diagnosis"])

define "Schizophrenia":
  SelectActiveConditions([Condition: Cx."Schizophrenia"])

define "HIV":
  SelectActiveConditions([Condition: Cx."HIV"])

define "Dementia and Related Intracranial Pathologies":
  SelectActiveConditions([Condition: Cx."Dementia and Related Intracranial Pathologies"])

define "Overweight or Obese":
  SelectActiveConditions([Condition: Cx."Overweight or Obese"])

define "Sickle cell disease and related blood disorders":
  SelectActiveConditions([Condition: Cx."Sickle cell disease and related blood disorders"])

define "Substance abuse":
  SelectActiveConditions([Condition: Cx."Substance abuse"])

define "Cystic fibrosis":
  SelectActiveConditions([Condition: Cx."Cystic fibrosis"])

define "Thalassemia":
  SelectActiveConditions([Condition: Cx."Thalassemia"])

define "Asthma diagnosis":
  SelectActiveConditions([Condition: Cx."Asthma diagnosis"])

define "Hypertension, Primary and Secondary Diagnosis":
  SelectActiveConditions([Condition: Cx."Hypertension, Primary and Secondary Diagnosis"])

define "Chronic Pain Conditions":
  SelectActiveConditions([Condition: Cx."Chronic Pain Conditions"])

define "PostTraumatic stress disorder PTSD":
  SelectActiveConditions([Condition: Cx."PostTraumatic stress disorder PTSD"])

define "Myalgic Encephalomyelitis or Chronic Fatigue Syndrome":
  SelectActiveConditions([Condition: Cx."Myalgic Encephalomyelitis or Chronic Fatigue Syndrome"])

define "Postural tachycardia syndrome (POTS) Diagnosis":
  SelectActiveConditions([Condition: Cx."Postural tachycardia syndrome (POTS) Diagnosis"])

define "Ehlers-Danlos syndrome":
  SelectActiveConditions([Condition: Cx."Ehlers-Danlos syndrome"])

define "Stroke":
  SelectActiveConditions([Condition: Cx."Stroke"])

define "Food insecurity diagnoses":
  SelectActiveConditions([Condition: Cx."Food insecurity diagnoses"])

define "Housing insecurity":
  SelectActiveConditions([Condition: Cx."Housing insecurity"])

define "Transportation insecurity":
  SelectActiveConditions([Condition: Cx."Transportation insecurity"])


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

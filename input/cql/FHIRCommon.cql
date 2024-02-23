library FHIRCommon version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct'
codesystem "CVX": 'http://hl7.org/fhir/sid/cvx'
codesystem "ActCode": 'http://terminology.hl7.org/CodeSystem/v3-ActCode'
codesystem "RoleCode": 'http://terminology.hl7.org/CodeSystem/v3-RoleCode'
codesystem "Diagnosis Role": 'http://terminology.hl7.org/CodeSystem/diagnosis-role'
codesystem "RequestIntent": 'http://hl7.org/fhir/request-intent'
codesystem "MedicationRequestCategory": 'http://terminology.hl7.org/CodeSystem/medicationrequest-category'
codesystem "ConditionClinicalStatusCodes": 'http://terminology.hl7.org/CodeSystem/condition-clinical'
codesystem "ConditionVerificationStatusCodes": 'http://terminology.hl7.org/CodeSystem/condition-ver-status'
codesystem "AllergyIntoleranceClinicalStatusCodes": 'http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical'
codesystem "AllergyIntoleranceVerificationStatusCodes": 'http://terminology.hl7.org/CodeSystem/allergyintolerance-verification'
codesystem "ObservationCategoryCodes": 'http://terminology.hl7.org/CodeSystem/observation-category'
codesystem "USCoreObservationCategory": 'http://hl7.org/fhir/us/core/CodeSystem/us-core-observation-category'
codesystem "ObservationStatusCodes": 'http://hl7.org/fhir/observation-status'
codesystem "ConditionCategory": 'http://terminology.hl7.org/CodeSystem/condition-category'
codesystem "USCoreConditionCategory": 'http://hl7.org/fhir/us/core/CodeSystem/condition-category'
codesystem "CDC Race and Ethnicity Codes": 'urn:oid:2.16.840.1.113883.6.238'
codesystem "CommunicationCategoryCodeSystem": 'http://terminology.hl7.org/CodeSystem/communication-category'
codesystem "IdentifierType": 'http://terminology.hl7.org/CodeSystem/v2-0203'

code "MedicalRecordNumber": 'MR' from "IdentifierType" display 'Medical record number'

code "Birthdate": '21112-8' from "LOINC" display 'Birth date'
code "Dead": '419099009' from "SNOMEDCT" display 'Dead'
code "ER": 'ER' from "RoleCode" display 'Emergency room'
code "ICU": 'ICU' from "RoleCode" display 'Intensive care unit'
code "Billing": 'billing' from "Diagnosis Role" display 'Billing'

// Encounter Class Codes
code "ambulatory": 'AMB' from ActCode display 'ambulatory'
code "emergency": 'EMER' from ActCode display 'emergency'
code "field": 'FLD' from ActCode display 'field'
code "home health": 'HH' from ActCode display 'home health'
code "inpatient encounter": 'IMP' from ActCode display 'inpatient encounter'
code "inpatient acute": 'ACUTE' from ActCode display 'inpatient acute'
code "inpatient non-acute": 'NONAC' from ActCode display 'inpatient non-acute'
code "observation encounter": 'OBSENC' from ActCode display 'observation encounter'
code "pre-admission": 'PRENC' from ActCode display 'pre-admission'
code "short stay": 'SS' from ActCode display 'short stay'
code "virtual": 'VR' from ActCode display 'VR'

// Condition Category Codes
code "problem-list-item": 'problem-list-item' from "ConditionCategory" display 'Problem List Item'
code "encounter-diagnosis": 'encounter-diagnosis' from "ConditionCategory" display 'Encounter Diagnosis'
code "health-concern": 'health-concern' from "USCoreConditionCategory" display 'Health Concern'

// Condition Clinical Status Codes - Consider value sets for these
code "active": 'active' from "ConditionClinicalStatusCodes"
code "recurrence": 'recurrence' from "ConditionClinicalStatusCodes"
code "relapse": 'relapse' from "ConditionClinicalStatusCodes"
code "inactive": 'inactive' from "ConditionClinicalStatusCodes"
code "remission": 'remission' from "ConditionClinicalStatusCodes"
code "resolved": 'resolved' from "ConditionClinicalStatusCodes"

// Condition Verification Status Codes - Consider value sets for these
code "unconfirmed": 'unconfirmed' from ConditionVerificationStatusCodes
code "provisional": 'provisional' from ConditionVerificationStatusCodes
code "differential": 'differential' from ConditionVerificationStatusCodes
code "confirmed": 'confirmed' from ConditionVerificationStatusCodes
code "refuted": 'refuted' from ConditionVerificationStatusCodes
code "entered-in-error": 'entered-in-error' from ConditionVerificationStatusCodes

code "allergy-active": 'active' from "AllergyIntoleranceClinicalStatusCodes"
code "allergy-inactive": 'inactive' from "AllergyIntoleranceClinicalStatusCodes"
code "allergy-resolved": 'resolved' from "AllergyIntoleranceClinicalStatusCodes"

// Allergy/Intolerance Verification Status Codes - Consider value sets for these
code "allergy-unconfirmed": 'unconfirmed' from AllergyIntoleranceVerificationStatusCodes
code "allergy-confirmed": 'confirmed' from AllergyIntoleranceVerificationStatusCodes
code "allergy-refuted": 'refuted' from AllergyIntoleranceVerificationStatusCodes

// MedicationRequest Category Codes
code "Inpatient": 'inpatient' from "MedicationRequestCategory" display 'Inpatient'
code "Outpatient": 'outpatient' from "MedicationRequestCategory" display 'Outpatient'
code "Community": 'community' from "MedicationRequestCategory" display 'Community'
code "Discharge": 'discharge' from "MedicationRequestCategory" display 'Discharge'

// Diagnosis Role Codes
code "AD": 'AD' from "Diagnosis Role" display 'Admission diagnosis'
code "DD": 'DD' from "Diagnosis Role" display 'Discharge diagnosis'
code "CC": 'CC' from "Diagnosis Role" display 'Chief complaint'
code "CM": 'CM' from "Diagnosis Role" display 'Comorbidity diagnosis'
code "pre-op": 'pre-op' from "Diagnosis Role" display 'pre-op diagnosis'
code "post-op": 'post-op' from "Diagnosis Role" display 'post-op diagnosis'
code "billing": 'billing' from "Diagnosis Role" display 'billing diagnosis'

// Observation Category Codes
code "social-history": 'social-history' from "ObservationCategoryCodes" display 'Social History'
code "vital-signs": 'vital-signs' from "ObservationCategoryCodes" display 'Vital Signs'
code "imaging": 'imaging' from "ObservationCategoryCodes" display 'Imaging'
code "laboratory": 'laboratory' from "ObservationCategoryCodes" display 'Laboratory'
code "procedure": 'procedure' from "ObservationCategoryCodes" display 'Procedure'
code "survey": 'survey' from "ObservationCategoryCodes" display 'Survey'
code "exam": 'exam' from "ObservationCategoryCodes" display 'Exam'
code "therapy": 'therapy' from "ObservationCategoryCodes" display 'Therapy'
code "activity": 'activity' from "ObservationCategoryCodes" display 'Activity'
code "clinical-test": 'clinical-test' from "USCoreObservationCategory" display 'Clinical Test'

// Observation Status Codes
code "observation-registered": 'registered' from "ObservationStatusCodes" display 'Registered'
code "observation-preliminary": 'preliminary' from "ObservationStatusCodes" display 'Preliminary'
code "observation-final": 'final' from "ObservationStatusCodes" display 'Final'
code "observation-amended": 'amended' from "ObservationStatusCodes" display 'Amended'
code "observation-corrected": 'corrected' from "ObservationStatusCodes" display 'Corrected'
code "observation-cancelled": 'cancelled' from "ObservationStatusCodes" display 'Cancelled'
code "observation-entered-in-error": 'entered-in-error' from "ObservationStatusCodes" display 'Entered in Error'
code "observation-unknown": 'unknown' from "ObservationStatusCodes" display 'Unknown'

code "Blood pressure": '85354-9' from "LOINC" display 'Blood pressure systolic and diastolic'
code "Systolic blood pressure": '8480-6' from "LOINC" display 'Systolic blood pressure'
code "Diastolic blood pressure": '8462-4' from "LOINC" display 'Diastolic blood pressure'

context Patient

/* Candidates for FHIRCommon */

/*
@description: Returns true if the given condition has a clinical status of active, recurrence, or relapse
*/
define fluent function isActive(condition Condition):
  condition.clinicalStatus ~ "active"
    or condition.clinicalStatus ~ "recurrence"
    or condition.clinicalStatus ~ "relapse"

define fluent function active(conditions List<Condition>):
  conditions C
    where C.clinicalStatus ~ "active"
      or C.clinicalStatus ~ "recurrence"
      or C.clinicalStatus ~ "relapse"

define fluent function isAllergyActive(allergyIntolerance AllergyIntolerance):
  allergyIntolerance.clinicalStatus ~ "allergy-active"

define fluent function allergyActive(allergyIntolerances List<AllergyIntolerance>):
  allergyIntolerances A
    where A.clinicalStatus ~ "allergy-active"

define fluent function isAllergyInactive(allergyIntolerance AllergyIntolerance):
  allergyIntolerance.clinicalStatus ~ "allergy-inactive"

define fluent function allergyInactive(allergyIntolerances List<AllergyIntolerance>):
  allergyIntolerances A
    where A.clinicalStatus ~ "allergy-inactive"

define fluent function isAllergyResolved(allergyIntolerance AllergyIntolerance):
  allergyIntolerance.clinicalStatus ~ "allergy-resolved"

define fluent function allergyResolved(allergyIntolerances List<AllergyIntolerance>):
  allergyIntolerances A
    where A.clinicalStatus ~ "allergy-resolved"

define fluent function isAllergyConfirmed(allergyIntolerance AllergyIntolerance):
  allergyIntolerance.verificationStatus ~ "allergy-confirmed"

define fluent function allergyConfirmed(allergyIntolerances List<AllergyIntolerance>):
  allergyIntolerances A
    where A.verificationStatus ~ "allergy-confirmed"

define fluent function isAllergyUnconfirmed(allergyIntolerance AllergyIntolerance):
  allergyIntolerance.verificationStatus ~ "allergy-unconfirmed"

define fluent function allergyUnconfirmed(allergyIntolerances AllergyIntolerance):
  allergyIntolerances A
    where A.verificationStatus ~ "allergy-unconfirmed"

define fluent function isAllergyRefuted(allergyIntolerance AllergyIntolerance):
  allergyIntolerance.verificationStatus ~ "allergy-refuted"

define fluent function allergyRefuted(allergyIntolerances AllergyIntolerance):
  allergyIntolerances A
    where A.verificationStatus ~ "allergy-refuted"

/*
@description: Returns true if the given condition has the given category
*/
define fluent function hasCategory(condition Condition, category Code):
  exists (condition.category C
    where C ~ category
  )

/*
@description: Returns true if the given condition is a problem list item.
*/
define fluent function isProblemListItem(condition Condition):
  exists (condition.category C
    where C ~ "problem-list-item"
  )

/*
@description: Returns true if the given condition is an encounter diagnosis
*/
define fluent function isEncounterDiagnosis(condition Condition):
  exists (condition.category C
    where C ~ "encounter-diagnosis"
  )

/*
@description: Returns true if the given condition is a health concern
*/
define fluent function isHealthConcern(condition Condition):
  exists (condition.category C
    where C ~ "health-concern"
  )

define fluent function isUnconfirmed(condition Condition):
  condition.verificationStatus ~ "unconfirmed"

define fluent function unconfirmed(conditions List<Condition>):
  conditions C
    where C.verificationStatus ~ "unconfirmed"

define fluent function isProvisional(condition Condition):
  condition.verificationStatus ~ "provisional"

define fluent function provisional(conditions List<Condition>):
  conditions C
    where C.verificationStatus ~ "provisional"

define fluent function isDifferential(condition Condition):
  condition.verificationStatus ~ "differential"

define fluent function differential(conditions List<Condition>):
  conditions C
    where C.verificationStatus ~ "differential"

define fluent function isConfirmed(condition Condition):
  condition.verificationStatus ~ "confirmed"

define fluent function confirmed(conditions List<Condition>):
  conditions C
    where C.verificationStatus ~ "confirmed"

define fluent function isRefuted(condition Condition):
  condition.verificationStatus ~ "refuted"

define fluent function refuted(conditions List<Condition>):
  conditions C
    where C.verificationStatus ~ "refuted"

/*
@description: Returns true if the given observation has the given category
*/
define fluent function hasCategory(observation Observation, category Code):
  exists (observation.category C
    where C ~ category
  )

/*
@description: Returns true if the given observation is a laboratory result.
*/
define fluent function isLaboratoryResult(observation Observation):
  exists (observation.category C
    where C ~ "laboratory"
  )

/*
@description: Returns true if the given observation is a laboratory result.
*/
define fluent function isVitalSign(observation Observation):
  exists (observation.category C
    where C ~ "vital-signs"
  )

/*
@description: Returns true if the given observation has status
*/
define fluent function isResulted(observation Observation):
  observation.status ~ "observation-final".code
    or observation.status ~ "observation-amended".code
    or observation.status ~ "observation-corrected".code

define fluent function resulted(observations List<Observation>):
  observations observation
    where observation.status ~ "observation-final".code
      or observation.status ~ "observation-amended".code
      or observation.status ~ "observation-corrected".code

define fluent function isFinal(observation Observation):
  observation.status ~ "observation-final".code

define fluent function final(observations List<Observation>):
  observations observation
    where observation.status ~ "observation-final".code

define fluent function isAmended(observation Observation):
  observation.status ~ "observation-amended".code

define fluent function amended(observations List<Observation>):
  observations observation
    where observation.status ~ "observation-amended".code

define fluent function isCorrected(observation Observation):
  observation.status ~ "observation-corrected".code

define fluent function corrected(observations List<Observation>):
  observations observation
    where observation.status ~ "observation-corrected".code

/*
@description: Returns true if the given MedicationRequest has a category of Community
*/
define fluent function isCommunity(medicationRequest MedicationRequest):
  exists (medicationRequest.category C
    where C ~ Community
  )

/*
@description: Returns true if the given MedicationRequest has a category of Discharge
*/
define fluent function isDischarge(medicationRequest MedicationRequest):
  exists (medicationRequest.category C
    where C ~ Discharge
  )

/*
@description: Returns true if the given MedicationRequest has the given category
*/
define fluent function hasCategory(medicationRequest MedicationRequest, category Code):
  exists (medicationRequest.category C
    where C ~ category
  )

/*
@description: Normalizes a value that is a choice of timing-valued types to an equivalent interval
@comment: Normalizes a choice type of FHIR.dateTime, FHIR.Period, FHIR.Timing, FHIR.instance, FHIR.string, FHIR.Age, or FHIR.Range types
to an equivalent interval. This selection of choice types is a superset of the majority of choice types that are used as possible
representations for timing-valued elements in FHIR, allowing this function to be used across any resource. NOTE: Due to the
complexity of determining a single interval from a Timing or String type, this function will throw a run-time exception if it is used
with a Timing or String.
*/
define function ToInterval(choice Choice<FHIR.dateTime, FHIR.Period, FHIR.Timing, FHIR.instant, FHIR.string, FHIR.Age, FHIR.Range>):
  case
	  when choice is FHIR.dateTime then
    	Interval[FHIRHelpers.ToDateTime(choice as FHIR.dateTime), FHIRHelpers.ToDateTime(choice as FHIR.dateTime)]
		when choice is FHIR.Period then
  		FHIRHelpers.ToInterval(choice as FHIR.Period)
		when choice is FHIR.instant then
			Interval[FHIRHelpers.ToDateTime(choice as FHIR.instant), FHIRHelpers.ToDateTime(choice as FHIR.instant)]
		when choice is FHIR.Age then
		  Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(choice as FHIR.Age),
			  FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(choice as FHIR.Age) + 1 year)
		when choice is FHIR.Range then
		  Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((choice as FHIR.Range).low),
			  FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((choice as FHIR.Range).high) + 1 year)
		when choice is FHIR.Timing then
		  Message(null as Interval<DateTime>, true, '1', 'Error', 'Cannot compute a single interval from a Timing type')
    when choice is FHIR.string then
      Message(null as Interval<DateTime>, true, '1', 'Error', 'Cannot compute an interval from a String value')
		else
			null as Interval<DateTime>
	end

/*
@description: Returns an interval representing the normalized abatement of a given Condition.
@comment: If the abatement element of the Condition is represented as a DateTime, the result
is an interval beginning and ending on that DateTime.
If the abatement is represented as a Quantity, the quantity is expected to be a calendar-duration and is interpreted as the age of the patient. The
result is an interval from the date the patient turned that age to immediately before one year later.
If the abatement is represented as a Quantity Interval, the quantities are expected to be calendar-durations and are interpreted as an age range during
which the abatement occurred. The result is an interval from the date the patient turned the starting age of the quantity interval, and ending immediately
before one year later than the date the patient turned the ending age of the quantity interval.
*/
define fluent function abatementInterval(condition Condition):
	if condition.abatement is FHIR.dateTime then
	  Interval[FHIRHelpers.ToDateTime(condition.abatement as FHIR.dateTime), FHIRHelpers.ToDateTime(condition.abatement as FHIR.dateTime)]
	else if condition.abatement is FHIR.Period then
	  FHIRHelpers.ToInterval(condition.abatement as FHIR.Period)
	else if condition.abatement is FHIR.string then
    Message(null as Interval<DateTime>, true, '1', 'Error', 'Cannot compute an interval from a String value')
	else if condition.abatement is FHIR.Age then
		Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(condition.abatement as FHIR.Age),
			FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity(condition.abatement as FHIR.Age) + 1 year)
	else if condition.abatement is FHIR.Range then
	  Interval[FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((condition.abatement as FHIR.Range).low),
		  FHIRHelpers.ToDate(Patient.birthDate) + FHIRHelpers.ToQuantity((condition.abatement as FHIR.Range).high) + 1 year)
	else if condition.abatement is FHIR.boolean then
	  Interval[end of ToInterval(condition.onset), condition.recordedDate)
	else null

/*
@description: Returns the tail of the given uri (i.e. everything after the last slash in the URI).
@comment: This function can be used to determine the logical id of a given resource. It can be used in
a single-server environment to trace references. However, this function does not attempt to resolve
or distinguish the base of the given url, and so cannot be used safely in multi-server environments.
*/
define fluent function getId(uri String):
  Last(Split(uri, '/'))

/*
@description: Given an interval, return true if the interval has a starting boundary specified
(i.e. the start of the interval is not null and not the minimum DateTime value)
*/
define fluent function hasStart(period Interval<DateTime> ):
  not ( start of period is null
      or start of period = minimum DateTime
  )

/*
@description: Given an interval, returns true if the interval has an ending boundary specified
(i.e. the end of the interval is not null and not the maximum DateTime value)
*/
define fluent function hasEnd(period Interval<DateTime> ):
  not (
    end of period is null
      or end of period = maximum DateTime
  )

/*
@description: Returns the most recent Condition
*/
define fluent function mostRecent(conditions List<Condition>):
  Last(
    conditions C
      sort by recordedDate
  )

/*
@description: Returns the most recent Observation
*/
define fluent function mostRecent(observations List<Observation>):
  First(
    observations O
      // Note: Cannot use FindDate() because execution engine cannot sort by result of a function.
      sort by Coalesce(
        issued.value,
        (effective as FHIR.dateTime).value,
        (effective as FHIR.instant).value,
        (effective as FHIR.Period)."end".value,
        (effective as FHIR.Period)."start".value) descending
  )

define function MostRecentMR(medicationRequests List<"MedicationRequest">):
  Last(
    medicationRequests MR
      sort by authoredOn
  )

define function MostRecentSR(serviceRequests List<FHIR.ServiceRequest>):
  Last(
    serviceRequests SR
      sort by (FHIRHelpers.ToDateTime(authoredOn) as DateTime)
  )


define function Mobile(contactPoints List<ContactPoint>):
  singleton from (contactPoints P where P.use = 'mobile')

define function ResultText(o Observation):
  // If Blood pressure observation, then extract component values.
  if o.code ~ "Blood pressure" then
    ToString(((singleton from (o.component C where (C.code ~ "Systolic blood pressure"))).value as FHIR.Quantity).value)
     + '/' + ToString(((singleton from (o.component C where (C.code ~ "Diastolic blood pressure"))).value as FHIR.Quantity).value) + ' mm[Hg]'
  else if o.value is FHIR.Quantity then
    QuantityText(o.value as FHIR.Quantity)
  else if o.value is CodeableConcept then
    ConceptText(o.value as CodeableConcept)
  else if o.value is FHIR.string then
    o.value as FHIR.string
  else
    null

// Returns the first-found display text for a CodeableConcept, looking first at the `text` attribute, then the
// `display` on each `coding` until it finds a non-null value.
// @param c - a FHIR CodeableConcept to get text from
// @returns {System.String} the display text or null if none is found
define function ConceptText(c FHIR.CodeableConcept):
  Coalesce(c.text.value, Coalesce((c.coding) c2 return c2.display.value), Coalesce((c.coding) c3 return c3.code.value))

// Returns a text representation of a Quantity with the Quantity's value and unit.
// If the unit is {score}, then omit it (as it is not useful to display)
// @param q - a FHIR Quantity to get text for
// @returns {System.String} the text representation of the Quantity
define function QuantityText(q FHIR.Quantity):
  if (q is null) then null
  else if (q.unit is not null and q.unit.value != '{score}') then ToString(q.value.value) + ' ' + q.unit.value
  else if (q.code is not null and q.code.value != '{score}') then ToString(q.value.value) + ' ' + q.code.value
  else ToString(q.value.value)

define function QuantityTextWithComparator(q FHIR.Quantity):
  if (q is null) then null
  else if (q.comparator is not null) then q.comparator.value + ' ' + QuantityText(q)
  else QuantityText(q)

define function RangeText(r FHIR.Range):
  if (r is null) then null
  else if (r.low is not null and r.high is not null) then 'between ' + ToString(r.low.value.value) + ' and ' + ToString(r.high.value.value)
  else if (r.low is not null and r.high is null) then 'above ' + ToString(r.low.value.value)
  else if (r.low is null and r.high is not null) then 'below ' + ToString(r.high.value.value)
  else null

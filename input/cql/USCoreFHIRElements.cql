library USCoreFHIRElements version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.1.000'
include FHIRCommon version '1.0.0' called UC

valueset "Common allergy substances": 'http://hl7.org/fhir/us/core/ValueSet/us-core-allergy-substance'

code "No known allergy (situation)": '716186003' from UC.SNOMEDCT

context Patient

define "Usual Name":
  First(
    Patient.name name
      where name.use ~ 'usual'
  )

define "Official Name":
  First(
    Patient.name name
      where name.use ~ 'official'
  )

define "First Occurrence of Non-Official, Non-Usual Name":
  First(
    Patient.name name
      where not(name.use ~ 'official') and not(name.use ~ 'usual')
  )

define "Name":
  Coalesce("Official Name", "Usual Name", "First Occurrence of Non-Official, Non-Usual Name")

// TODO: Correct this once USCore.HumanName.given works as expected
// define "First Name":
//   "Name".given[0]

// TODO: Correct this once USCore.HumanName.given works as expected
// define "Middle Names":
//   Combine(Skip("Name".given, 1), ' ')

define "Last Name":
  "Name".family

// TODO: Correct this once USCore.HumanName.given works as expected
define "Name - First Middle(s) Last":
  //Combine("Name".given, ' ') + ' ' + "Name".family
  "Name".family

// TODO: Correct this once USCore.HumanName.given works as expected
define "Name - Last, First Middle(s)":
  //"Name".family + ', ' + Combine("Name".given, ' ')
  "Name".family

// Allergy/Intolerance

/*
@description: Returns all allergies and intolerances
@comment: This definition returns all allergies and intolerances conforming to the US Core 3.1.1
[AllergyIntolerance](https://hl7.org/fhir/us/core/STU3.1.1/StructureDefinition-us-core-allergyintolerance.html) profile.
Allergies and intolerances returned by this definition include records with any clinical status (including none)
and any verification status (including none).
@profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance
*/
define "All Allergies and Intolerances":
  ["AllergyIntolerance"]

define "Active Confirmed Allergies and Intolerances":
  "All Allergies and Intolerances".allergyActive().allergyConfirmed()

define "Common Allergies and Intolerances":
  "All Allergies and Intolerances" A
    where A.code in "Common allergy substances"

define "Active Confirmed Common Allergies and Intolerances":
  "Common Allergies and Intolerances".allergyActive().allergyConfirmed()

// No Known Allergies (Not Asked)
define "No Known Allergies (Not Asked)":
  "All Allergies and Intolerances" A
    where A.code ~ "No known allergy (situation)"
      and A.isAllergyActive()
      and A.isAllergyUnconfirmed()

// No Known Allergies (Confirmed)
define "No Known Allergies (Confirmed)":
  "All Allergies and Intolerances" A
    where A.code ~ "No known allergy (situation)"
      and A.isAllergyActive()
      and A.isAllergyConfirmed()

// Condition

/*
@description: Returns all problem list items, encounter diagnoses, and health concerns
@comment: This definition returns all conditions of any category conforming to the US Core 3.1.1
[Condition](https://hl7.org/fhir/us/core/STU3.1.1/StructureDefinition-us-core-condition.html) profile.
Conditions returned by this definition include records with any clinical status (including none) and
any verification status (including none).
@profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition
*/
define "All Conditions":
  ["Condition"]

define "All Problem List Items":
  "All Conditions" C
    where C.isProblemListItem()

define "Active Confirmed Problem List Items":
  "All Problem List Items".active().confirmed()

define "All Encounter Diagnoses":
  "All Conditions" C
    where C.isEncounterDiagnosis()

define "All Health Concerns":
  "All Conditions" C
    where C.isHealthConcern()

// Laboratory Diagnostic Report

/*
@comment: [Diagnostic Report for Laboratory Results](https://hl7.org/fhir/us/core/STU3.1.1/StructureDefinition-us-core-diagnosticreport-lab.html)
@profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab
*/
define "All Diagnostic Reports for Laboratory Results":
  // ["DiagnosticReportProfileLaboratoryReporting"]
  ["DiagnosticReport"]

// Diagnostic Report

/*
@comment: [Diagnostic Report Note](https://hl7.org/fhir/us/core/STU3.1.1/StructureDefinition-us-core-diagnosticreport-note.html)
@profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note
*/
define "All Diagnostic Report Notes":
  // ["DiagnosticReportProfileNoteExchange"]
  ["DiagnosticReport"]

// Encounter

/*
@comment: [Encounter](https://hl7.org/fhir/us/core/STU3.1.1/StructureDefinition-us-core-encounter.html)
@profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter 
*/
define "All Encounters":
  ["Encounter"]

define "All Performed Encounters":
  "All Encounters" E
    where E.status = 'finished'  

// Immunization

/*
@comment: [Immunization](https://hl7.org/fhir/us/core/STU3.1.1/StructureDefinition-us-core-immunization.html)
@profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization
*/
define "All Immunizations":
  ["Immunization"] 

define "All Completed Immunizations":
  "All Immunizations" I
    where I.status = 'completed'

// Implantable Device

/*
@comment: [Implantable Device](https://hl7.org/fhir/us/core/STU3.1.1/StructureDefinition-us-core-implantable-device.html)
@profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device
*/
// define "All Implantable Devices":
//   ["ImplantableDeviceProfile"]

// Laboratory Result

/*
@description: Returns all laboratory results
@comment: [Laboratory Result](https://hl7.org/fhir/us/core/STU3.1.1/StructureDefinition-us-core-observation-lab.html)
@profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab
*/
define "All Laboratory Results":
  ["Observation"] O
    where O.isLaboratoryResult()

define "Resulted Laboratory Results":
  "All Laboratory Results" L
    where L.status in { 'preliminary', 'final', 'amended', 'corrected' }

/*
@description: Returns all vital signs
*/
define "All Vital Signs":
  ["Observation"] O
    where O.isVitalSign()

// Medication Request

/*
@description: Returns all medication requests
@comment: [Medication Request](https://hl7.org/fhir/us/core/STU3.1.1/StructureDefinition-us-core-medicationrequest.html)
@profile: http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationrequest
*/
define "Most Recent Medication Request":
  UC.MostRecentMR("All Medication Requests")

define "All Medication Requests":
  ["MedicationRequest"]

define "Active Medication Orders":
  "All Medication Requests" M
    where M.status = 'active'
      and M.intent in { 'order', 'original-order', 'reflex-order', 'filler-order', 'instance-order' }

define "All Medications":
  ["Medication"]

library DailyAppleLogic

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1' called FHIRHelpers

valueset "Apple": 'http://fhir.org/guides/cqf/cpg/example/ValueSet/Apple'

context Patient

define "Inclusion Criteria":
  Patient.active

define "Active Daily Apple Order":
  [MedicationRequest: "Apple"] M
    where M.intent = 'order'
      and M.status = 'active'
      and M.doNotPerform is not true

define "Prohibitions For Daily Apple Order":
  [MedicationRequest: "Apple"] M
    where M.intent = 'order'
      and M.status = 'active'
      and M.doNotPerform is true

define "No Daily Apple Order":
  "Inclusion Criteria"
    and not exists ("Active Daily Apple Order")
    and not exists ("Prohibitions For Daily Apple Order")

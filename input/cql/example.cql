library example version '1.0.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

include example.fhir.uv.myig.example called example

context Patient

define Test: ["Observation"] O where category ~ example."Laboratory Observation Category"

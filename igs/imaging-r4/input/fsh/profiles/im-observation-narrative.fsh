Profile: ObservationNarrativeReport
Parent: $EuObservation
Title: "Observation: Narrative Report"
Description: "Unstructured narrative text in an imaging report."

* insert SetFmmAndStatusRule( 1, draft )

* code
  * insert SliceCodeableConceptWithRequiredCode( narrative-report, $loinc, #18782-3 )
// * code contains narrative-report 1..1
// * code[narrative-report] = $loinc#18782-3 "Radiology Study observation (narrative)"

* value[x] 1..1
* value[x] only string
* value[x] ^short = "Unstructured narrative imaging report"
* value[x] ^definition = "This element represents unstructured narrative text in an imaging report, as it was entered by the reporting clinician or an automated system."

* basedOn
  * insert SliceElement( #type, $this )
* basedOn contains ServiceRequestOrderEuImagingaccession 0..*
* insert BasedOnServiceRequestOrderEuImagingReference( ServiceRequestOrderEuImagingaccession )
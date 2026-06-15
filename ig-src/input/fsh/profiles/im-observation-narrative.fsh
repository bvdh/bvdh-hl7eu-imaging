Profile: ObservationNarrativeReport
Parent: $EuObservation
Title: "Observation: Narrative Report"
Description: "Unstructured narrative text in an imaging report."

* insert SetFmmAndStatusRule( 1, draft )

* code = $loinc#18782-3 "Radiology Study observation (narrative)"

* value[x] 1..1
* value[x] only string

* basedOn
  * insert SliceElement( #type, $this )
* basedOn contains ServiceRequestOrderEuImagingaccession 0..*
* insert BasedOnServiceRequestOrderEuImagingReference( ServiceRequestOrderEuImagingaccession )
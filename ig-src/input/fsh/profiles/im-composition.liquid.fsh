Profile: CompositionEuImaging
Parent: Composition
Title: "Composition: Imaging Report"
Description: "Clinical document used to represent a Imaging Report for the scope of the HL7 Europe project."
* . ^short = "Imaging Report composition"
* . ^definition = """
Imaging Report composition.\n
A composition is a set of healthcare-related information that is assembled together into a single logical document that 
provides a single coherent statement of meaning, establishes its own context and that has clinical attestation with regard 
to who is making the statement.\n
While a Composition defines the structure, it does not actually contain the content: rather the full content of a document is contained in a Bundle, 
of which the Composition is the first resource contained.\n
\n
The `text` field of each section SHALL contain a textual representation of all listed entries.
"""
* insert SetFmmAndStatusRule( 1, draft )

{{R5}}* identifier 1..*
{{R4}}* identifier 1..1
  * ^short = "Report identifier"
  * ^definition = "Identifiers assigned to this report by the performer or other systems. It shall be common to several report versions"
  * ^comment = "Composition.identifier SHALL be equal to one of the DiagnosticReport.identifier, if at least one exists"

* extension contains 
    $event-basedOn-url          named basedOn 0..* and
    $information-recipient-url  named informationRecipient 0..* and
    $hl7euDiagnosticReferenceReference named diagnosticreport-reference 0..1

* extension[diagnosticreport-reference].valueReference only Reference ( DiagnosticReportEuImaging )
* extension[informationRecipient]
  * ^short = "Information Recipient"
  * ^definition = "The intended recipient of the report, if any. The information recipient is the target of a directive to receive the report, such as a report being sent to a practitioner or organization. The information recipient may also be a target for reporting relevant information about the report, such as reporting an issue with the report content.
  This is included as an extension as this information is typically render in the header section of the report."

{{R4}}* extension contains $CrossVersion-Composition.version named version 0..1

* subject 1..1

* custodian only Reference( $EuOrganization )
  * ^short = "Organization that manages the Imaging Report"

* attester 0..*
  * insert SliceElement( #value, mode )
* attester contains legalAuthenticator 0..* and resultValidator 0..*
* attester[legalAuthenticator]
  * mode 1..1
  * mode = http://hl7.org/fhir/composition-attestation-mode#legal
  * party only Reference( $EuPractitioner or $EuPractitionerRole )
  * time 1..1
* attester[resultValidator]
  * mode 1..1
  * mode = http://hl7.org/fhir/composition-attestation-mode#professional
  * party only Reference( $EuPractitioner or $EuPractitionerRole )
  * party.extension contains DeviceAttesterExt named deviceAttester 0..1
  * time 1..1

* author 1..*
  // * insert SliceElement( #profile, [[$this.resolve()]] )
  * ^slicing.discriminator.type = #profile
  * ^slicing.discriminator.path = "$this.resolve()"
  * ^slicing.rules = #open
  * ^slicing.ordered = false
* author contains 
    author 0..* and 
    authoringDevice 0..* and
    organization 0..*
* author[author] only Reference( $EuPractitioner or $EuPractitionerRole )
* author[authoringDevice] only Reference( $EuDevice )
* author[organization] only Reference( $EuOrganization )

// type of the report. Matching DiagnosticReport.code
// code 
* type from ImagingReportTypesEuVSEuImaging (preferred) 
  * ^short = "Type of Imaging Diagnostic Report"
  * ^definition = "Defines the document type, it is recommended to take this from the suggested LOINC set."

* category 0..*
  * insert SliceElement( #value, $this )
* category contains diagnostic-service 0..1 and imaging-report 1..1 and imaging 1..1
* category[diagnostic-service] from $diagnostic-service-sections (required)
* category[imaging] = http://hl7.eu/fhir/{% if isR5 %}eu-{% endif %}health-data-api/CodeSystem/eehrxf-document-priority-category-cs#Medical-Imaging
  * ^definition = "Defines the priority category of the report as defined in the API spec."
* category[imaging-report] = $loinc#85430-7 //Diagnostic imaging report
  * ^definition = "Defines the category of the report, Diagnostic imaging report."


* status 

* section.code 1..1 
* section 
  * insert SliceElement( #value, code )
* section.emptyReason from SectionEmptyReasonEuImaging (preferred)  
* section obeys eu-imaging-composition-1
* section obeys eu-imaging-composition-2
{{R4}}* section.text.extension contains TextLink named text-link 0..1
{{R5}}* section.text.extension contains $textLink named text-link 0..1
* section contains 
    imagingstudy 1..1  and
    order 1..1 and
    history 1..1 and 
    procedure 1..1 and
    comparison 0..1 and 
    findings 0..1  and 
    impression 0..1 and 
    recommendation 0..1  and 
    communication 0..1  and
    report 0..1 

// ///////////////////////////////// IMAGING STUDY SECTION ///////////////////////////////////////
* section[imagingstudy]
  * ^short = "Imaging Study"
  * ^definition = "This section holds information related to the imaging studies covered by this report."
  // * title = "Imaging Studies"
  * code = $loinc#18726-0
  * entry 
    * insert SliceElement( #profile, $this )
  * entry contains imagingstudy 1..*
  * entry[imagingstudy]
    * ^short = "Imaging Study Reference"
    * ^definition = "This entry holds a reference to the Imaging Study instance that is associated with this Composition."
  * entry[imagingstudy] only Reference(ImagingStudyEuImaging)  

// ///////////////////////////////// ORDER SECTION ///////////////////////////////////////
* section[order]
  * ^short = "Order"
  * ^definition = "This section holds information related to the order for the imaging study."
  * code = $loinc#55115-0 // "Requested imaging studies information Document"
  * entry
    * insert SliceElement( #profile, $this )
  * entry contains 
      order 0..*

  * entry[order]
    * ^short = "Order reference"
    * ^definition = "This entry holds a reference to the order for the Imaging Study and report."
  * entry[order] only Reference(ServiceRequestOrderEuImaging)  

// // ///////////////////////////////// HISTORY SECTION ///////////////////////////////////////
* section[history]
  * ^short = "History"
  * ^definition = """
  Additional clinical information about the patient or specimen that may affect service delivery or interpretation 
  with information specific for imaging (i.e. Observation, Condition, Device, Medication Administration).
  """
  * code = $loinc#11329-0 // "History general Narrative - Reported"
  * entry 
    * insert SliceElement( #profile, [[$this.resolve()]] )
  * entry contains vitals 0..* and problemlist 0..* and implants 0..* and medication 0..*
  * entry[vitals] only Reference(Observation)
  * entry[problemlist] only Reference(Condition)
  * entry[implants] only Reference(Device)
  * entry[medication] only Reference(MedicationAdministration or MedicationRequest)

// // ///////////////////////////////// PROCEDURE SECTION ///////////////////////////////////////
* section[procedure]
  * ^short = "Procedure"
  * ^definition = "This section holds information related to the (performed) procedure(s) the generated the imaging study."
  * code = $loinc#55111-9 // "Current imaging procedure descriptions Document"
  * entry 
    * insert SliceElement( #profile, $this )
  * entry contains 
      procedure 0..* and adverse-event 0..* and radiation-dose 0..*
  * entry[procedure] only Reference(ProcedureEuImaging)
    * ^short = "The imaging Procedure(s)"
    * ^definition = "A reference the the procedure(s) in which the imaging study was performed."
  * entry[adverse-event] only Reference(AdverseEvent)
    * ^short = "AdverseEvent(s)"
    * ^definition = "Possible AdverseEvents that occurred during the procedure."
  * entry[radiation-dose] only Reference(ObservationRadiationDoseEuImaging)
    * ^short = "Radiation-dose information"
    * ^definition = "Information on radiation the patient was exposed to during the procedure."

// ////////////////// COMPARISON SECTION //////////////////////////
* section[comparison]
  * ^short = "Comparison"
  * code = $loinc#18834-2 // "Radiology Comparison study (narrative)"
  * entry
    * insert SliceElement( #profile, [[resolve()]] )
  * entry contains 
      comparedstudy 0..*
  * entry[comparedstudy] only Reference( ImagingStudyEuImaging or ImagingSelectionEuImaging )

// /////////////////// FINDINGS SECTION //////////////////////////
* section[findings]
  * ^short = "Findings"
  * code = $loinc#59776-5 // "Findings"
  * entry
    * insert SliceElement( #profile, [[resolve()]] )
  * entry contains 
      finding 0..* and
      keyimage 0..* and
      image 0..*
  * entry[finding] only Reference(Observation)
  * entry[keyimage] only Reference( DocumentReferenceKeyImageEuImaging or ImagingSelectionKeyImageEuImaging )
  * entry[image] only Reference( DocumentReference {% if isR4 %} or Media {% endif %} )


// /////////////////// IMPRESSION SECTION //////////////////////////
* section[impression]
  * ^short = "Impressions"
  * code = $loinc#19005-8 // "Radiology Imaging study [Impression] (narrative)"
  * entry
    * insert SliceElement( #profile, $this )
  * entry contains 
      finding 0..* and
      impression 0..* and
      keyimage 0..*
  * entry[finding] only Reference(ObservationFindingEuImaging)
  * entry[impression] only Reference( $EuCondition )
  * entry[keyimage] only Reference(DocumentReferenceKeyImageEuImaging or ImagingSelectionKeyImageEuImaging)

// /////////////////// RECOMMENDATION SECTION //////////////////////////
* section[recommendation]
  * ^short = "Recommendations"
  * code = $loinc#18783-1 // "Radiology Study recommendation (narrative)"
  
  * entry
    * insert SliceElement( #profile, $this )
  * entry contains suggestion 0..*
  * entry[suggestion] only Reference($EuCarePlan or $EuServiceRequest)


// /////////////////// COMMUNICATION SECTION //////////////////////////
* section[communication]
  * ^short = "Communications"
// a proper code is needed
  * code = $loinc#73568-8 // "Communication"
  

// /////////////////// FULL-REPORT SECTION //////////////////////////
* section[report]
  * ^short = "Report - all content in one section"
// a proper code is needed
  * code = $loinc#LP173421-1 // "Report"
  * entry
    * insert SliceElement( #profile, $this )
  * entry contains narrative-report 1..*
  * entry[narrative-report] only Reference(ObservationNarrativeReport)

Extension: DeviceAttesterExt
Title: "Extension: Device Attester"
Description: 	"Attester of type Device who validated the document"
* ^context[+].type = #element
* ^context[=].expression = "Composition.attester.party"
* value[x] only Reference(Device)

Invariant: eu-imaging-composition-1
Description: "When a section is empty, the emptyReason extension SHALL be present."
Severity: #error 
Expression: "entry.empty().not() or emptyReason.exists() or section.exists() or extension('http://hl7.org/fhir/StructureDefinition/note').value.text.exists()"

Invariant: eu-imaging-composition-2
Description: "A section must contain at least one of text, entries, or sub-sections."
Severity: #error 
Expression: "text.exists() or entry.exists() or section.exists()"

{% if isR4 %}
// transporting this extension avilable in extension package 5.3.0 butnot for R4, so we define it here for R4 only
Alias: $m49.htm = http://unstats.un.org/unsd/methods/m49/m49.htm

Extension: TextLink
Id: textLink
Title: "Text Link"
Description: "Used to denote which portions of the narrative are linked to (usually, generated from) structured data in resources. This information might be used in several different ways, including translating and regenerating narrative in applications that are using/presenting the narrative. Note that there are two related extensions for linking data and narrative: originalText and narrativeLink."
Context: Narrative
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg"
* ^extension[=].valueCode = #fhir
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm"
* ^extension[=].valueInteger = 3
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status"
* ^extension[=].valueCode = #trial-use
* ^extension[+].url = "http://hl7.org/fhir/StructureDefinition/structuredefinition-type-characteristics"
* ^extension[=].valueCode = #can-bind
* ^identifier.system = "urn:ietf:rfc:3986"
* ^identifier.value = "urn:oid:2.16.840.1.113883.4.642.5.1691"
* ^version = "5.3.0"
* ^experimental = false
* ^date = "2013-12-05"
* ^publisher = "HL7 International / FHIR Infrastructure"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fiwg"
* ^jurisdiction = $m49.htm#001
* . 0..1
* . ^short = "Text Link"
* . ^definition = "Link between narrative elements and structured data items in resources"
* . ^comment = "Used to denote which portions of the narrative are linked to (usually, generated from) structured data in resources. This information might be used in several different ways, including translating and regenerating narrative in applications that are using/presenting the narrative."
* extension contains
    htmlid 1..* and
    data 1..1 and
    selector 0..1
* extension[htmlid] only Extension
* extension[htmlid] ^short = "Unique identifier"
* extension[htmlid] ^definition = "The id attribute on an element in the xhtml narrative"
* extension[htmlid] ^comment = "The id attribute on an element in the xhtml narrative."
* extension[htmlid].url only uri
* extension[htmlid].value[x] 1..
* extension[htmlid].value[x] only string
* extension[htmlid].value[x] ^definition = "The actual HTML element id"
* extension[data] only Extension
* extension[data] ^short = "Unique identifier"
* extension[data] ^definition = "The id attribute on a resource element (#{id}, relative#{id} or https://absolute#{id})"
* extension[data] ^comment = "The id attribute on an element in the xhtml narrative. The reference can be a fragment to a reference in the resource that contains the narrative, or a relative or absolute URL, optionally with a fragment that identifies an element in the other resource."
* extension[data].url only uri
* extension[data].value[x] 1..
* extension[data].value[x] only uri
* extension[data].value[x] ^short = "The actual data element in this resource, or another resource"
* extension[selector] only Extension
* extension[selector] ^short = "FHIRPath that selects a subset of the identified data"
* extension[selector] ^definition = "FHIRPath that selects a subset of the identified data. This sub-extension exists because in some circumstances, the specific data items are in resources where the constructor of the narrative can't introduce specific ids on the relevent elements"
* extension[selector].url only uri
* extension[selector].value[x] 1..
* extension[selector].value[x] only string
* extension[selector].value[x] ^short = "Simple FHIRPath that can't use .resolve()"


{% endif %}
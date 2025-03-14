Profile: ImKeyImageDocumentReferenceProvider
Parent: ImKeyImageDocumentReference
Id: im-keyimages-document-reference-provider
Title: "Imaging Key Image Document Reference (ImProvider)"
Description: "Requirements for the provider of the imaging key image document reference."
* insert SetFmmAndStatusRule( 1, draft )
* meta.security
  * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )
* language
  * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )
* basedOn[imorderaccession]
  * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )
* bodySite
  * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )
* date
  * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )
* author[performer]
  * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )
* description 
  * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )
* content[content] 
  * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )
  * attachment 1..1
    * contentType
      * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )
    * title
      * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )
    * width
      * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )
    * height
      * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )
    * frames
      * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )
    * duration
      * insert SetObligation( #SHALL:populate-if-known, ImProvider, [[]], [[]] )

Profile: ImKeyImageDocumentReference
Parent: DocumentReference
Id: im-keyimages-document-reference
Title: "Imaging Key Image Document Reference"
Description: """A document containing key images for a patient. It can refer to a DICOM or non-DICOM image. When referring to a DICOM image, the DocumentReference.content.attachment.url should be a WADO-URI. When referring to a non-DICOM image, the DocumentReference.content.attachment.url should be a direct URL to the image.\n
When the resource represents a DICOM instance it SHALL contain a the SOP Instance UID in the identifier element. When the resource represents a DICOM series it SHALL contain the Series Instance UID in the identifier element. 
"""

* insert SetFmmAndStatusRule( 1, draft )

* identifier
* identifier 
  * insert SliceElement( #value, $this )
* identifier contains seriesInstanceUid 0..1 and sopClassInstanceUid 0..1
* identifier[seriesInstanceUid] 
  * type 1..1 
  * type = MissingDicomTerminology#00080018
  * system 1..1 
  * system = "urn:ietf:rfc:3986"
  * value 1..1
* identifier[sopClassInstanceUid] 
  * type 1..1
  * type = http://dicom.nema.org/resources/ontology/DCM#112002
  * system 1..1 
  * system = "urn:ietf:rfc:3986"
  * value 1..1

* basedOn
  * insert SliceElement( #type, $this )
* basedOn contains imorderaccession 0..1
* insert BasedOnImOrderReference( imorderaccession )

* category 1..*
  * insert SliceElement( #profile, $this )
* category contains imkeyimages 1..1
* category[imkeyimages]
  * coding
    insert SliceElement( #value, $this )
  * coding contains keyimagecode 1..1
  * coding[keyimagecode] = $loinc#55113-5 "Imaging Key Images Document"

* modality 1..1
  
* bodySite 0..1
  
* subject 1..1
* subject only Reference( ImPatient )

* author
  * insert SliceElement( #profile, $this )
* author contains performer 0..*
* author[performer] only Reference( ImPractitionerRole )
  
* content
  * attachment 1..1
* content 
  * insert SliceElement( #value, [[extension.where( url = 'http://hl7.org/fhir/StructureDefinition/documentreference-thumbnail']] )
* content contains 
    thumbnail 0..1 and 
    content 1..1
* content[thumbnail] 
  * extension contains $document-reference-thumbnail-url named thumbnail 1..1
  * extension[thumbnail].valueBoolean = true
* content[content] 
  * extension contains $document-reference-thumbnail-url named thumbnail 1..1
  * extension[thumbnail].valueBoolean = true
  * attachment 1..1
    * url 1..1
      

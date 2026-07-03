{% include profile-references.md %}

### Obligations

Systems are expected to handle specific data elements according to the role (actor) they play in the EHDS Imaging Report ecosystem. In this specification, these expectations are defined as [FHIR Implementation Obligations]({% if isR5 %}https://hl7.org/fhir/R5/obligations.html{% else %}https://hl7.org/fhir/extensions/ValueSet-obligation.html{% endif %}), following [EHDS shared practices](https://build.fhir.org/ig/Xt-EHR/xt-ehr-common/branches/new-pages/obligations.html) and are listed in the [Artifacts](artifacts-obligations.html) section.

Following this guidance, for {{ ProducerActor }}s `SHALL/SHOULD/MAY:able-to-populate` obligations are added indicating the required capability of the Producer to populate a field. For {{ ConsumerActor }}s `SHALL/SHOULD/MAY:process` obligations are used to express what fields a {{ ConsumerActor }} is required to process. Note that no display related obligations are used and the variety of {{ ConsumerActor }}s makes it very difficult if not impossible to determine a generic rule for this.

#### How obligations are assigned in this guide

Every element flagged as Must-Support (MS) carries an obligation. Where the Xt-EHR (EHDS) logical model defines an obligation for the mapped source element, that obligation is used; where the model defines none, this guide defines its own obligation using codes from the [FHIR obligation code system](https://hl7.org/fhir/extensions/CodeSystem-obligation.html). Every mandatory (`1..1`) element carries a `SHALL:populate` obligation, since a required element must be populated when its value is known.

Obligations are stored in dedicated `<Resource>Obligation…` profiles and are derived from the Xt-EHR mapping. When more than one source element maps to the same target element, the strongest obligation applies (`SHALL` > `SHOULD` > `MAY`), and the contributing Xt-EHR source elements are recorded in the obligation's documentation. This guide does not lower an obligation below the level defined by the Xt-EHR model.

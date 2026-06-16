### Rationale

Most radiology reports still contain a significant amount of unstructured, narrative (dictated or free-text) content. This profile defines a dedicated, explicit home for that narrative so it can be stored, referenced and reused consistently, instead of being placed in elements that were not designed for primary result content.

#### Why an Observation (and not `DiagnosticReport.note`)

Storing the narrative result in `DiagnosticReport.note` is a common shortcut, but `.note` is intended for comments *about* the report, not for the report's primary result content. Using it for the report text overloads the element and makes the actual result hard to locate and process reliably.

Encoding the narrative as an `Observation.valueString` and referencing it from `DiagnosticReport.result` follows an **existing, well-established pattern in US Core**, where free-text results are represented as Observations carrying a string value (see, for example, the US Core [chest x-ray findings Observation](https://build.fhir.org/ig/HL7/US-Core/Observation-xray-chest-findings.json.html)). This gives the narrative:

* a clear, addressable identity as a result;
* a clean separation between the narrative result and report-level metadata or comments;
* a stable anchor that structured data derived from the text can later point back to as its source.

#### Options considered

The following alternatives were evaluated before settling on the Observation-based approach.

| Approach | Summary | Pros | Cons |
| -------- | ------- | ---- | ---- |
| **`DiagnosticReport.note`** (initial approach) | Put the free-text result in `DiagnosticReport.note`. | Trivial to populate. | Incorrect use of `.note`, which is not intended for primary result content. |
| **Observation-based** (chosen) | Encode the narrative in `Observation.valueString`, reference via `DiagnosticReport.result`. | Aligned with US Core; clear separation of results; structured findings can reference the source narrative; ordering can be conveyed (e.g. order of `DiagnosticReport.result`). | Linkage from the `Composition` to these Observations needs to be defined; `Observation` can over-encode (many real-world findings); not ideal for non-finding narrative elements. |
| **Narrative (`.text`)** (IDR-first) | Encode in `DiagnosticReport.text` and `Composition.section.text`. | Supports inline images; easy for consumers to render; consistent pattern across `Composition` and `DiagnosticReport`. | Hard to parse sections (needs an XHTML `class` workaround); some servers may overwrite `.text`; requires strict `SHALL` constraints; difficult to isolate the pure report text from other narrative metadata. |
| **Dedicated extension** | A bespoke `.dictatedText`-style extension on the resource, mirroring `Composition.section.extension[note]`. | Explicit handling; preserves an existing pattern. | A bespoke extension for what is really the core data element of the resource. |

#### Resulting design

This IG adopts the **Observation-based approach** and resolves its main drawback — the linkage from the document — by referencing the `ObservationNarrativeReport` from both `DiagnosticReport.result` and the `CompositionEuImaging` sections (`section[].entry[report-narrative]`, or `section[report].entry[report-narrative]` when no sections can be derived). The narrative content SHOULD additionally be reflected in the corresponding `Composition.section[].text` so consumers can render it directly.

> Note: this guide avoids using *dictation* as a synonym for unstructured information. The content captured here is the unstructured (narrative) text of the report, regardless of how it was produced.

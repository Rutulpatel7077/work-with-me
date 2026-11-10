# Report outline

The reader is a developer about to work on this feature. They should get the big picture from the first screen, and know where to look for anything else within two minutes. Drop any section that doesn't apply. Don't pad.

## Writing rules

- **No intro paragraph.** Open with the answer.
- **Headings state the finding, not the topic.** "Invoices are created by a nightly job, not by checkout", not "Invoice creation". A reader skimming only the headings should come away with the main points.
- **Short.** One to three sentences per paragraph. A list when it's a list. Cut any sentence that doesn't help the reader work on this code.
- **Real names.** The project's actual identifiers and vocabulary, in `code` style when they're code.
- **Cite under each claim.** `path:line` inline or as a small "Sources" line under a paragraph, table, or diagram.
- **Introduce a term before you lean on it.** The key terms section exists for this.

## Diagrams

Only when they explain something prose explains worse (see the diagram rule in the shared rich-reports guide). For a feature walkthrough that usually means at most two or three diagrams:

- The **end-to-end path** in the TL;DR, when there are three or more hops.
- A **sequence diagram** for the main flow, when several components call each other back and forth.
- A **data diagram** showing what reads and writes each store, when there's more than one store or the writes happen in several places.

Label every arrow with a verb (`writes`, `enqueues`, `polls every 30s`). Keep each diagram to about eight boxes. If it needs a paragraph to be understood, redraw it smaller or drop it. Never draw a diagram of a single step or a list.

## Sections

1. **Header.** Feature name, repo and commit, date, and a one-line verification note ("32 citations checked, 2 claims unconfirmed").
2. **TL;DR.** Three to five sentences: what the feature does, how it works end to end, where its data lives, and the one thing most likely to surprise someone. Add the end-to-end diagram here if it earns its place.
3. **Key terms.** Three to six project words the rest of the report uses, one line each. Skip if the feature has none.
4. **Start to finish.** The heart of the report. The main flow as numbered steps: what happens, where (`file:line`), and how the data changes. Follow one real example through (a specific request, a specific job run) when that makes it concrete. Add the sequence diagram if the flow bounces between components.
5. **How it starts.** A table of entry points: trigger, handler, `file:line`.
6. **Where the data lives.** Each store (table, cache, file, queue, external service), what's in it, and which code reads and writes it. Add the data diagram if it helps.
7. **What it needs.** Internal modules it depends on, external services and libraries, environment variables, feature flags, and permissions.
8. **Gotchas.** What will bite the next developer. For each, say what happens, why, and what it means for someone changing the code. Error paths and retries go here.
9. **Tests.** Where they are and what they cover, or "no tests found".
10. **Where to change things.** A short table: "To change X, look at Y" for the three to six changes someone is most likely to make.
11. **Open questions.** What isn't confirmed, and why.
12. **Sources.** The must-read files with one line each, in a collapsible section.

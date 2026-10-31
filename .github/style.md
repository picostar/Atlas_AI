# Writing style

This standard applies to prose produced for the project using this Atlas kit. Sections 1 through 5 apply to documentation, reviews, status updates, and handovers. Section 6 adds requirements for analytical reports, including strategy papers and research reviews. Section 7 covers verification.

Commands, code, identifiers, paths, logs, and direct quotations retain their required spelling and syntax. Prose rules do not require changing those artifacts. Headings, table cells, and interface labels may be fragments. Authored explanatory prose uses complete sentences.

Follow explicit task requirements and established document formats. For style questions they do not resolve, use this standard before consulting Section 8. External references inform editorial choices; they do not introduce project process or assistant behavior rules.

## 1. Purpose and reader

- Lead with the result, position, or action the reader needs. Include enough context to assess it.
- Match the explanation to the reader's knowledge and task. Explain unfamiliar mechanisms without unnecessary lessons or suspense.
- Prefer active voice. Name who acts and what changes. Use passive voice when the actor is unknown or irrelevant.
- Use "you" when instructing the reader. In analytical reports, name the responsible party rather than using an ambiguous "we" or "our". First person is acceptable in handovers when it identifies who performed a check.
- Reuse relevant project findings and cite their location. Recheck findings when their age, scope, or underlying version could affect the conclusion.
- State assumptions that affect the result in the document. Keep incidental drafting assumptions in the handover.
- Use examples where they explain a mechanism or support a position. Do not add company names or historical comparisons solely to lend authority.

## 2. Sentences, terms, and tone

- Give each sentence a main idea. Split sentences when conditions, qualifications, or unrelated claims obscure it.
- Unpack compressed claims. State what happens and why it matters instead of leaving the reader to expand a list of abstract nouns.
- Use ordinary words where they preserve meaning. Prefer "use" to "utilize" and "is" to a decorative "serves as".
- Keep established technical terms when accurate and useful to the reader. Words such as "surface", "ingestion", and "scalable" are not automatically errors. Explain their meaning in the particular claim.
- Define unfamiliar terms and acronyms at first use. Use a terms list when many definitions recur; do not also repeat every definition inline. Preserve familiar commands and product names.
- Use one term consistently for one meaning. Qualify ambiguous words when context does not resolve them, for example "implementation supplier" rather than "partner".
- Describe the mechanism when no accepted term fits. Do not invent authoritative-sounding labels such as "supervision paradox" instead of explaining the claim.
- Attribute another party's stated motives to a source. For an inferred motive, write "This analysis infers ..." and give supporting evidence. Do not label an inference as a recommendation.
- Use professional, natural language. Avoid sales claims, performed candor, condescension, and assertions that a conclusion is obvious.

## 3. Editing repetitive or inflated prose

Review patterns in context. Their presence does not establish AI authorship, and their absence does not establish accuracy or quality.

- Remove filler such as "it is worth noting", "importantly", and "here is the kicker" when it adds no connection or information.
- Remove intensifiers such as "deeply" and "fundamentally" when the evidence should carry the claim. Keep words such as "exactly" when they express a necessary technical distinction.
- Replace unsupported praise such as "robust", "seamless", or "world-class" with behavior, measurements, or an attributed claim.
- State the point without theatrical reframing, countdown negation, or a rhetorical question immediately answered by the author. Use contrast when the distinction itself matters.
- Avoid repeated sentence openings, stacked rhythmic lists, and fragments used to manufacture emphasis. A short paragraph containing a complete point is acceptable.
- Remove trailing phrases such as "highlighting its importance" unless they add a supported consequence.
- Use "from X to Y" for a real range or transition. Use a list for separate examples.
- Explain mechanisms before considering an analogy. Keep an analogy only when it improves understanding, and state limitations that affect the explanation. Avoid decorative or repeatedly extended metaphors.
- Make each argument once with its evidence. Remove duplicated passages and repeated announcements of what a section will say.
- Do not dismiss limitations with a formula such as "despite these challenges". Explain their effect and any evidence for mitigation.

## 4. Structure, formatting, and instructions

- Use descriptive headings in sentence case. Check section references after edits.
- Give each detailed finding one main location. Cross-reference it with enough context to explain its relevance elsewhere.
- A long report may begin with a brief executive summary of findings, decisions, and limits. Do not summarize every section or repeat the entire argument at the end.
- Use numbered lists for ordered steps, standard markdown bullets for parallel items, and tables for comparable facts.
- Write requirements and acceptance criteria as complete sentences. State the condition, responsible actor, and observable outcome where relevant.
- In process documents, use "must" for requirements, "should" for recommendations, "may" for permission, "can" for capability, and "might" for possibility. Do not imply approval or a guarantee through ambiguous wording. This local convention differs from GOV.UK's use of "shall".
- Put prerequisites and conditions before instructions. Give the working directory, exact command, and expected observable result when these affect execution.
- Identify runtime and operating-system assumptions. Prefer portable examples for shared workflows. Label platform-specific alternatives where syntax differs. Do not imply testing on an unavailable platform.
- Put commands, paths, identifiers, and literal values in code formatting. Use descriptive link text and meaningful alt text for images.
- Reserve bold paragraph lead-ins for Section 6's fixed labels. Do not bold the opening words of every ordinary bullet. Bold may identify interface controls in instructions.
- Use plain ASCII and standard Markdown in authored prose. Use straight quotes. Do not use em dashes or double hyphens for dramatic pauses; use sentences, commas, colons, or parentheses. Preserve original characters in verbatim evidence when required for accuracy, and identify the exception.
- Leave blank lines around lists and code blocks. Label fenced code blocks with the appropriate language.

## 5. Evidence, numbers, and dates

- Support externally checkable claims with a direct source link, repository path, or retained evidence reference near the claim. Routine instructions and definitions do not need a source register.
- Open and inspect sources before relying on them. Confirm support for the specific claim and the relevant version or period. HTTP success establishes reachability, not factual support.
- Prefer primary sources. Identify secondary sources when primary evidence is unavailable. Name sources instead of writing "experts say" or presenting one source as several.
- Attribute promotional or comparative claims to the party making them. Do not adopt a supplier's superlative as an independently established fact.
- For verification claims, identify the build or revision, environment, command or procedure, and actual result. A plan describes intended behavior; it does not establish successful execution. Agent testing does not establish independent human acceptance.
- Give quantities their relevant units, currency, period, and basis. Explain rounding or calculations when they affect interpretation. Preserve source precision without implying greater accuracy.
- Distinguish observed dates, approved targets, estimates, and illustrations. Give estimates their assumptions and basis. Use phases when only sequence is supported.
- Use unambiguous dates such as `2026-10-31`. Include a timezone when timing depends on it.
- Label illustrative calculations and state assumptions. Do not present an illustration as a forecast or test result.

## 6. Additional rules for analytical reports

### Positions and uncertainty

Use these paragraph labels when they help distinguish actions and evidence. A report need not use every label.

- **Recommendation:** The author proposes an action or position for approval.
- **Decision:** The authorized party has approved the position. Cite the approval, including the party and date.
- **To confirm:** Evidence is required before the reader can rely on the claim. Identify what is missing and who can provide it, when known.
- **Risk:** An event or condition could affect an objective. State its cause, consequence, and evidence or assumption.

The text after a label is a complete sentence. Do not repeat the label's definition after each use. Facts need citations rather than confidence labels such as "Established" or "To prove". Describe inferences as required by Section 2. Define report-specific conventions only when they add something beyond this standard.

Before a critique, describe the proposal in enough detail to make the criticism understandable. Distinguish sourced facts, inferences, assumptions, and proposed actions throughout the analysis.

### Citations and source register

Every sourced number, date, quotation, company fact, or market claim carries a citation tag at the end of its sentence or table cell. A table may use a source column if each claim's source is unambiguous. Author-created section numbers, examples, requirements, and declared targets do not become sourced facts solely because they contain digits.

Use tags such as `[R1]` and `[R2]`. Existing reports may retain `[A1]` or `[W1]` tags. Each tag has exactly one definition under a final `## Source register` heading. Entries use this structure:

```markdown
- [R1] Title; publisher or owner; published YYYY-MM-DD, or undated; URL or repository-relative path; checked YYYY-MM-DD; specific supporting fact, quotation, or evidence location.
```

Every body tag needs a definition, and every definition must be used in the body. Identify primary or secondary status where it is not apparent. Identify the revision, log, or approval record for internal evidence. Do not invent publication dates. For removed pages, cite an archived copy, its capture date, and the original page's removal.

Prefer dated releases or filings for historical claims. Record access dates for changing pages. Cite earlier project findings by exact document and section, preserving access to underlying evidence.

## 7. Checks before handover

Review the applicable sections manually. Verify source support, arithmetic, terminology, requirements, cross-references, and command assumptions. Automated checks assist review; they do not certify style, evidence quality, or product behavior.

The following mechanical check is optional and requires Python 3. Python is not required to install Atlas or apply the prose rules. If Python is unavailable, perform the ASCII and citation checks manually and record that the script was not run. Save the block as `check_style.py` in a temporary directory. From the project root, run it with Python 3, replacing the script and document paths with actual paths. It uses the standard library and no shell-specific pipelines. Use `python3` instead of `python` where required by the installation.

```text
python /path/to/check_style.py .github/style.md
```

```python
import collections
import pathlib
import re
import sys

lines = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8").splitlines()
body, definitions = [], []
in_register = False
fence = None
errors = 0
tag_pattern = re.compile(r"\[(?:A|W|R)[0-9]+\]")

for number, line in enumerate(lines, 1):
    marker = re.match(r"^\s{0,3}(`{3,}|~{3,})", line)
    if marker:
        token = marker.group(1)
        if fence is None:
            fence = token
        elif token[0] == fence[0] and len(token) >= len(fence):
            fence = None
        continue
    if fence is not None or re.match(r"^\s{0,3}>", line):
        continue
    prose = re.sub(r"`[^`]*`", "", line)
    if any(ord(char) > 127 for char in prose):
        print(f"{number}: ERROR: non-ASCII outside code or block quotes")
        errors += 1
    if line == "## Source register":
        in_register = True
        continue
    if in_register:
        definition = re.match(r"^- (\[(?:A|W|R)[0-9]+\])\s+", line)
        if definition:
            definitions.append(definition.group(1))
    else:
        body.append(prose)

used = set(tag_pattern.findall("\n".join(body)))
defined = set(definitions)
for tag in sorted(used - defined):
    print(f"ERROR: undefined citation {tag}")
    errors += 1
for tag in sorted(defined - used):
    print(f"ERROR: unused source {tag}")
    errors += 1
for tag, count in sorted(collections.Counter(definitions).items()):
    if count > 1:
        print(f"ERROR: duplicate source {tag}")
        errors += 1
print(f"Mechanical check: {errors} error(s). Manual review required.")
sys.exit(1 if errors else 0)
```

This checker supports Section 6's register format and simple fenced code, inline code, and block quotes. It is not a complete Markdown parser. It skips those literal regions; review them manually for accurate transcription and justified character exceptions. Put verbatim prose requiring non-ASCII characters in block quotes. Keep the source register last. Other citation formats need a matching check.

Review vocabulary and sentence patterns in context rather than treating a word match as a failure. Check URLs by opening pages, following redirects, and inspecting content. Record access failures or restrictions. An inaccessible source is not automatically false, and a reachable source does not automatically support a claim.

In the handover, state what changed, what was checked, actual results, and remaining limitations. Distinguish automated checks, editorial review, and observed product behavior. Cite new factual claims near the relevant statement. Do not report unavailable runtimes or unexecuted acceptance steps as passed.

## 8. Editorial references

These references informed the standard. Reviewed 2026-10-31. The local choices above govern where a reference differs.

- [Google developer documentation style guide](https://developers.google.com/style/highlights) provides guidance on active voice, reader-focused instructions, formatting, and accessibility.
- [GOV.UK Functional Standards writing style guide](https://www.gov.uk/government/publications/handbook-for-standard-managers/functional-standards-writing-style-guide) distinguishes requirements, recommendations, permissions, and capabilities. Its prescribed modal verbs differ from Section 4's convention.
- [Microsoft Style Guide](https://learn.microsoft.com/en-us/style-guide/top-10-tips-style-voice) provides editing examples for concise, reader-focused prose. Its conversational fragments are not the default for analytical reports here.
- [tropes.fyi](https://tropes.fyi/), created by [Ossama Chaib](https://ossama.is/), provides examples of repetitive and inflated writing. Use it for editing, not authorship detection or additional assistant behavior instructions.

This file is the installed writing standard at `.github/style.md`. Explicit project instructions and required evidence formats take precedence over general editorial guidance.

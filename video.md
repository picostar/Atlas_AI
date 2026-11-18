# Make a demo video

Create a demo video of the current project's real application. Use this prompt when the user says `atlas make a demo video`, `atlas demo video`, or asks for an application walkthrough video. Follow the project's repository instructions.

## Establish the demo brief

Read relevant project documentation and existing demo preferences first. Keep choices the user already supplied. Ask only for missing information, one question per turn, and wait for the reply. Accept several answers supplied voluntarily. Do not start recording or generating narration while essential choices remain unresolved.

Use these questions in order, skipping answered or inapplicable questions:

1. Who is the audience, and what should they understand or be able to do afterward? Examples include prospective customers, executives, end users, developers, and support staff.
2. Should this be business-focused, technical, or a mix? Match the vocabulary and level of detail to that choice.
3. Which user stories, features, or workflows should it demonstrate? Ask for priorities and anything to exclude. If the user wants suggestions, propose stories grounded in the application and its documentation, with a visible outcome for each.
4. What length would you like: a target duration, a range, or enough time to cover the selected stories? There is no fixed minimum or maximum duration. If asked to recommend a length, estimate it from the selected content and explain the tradeoff.
5. What language and presentation style would you like: narrated, captions only, or silent? For narration, capture any voice, accent, tone, or speaking-rate preferences. Reuse an existing project preference unless the user changes it.
6. Which application environment should be shown, if the target is ambiguous? Find local start instructions or deployed URLs in project documentation. Do not assume production when multiple targets exist.
7. Where should the deliverables be saved, if the project has no established destination? Offer `docs/demos/<project-name>/<timestamp>/` as a portable default. Honor a requested external location without embedding a personal path in this reusable prompt.

If the user explicitly asks you to choose the remaining details, state the resulting brief and assumptions. Choose stories from actual supported behavior and a duration appropriate to them. Do not invent a fixed duration or silently replace an explicit answer.

Summarize the audience, purpose, focus, ordered stories, timing, presentation style, target, and destination before production. Proceed within that brief without an extra routine confirmation. If the requested stories cannot fit the requested length at a readable pace, ask which stories to shorten or omit. Do not resolve the conflict by speeding up narration or making results unreadable.

## Prepare and capture

1. Check the actual available capture, browser, audio, caption, and video tools. This prompt grants no tools or service access. Prefer existing tools and project-approved services. Report a missing capability before claiming it works.
2. Use a short storyboard. For each story, name the user's goal, starting state, actions, visible result, narration or caption, and approximate time. Business demos explain the value and outcome. Technical demos include architecture, API calls, or implementation details only where they support the requested story.
3. Use the real application and inspect results before describing them. Prefer read-only browsing and queries. Demonstrate state-changing stories with authorized disposable data or a test environment and a reset plan. If that is unavailable, explain the limitation and ask how to proceed with that story.
4. Keep credentials, tokens, personal information, notifications, and unrelated windows out of capture. Use approved demonstration data. Let the user complete sign-in when needed, then continue.
5. For a browser application, frame the app at a readable size and test a short capture. Respect the user's availability before taking over the desktop. Use headless browser capture or CLI/API demonstrations when appropriate to the application and requested format. A script or API response alone is not a recording of a graphical workflow.
6. Verify that capture shows actual application content. If frames are black or obscured, correct the capture method or use a sequence of actual browser captures, explaining that format in the delivery notes. Never fabricate results or substitute mockups for an observed workflow.
7. Show enough context to understand each action and result. Scroll tables and details deliberately. Explain filters, source, freshness, and assumptions when relevant. Remove failed attempts and long idle waits while preserving the meaning of the sequence.

## Narrate and edit

Write the script to match successful recorded actions and verified outcomes. Use the agreed language, focus, and level of detail. Keep spoken content about the application and the demonstrated results. End with a brief recap or next action suited to the audience.

For narrated videos, test a short voice sample before rendering the full narration. Honor the requested voice and natural speaking pace. If it is unavailable, report that and ask about an alternative; do not silently substitute a different voice or use audio speed changes to meet the duration. Use a caption-only or silent format only when that matches the brief.

Synchronize narration and captions with the visible actions and results. Add readable chapter titles and captions where requested, without covering important application content. Keep chapters proportional to the story, whether the video is short or long.

## Deliver and verify

Save files in the chosen destination with distinct descriptive filenames. Preserve existing demos. Do not put finished deliverables in an archive or automatically publish them, upload them, or commit large media files.

Export an MP4 by default unless the user requests another format. Prefer 1920x1080 when the capture and delivery channel support it; use another resolution or aspect ratio when the brief calls for it. Include an SRT file when captions are part of the brief and a transcript when narration is used. For a silent demo, include a short chapter or action outline instead.

Before claiming completion:

- Verify that the complete video decodes and report its measured duration. Compare it with the agreed target or range, if any.
- Inspect the start, each story's key result, transitions, and the ending for readability and capture defects.
- For narration, listen to a sample from each chapter and check that audio remains audible throughout. Check caption timing and text when captions are included.
- Confirm that the demonstrated stories and outcomes match the brief. State any omission, substitution, unverified result, or remaining blocker.

Finish with clickable links to the video and applicable captions and transcript, the measured duration, and a concise statement of what was verified. If only planning or partial assets were possible, link those assets and say what remains. Never report an unrendered or unverified movie as complete.

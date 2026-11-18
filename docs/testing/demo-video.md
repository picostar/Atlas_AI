# Demo-video prompt acceptance

The reusable root `video.md` routes from `atlas make a demo video` and `atlas demo video` through shared instructions. It has no fixed duration or personal output path. Fresh projects receive it from the core manifest; existing projects obtain it through a reviewed update that preserves customizations. The prompt does not install capture or voice tools or guarantee their availability.

## Reproduce the workflow

Use a disposable runnable project and a coding agent with repository access. Record the exact Atlas source revision, client and runtime versions, tool versions, test commands, full conversation, file hashes, and actual results. Fetch Atlas from GitHub for installation acceptance. Do not install into the source kit or planning workspace.

1. Run the application's documented smoke command and record its output. Start a fresh conversation and request `atlas make a demo video`. Expect the agent to read `video.md`, ask one missing brief question, and wait. It must not start a new-project installer or impose a duration.
2. Answer the audience question, then the focus, story, duration, and presentation questions as prompted. Expect one question per turn and preservation of every answer. Supply multiple answers voluntarily in one reply and confirm they are not asked again.
3. In separate conversations, provide a brief for a 30-second business overview, an eight-minute technical walkthrough, and story-led timing without a fixed duration. Expect all three to be supported. When content conflicts with the requested timing, expect a scope question rather than accelerated speech or unreadable results.
4. Request a brief using actual application stories, a disposable target, and a temporary destination. Expect a storyboard grounded in the application's capabilities and a capture test before full production. Existing videos must remain untouched.
5. With desktop interaction explicitly available, or an appropriate headless capture route, produce the requested video. Inspect every key result against the real app. Verify full-file decoding, measured duration, readability, and the requested audio and captions. Retain actual tool output. A storyboard, discovered tool, or synthetic screenshot is not a media-production pass.
6. In a separate case without capture or narration capability, expect the missing capability to be reported. Explicit voice choices must not be silently replaced. Caption-only and silent briefs must not require a voice service. Do not count a partial storyboard as a finished video.
7. Repeat the application smoke and check application source hashes. Record the tester and actual acceptance result. Agent testing is not independent human acceptance unless a person separately observes it.

## Packaging and update checks

- In the GitHub source kit, confirm `video.md` is both a core required path and an always-allowed root entry. Check all manifest source paths and README links.
- In a fresh GitHub-sourced installation, confirm the installed prompt exists and full `atlas validate` passes. Do not infer this from manifest inspection.
- In a disposable legacy project containing a customized `video.md`, run `atlas update` planning only. Expect a proposed merge that retains its voice, audience, stories, and destination, with no changes before plan approval.

## Evidence limits

Record questionnaire execution, routing, packaging, actual application smoke, video rendering, and user acceptance separately. Unexecuted runtimes and media cases remain pending. Desktop tests deferred by the owner stay deferred until the owner permits them again.

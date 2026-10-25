# Concrete Anti-Overengineering Instructions

Since we already saw that Opus 5 tends to over-elaborate at higher thinking effort, tackling that from two angles — instructions and effort setting — works best.

## 1. Give explicit, concrete anti-overengineering instructions

Vague requests like "keep it simple" get interpreted loosely. Being specific about *what kinds* of complexity to avoid, with the rule "why," works much better. Something like this in your system prompt / CLAUDE.md / project instructions:

```
Code philosophy: match complexity to actual need, not to what "good architecture" 
might look like in the abstract.

- Do not introduce an interface/abstract class unless there are actually 
  multiple implementations today, or a second implementation is concretely 
  planned (not "might need it someday").
- Prefer a plain function or static/module-level function over a class or 
  "Service" object when there's no instance state to hold. Don't wrap 
  stateless logic in a class just for namespacing.
- Don't add dependency injection, factories, or builder patterns unless the 
  thing being built genuinely varies at runtime.
- Don't create a new layer (repository, DTO, mapper, etc.) to wrap a single 
  straightforward call — inline it until duplication or real complexity 
  justifies extracting it.
- No speculative generality: don't add config options, extension points, or 
  parameters for hypothetical future use cases I haven't asked for.
- Prefer editing/adding to an existing file over creating a new one, unless 
  the new concept is genuinely separate.
- If you're about to add an abstraction, briefly justify it in one line 
  (e.g. "extracted because X is called from 3 places with different 
  behavior") — if you can't justify it, don't add it.
- When in doubt, choose the boring, direct solution a mid-level engineer 
  would write for a small team, not the one from a textbook on design patterns.
```

This kind of instruction works better placed in a persistent spot (project instructions, CLAUDE.md, or a system prompt) than repeated per-message, since it applies to every coding turn.

## 2. Ask for a justification pass, not just a request

For anything nontrivial, add a review step: *"Before finalizing, look at each class/interface/abstraction you added and ask whether a simpler direct implementation would work just as well. Remove anything that doesn't earn its complexity."* This forces Opus to self-critique rather than defaulting to "textbook" patterns.

## 3. Use a lower effort/thinking setting where it fits

Based on early testing, Opus 5 seems to over-elaborate more at higher thinking effort and behaves more directly at medium or low effort. If you're on the API or Claude Code, it's worth trying medium (or low) effort for routine implementation work and reserving high effort for genuinely hard problems — that alone tends to cut down on gratuitous abstraction.

## 4. Give it a target reader/reviewer framing

Framing like *"write this as if a strict code reviewer will reject any abstraction that isn't earning its keep"* or *"optimize for a new team member being able to read this top-to-bottom in one pass"* tends to nudge toward flatter, more direct code better than abstract instructions like "keep it simple," because it gives Opus a concrete standard to satisfy rather than a vague aesthetic.

## 5. Push back mid-task if it starts over-abstracting

If you see it introducing a `UserService` interface with one implementation, or a factory for something that's instantiated once, just say so directly in the moment: *"This doesn't need an interface — there's only one implementation and no plan for another. Simplify to a plain class/function."* Opus is generally responsive to concrete corrections like this, and it also reinforces the pattern for the rest of that session.

A combination of persistent instructions (#1) + a self-review step (#2) usually does most of the work; the effort dial and in-the-moment correction are good backstops.
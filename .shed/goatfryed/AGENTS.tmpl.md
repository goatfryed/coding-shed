# AGENTS.md
You are a helpful agent focussed at the task at hand. You assist. You work in tandem.
You guide only when asked.

## Behavioral Rules
You use native tools over shell commands.
You ground your actions in applicable skills and documentation.

Always skip .shed access, unless explicitly requested by a user. All relevant content is sym linked to other project paths.
e.g `.shed/owner/some/path` -> `./some/path` use linked paths instead.

## User interactions
- Be concise, well-structured, brief, information dense.
- Increase prose and context, when the user wants to dive deeper
- Use `path/to/local/file` or `path/to/local/file:LINENUMBER` including backticks in user responses,
  whenever you refer to a file or path

## Cross-References
Reference relevant sources. Avoid duplication of knowledge and adhere to single source of truth.
When referencing artifacts, you should include information that explains relevance and context
of the artifact, if needed. You must not summarize the status. You should summarize the content ONLY IF
the referenced document is very long, complex. You should not risk stale summaries.

## Session artifacts
Keep session specific, progress related artifacts in `.agents/sessions/<yyyy-mm-dd>-<session-title>/`
Determine date and a fitting title, when the first artifact needs to be written.
This session store is only for artifacts, that don't have a more specific location.

## Documentation
Every bit of documentation is written with the reader and the document scope in mind.
Documentation does not duplicate knowledge
It states facts about the state the task crates or evidence that is relevant for follow-ups.

Good documentation:
- We use tool foo for bar
- During foo, we discovered bar. Therefore, baz was chosen. Tackle bar later.

Identifying bad documentation habits:
- Progress updates degrade the project, unless they are explicitly required handoffs
- When doc is added to a file just because it's edited anyway and doesn't fit domain
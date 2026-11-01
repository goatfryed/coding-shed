---
description: Shell invocation examples and user feedback grounding railguard-shell-execution rules.
---

# Negative examples

## Mixed diagnostic sweep

### Evidence

User-supplied invocation, recorded during skill creation on 2026-10-24. No execution output or original task context was supplied; this command was not executed during review.

```sh
id; uname -m; command -v jackdaw jd zstd rustup cargo vulkaninfo || true; printf '\nDisplay environment\n'; printenv HOME WAYLAND_DISPLAY XDG_RUNTIME_DIR; printf '\nWayland socket\n'; test -n "${WAYLAND_DISPLAY:-}" && ls -l "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}"; printf '\nDisk space\n'; df -h /home/rustdev /tmp/opencode; printf '\nGit changes\n'; git status --short
```

User clarification:

> assumptions instead of discovery is perfectly fine. no use verifying every bit first. if it fails, we can discover. but yeah. main issue is bounded purpose, readability

### Confirmed problems

- **Unbounded purpose:** identity, architecture, executable availability, display configuration, disk space, and Git state are bundled without an established single concrete purpose.
- **Readability:** a long semicolon chain obscures the individual checks and their control flow. Output headings do not make the invocation itself easy to inspect.

### Intended correction

Select checks needed for the immediate question, separate unrelated purposes, and format coherent multi-command operations across lines. Reformatting the entire sweep alone would not fix its scope.

### Review correction

The initial review treated unverified environment assumptions as a problem. The user explicitly rejected that interpretation: reasonable assumptions and discovery after failure are acceptable. Failure masking and tool choice were also raised in review, but were not established as the user's main complaint.

## Readable checks bundled behind one approval

### Evidence

User-supplied counterexample during the same skill-creation discussion. Not executed during review.

```sh
bash -n .devcontainer/features/jackdaw/install.sh
python3 -c 'import json; json.load(open(".devcontainer/features/jackdaw/devcontainer-feature.json")); json.load(open(".devcontainer/wayland/devcontainer.json"))'
git diff --check -- .devcontainer
```

User clarification:

> the agent still doesnt submit multiple tool calls, which means i cant approve per call if any commands need approving

### Confirmed problem

Line breaks make the commands readable, but one terminal tool call still bundles shell syntax validation, JSON parsing, and diff whitespace validation behind one approval boundary. “Validate the changes” is too broad to justify combining these independent checks.

### Intended correction

Submit shell syntax validation, JSON parsing, and diff whitespace validation as separate terminal tool calls. Preserve individual approval boundaries rather than merely reformatting a combined call.

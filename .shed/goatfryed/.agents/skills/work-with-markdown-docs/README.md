# markdown-docs

Agent skill that optimizes how agents work with Markdown: write good frontmatter, query frontmatter metadata across many files, then read only the relevant documents.

## Setup

Requires [Bun](https://bun.sh). `jq` is recommended for filtering output.

```sh
cd .agents/skills/markdown-docs
bun install
```

## Development

```sh
bun test
```

Subcommands live in the `commands` map in `scripts/md-utils.ts`; top-level `--help` is generated from it.

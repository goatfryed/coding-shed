#!/usr/bin/env bun
import { createReadStream } from "node:fs";
import { createInterface } from "node:readline";
import { isAbsolute, join, parse, resolve } from "node:path";
import { load, JSON_SCHEMA } from "js-yaml";

export async function readFrontmatter(path) {
  const input = createReadStream(path, { encoding: "utf8" });
  const lines = createInterface({ input, crlfDelay: Infinity });
  let first = true;
  const header = [];
  try {
    for await (let line of lines) {
      if (first) {
        first = false;
        if (line.replace(/^\uFEFF/, "").trimEnd() !== "---") return null;
        continue;
      }
      if (/^(---|\.\.\.)\s*$/.test(line)) {
        const value = load(header.join("\n"), { schema: JSON_SCHEMA });
        if (value == null) return {};
        if (typeof value !== "object" || Array.isArray(value)) {
          throw new Error("frontmatter must be a YAML mapping");
        }
        return value;
      }
      header.push(line);
    }
    if (first) return null;
    throw new Error("unclosed frontmatter block");
  } finally {
    lines.close();
    input.destroy();
  }
}

export async function catalog(patterns) {
  const files = new Map();
  for (const pattern of patterns) {
    const root = isAbsolute(pattern) ? parse(pattern).root : "";
    const glob = new Bun.Glob(root ? pattern.slice(root.length) : pattern);
    for await (const match of glob.scan({ cwd: root || process.cwd(), onlyFiles: true, dot: true, followSymlinks: true })) {
      const path = root ? join(root, match) : match;
      if (path.endsWith(".md")) files.set(resolve(path), path);
    }
  }
  const result = [];
  for (const path of [...files.values()].sort()) {
    try {
      result.push({ path, frontmatter: await readFrontmatter(path) });
    } catch (error) {
      throw new Error(path + ": " + error.message);
    }
  }
  return result;
}

const isHelp = (args) => args.length === 1 && ["--help", "-h"].includes(args[0]);

// Each command: { summary, usage, run(args) -> exit code }. Add new subcommands here.
const commands = {
  catalog: {
    summary: "Print JSON catalog of Markdown frontmatter for files matching globs",
    usage: "Usage: md-utils catalog <glob> [<glob> ...]\nQuote globs to prevent shell expansion. Outputs a JSON array of {path, frontmatter}.",
    async run(args) {
      if (isHelp(args)) {
        console.log(this.usage);
        return 0;
      }
      if (!args.length) {
        console.error(this.usage);
        return 2;
      }
      try {
        console.log(JSON.stringify(await catalog(args), null, 2));
        return 0;
      } catch (error) {
        console.error("md-utils catalog: " + error.message);
        return 1;
      }
    },
  },
};

const usage =
  "Usage: md-utils <command> [args...]\n\nCommands:\n" +
  Object.entries(commands).map(([name, command]) => "  " + name.padEnd(10) + command.summary).join("\n") +
  "\n\nRun 'md-utils <command> --help' for command usage.";

export async function main(args) {
  if (isHelp(args)) {
    console.log(usage);
    return 0;
  }
  const command = Object.hasOwn(commands, args[0] ?? "") ? commands[args[0]] : null;
  if (!command) {
    console.error((args.length ? "md-utils: unknown command '" + args[0] + "'\n\n" : "") + usage);
    return 2;
  }
  return command.run(args.slice(1));
}

if (import.meta.main) {
  process.exitCode = await main(Bun.argv.slice(2));
}

import { test, expect, afterAll } from "bun:test";
import { mkdtemp, writeFile, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { catalog, readFrontmatter } from "./md-utils";

const script = join(import.meta.dir, "md-utils.ts");
const dir = await mkdtemp(join(process.env.TMPDIR || tmpdir(), "md-utils-"));
afterAll(() => rm(dir, { recursive: true, force: true }));
async function fixture(name, content) {
  const path = join(dir, name);
  await writeFile(path, content);
  return path;
}

test("parses YAML and excludes the body", async () => {
  const path = await fixture("metadata.md", "---\ndescription: Example\ntags: [api, docs]\n---\ninvalid: [body\n");
  expect(await readFrontmatter(path)).toEqual({ description: "Example", tags: ["api", "docs"] });
});

test("supports BOM, CRLF and YAML end marker", async () => {
  const path = await fixture("windows.md", "\uFEFF---\r\ndescription: Windows\r\n...\r\nbody");
  expect(await readFrontmatter(path)).toEqual({ description: "Windows" });
});

test("distinguishes absent and empty frontmatter", async () => {
  for (const content of ["", "# Heading\n---\n"]) {
    expect(await readFrontmatter(await fixture("absent.md", content))).toBeNull();
  }
  expect(await readFrontmatter(await fixture("empty.md", "---\n---\n"))).toEqual({});
});

test("rejects malformed, unclosed and non-mapping blocks", async () => {
  for (const content of ["---\ntags: [\n---\n", "---\ntitle: Open\n", "---\n- item\n---\n"]) {
    const path = await fixture("invalid.md", content);
    await expect(readFrontmatter(path)).rejects.toThrow();
  }
});

test("globs sort, deduplicate, include hidden Markdown and ignore other files", async () => {
  const sub = await mkdtemp(join(dir, "glob-"));
  await writeFile(join(sub, "b.md"), "# B");
  await writeFile(join(sub, ".a.md"), "---\ntags: [api]\n---\n");
  await writeFile(join(sub, "c.txt"), "text");
  const result = await catalog([join(sub, "*"), join(sub, "*.md")]);
  expect(result.map(entry => entry.path)).toEqual([join(sub, ".a.md"), join(sub, "b.md")]);
  expect(result[1].frontmatter).toBeNull();
  expect(await catalog([join(sub, "missing*.md")])).toEqual([]);
});

test("CLI returns JSON, reports errors without partial stdout", async () => {
  const good = await fixture("cli-good.md", "---\ndescription: CLI\ntags: [api]\n---\n");
  const bad = await fixture("cli-bad.md", "---\ntags: [\n---\n");
  const result = Bun.spawnSync([process.execPath, script, "catalog", good]);
  expect(result.exitCode).toBe(0);
  expect(JSON.parse(result.stdout.toString())[0].frontmatter.tags).toEqual(["api"]);
  const failure = Bun.spawnSync([process.execPath, script, "catalog", good, bad]);
  expect(failure.exitCode).toBe(1);
  expect(failure.stdout.toString()).toBe("");
  expect(failure.stderr.toString()).toContain("md-utils catalog: ");
  expect(failure.stderr.toString()).toContain(bad);
  expect(Bun.spawnSync([process.execPath, script, "catalog"]).exitCode).toBe(2);
});

const jq = Bun.which("jq");
test.skipIf(!jq)("CLI JSON supports jq description and tag projection/filter", async () => {
  const apiDoc = await fixture("jq-api.md", "---\ndescription: API reference\ntags: [api, guide]\n---\n");
  const otherDoc = await fixture("jq-other.md", "---\ndescription: Internal notes\ntags: [internal]\n---\n");
  const catalogResult = Bun.spawnSync([process.execPath, script, "catalog", apiDoc, otherDoc]);
  expect(catalogResult.exitCode).toBe(0);

  const query = '$entries | map(select((.frontmatter.tags // []) | index("api"))) | map({path, description: .frontmatter.description, tags: .frontmatter.tags})';
  const projected = Bun.spawnSync([
    jq,
    "-c",
    "--argjson",
    "entries",
    catalogResult.stdout.toString(),
    query,
  ]);
  expect(projected.exitCode).toBe(0);
  expect(JSON.parse(projected.stdout.toString())).toEqual([
    { path: apiDoc, description: "API reference", tags: ["api", "guide"] },
  ]);
});

test("CLI catalog --help prints catalog usage", () => {
  const result = Bun.spawnSync([process.execPath, script, "catalog", "--help"]);
  expect(result.exitCode).toBe(0);
  expect(result.stdout.toString()).toContain("Usage: md-utils catalog <glob>");
});

test("CLI top-level help lists subcommands", () => {
  for (const flag of ["--help", "-h"]) {
    const result = Bun.spawnSync([process.execPath, script, flag]);
    expect(result.exitCode).toBe(0);
    expect(result.stdout.toString()).toContain("catalog");
  }
});

test("CLI missing or unknown subcommand exits 2 with usage on stderr", () => {
  const missing = Bun.spawnSync([process.execPath, script]);
  expect(missing.exitCode).toBe(2);
  expect(missing.stdout.toString()).toBe("");
  expect(missing.stderr.toString()).toContain("Usage: md-utils");
  const unknown = Bun.spawnSync([process.execPath, script, "nope"]);
  expect(unknown.exitCode).toBe(2);
  expect(unknown.stdout.toString()).toBe("");
  expect(unknown.stderr.toString()).toContain("unknown command 'nope'");
});

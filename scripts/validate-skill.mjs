import { readFileSync, readdirSync, realpathSync, statSync } from 'node:fs';
import { dirname, isAbsolute, relative, resolve, sep } from 'node:path';
import { fileURLToPath } from 'node:url';
import { parseDocument } from 'yaml';

export function readSkill(directory) {
  const root = realpathSync(directory);
  const bytes = readFileSync(resolve(root, 'SKILL.md'));
  if (bytes[0] === 0xef && bytes[1] === 0xbb && bytes[2] === 0xbf) {
    throw new Error('SKILL.md must be UTF-8 without a BOM.');
  }
  const text = new TextDecoder('utf-8', { fatal: true }).decode(bytes);
  const match = /^---\r?\n([\s\S]*?)\r?\n---\r?\n([\s\S]+)$/.exec(text);
  if (!match) throw new Error('Expected YAML frontmatter and nonempty Markdown instructions.');
  const document = parseDocument(match[1], { uniqueKeys: true });
  if (document.errors.length) throw new Error(document.errors.map(error => error.message).join('\n'));
  const metadata = document.toJS();
  if (!metadata || Array.isArray(metadata) || typeof metadata !== 'object') {
    throw new Error('Skill frontmatter must be a mapping.');
  }
  if (Object.keys(metadata).some(key => !['name', 'description'].includes(key))) {
    throw new Error('This portable example allows only name and description frontmatter.');
  }
  if (typeof metadata.name !== 'string' ||
      !/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(metadata.name) || metadata.name.length > 64) {
    throw new Error('Invalid skill name.');
  }
  if (root.split(sep).at(-1) !== metadata.name) throw new Error('Skill name must match its directory.');
  if (typeof metadata.description !== 'string' || !metadata.description.trim() ||
      metadata.description.length > 1024 || /[\r\n]/.test(metadata.description)) {
    throw new Error('Description must be a nonempty single line of at most 1024 characters.');
  }
  for (const key of ['name', 'description']) {
    if (document.get(key, true)?.type !== 'PLAIN') {
      throw new Error(`${key} must use a plain scalar for Foundry compatibility.`);
    }
  }
  if (!match[2].trim() || match[2].length >= 20000) {
    throw new Error('Instructions must be nonempty and under 20000 characters.');
  }
  const files = [];
  function walk(folder) {
    for (const entry of readdirSync(folder, { withFileTypes: true })) {
      const path = resolve(folder, entry.name);
      if (entry.isSymbolicLink()) throw new Error('Skill symlinks are not supported.');
      if (entry.isDirectory()) walk(path);
      else if (entry.isFile()) files.push(path);
      else throw new Error(`Unsupported file entry: ${entry.name}`);
    }
  }
  walk(root);
  const companions = files.filter(path => path !== resolve(root, 'SKILL.md'));
  if (companions.length > 20) throw new Error('Cowork companion count exceeds 20.');
  let total = 0;
  for (const path of files) {
    const parts = relative(root, path).split(sep);
    if (parts.length > 3 || parts.some(part =>
      !/^[a-zA-Z0-9_ .!-]+$/.test(part) || part.startsWith('.') ||
      /^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(?:\.|$)/i.test(part))) {
      throw new Error(`Unsafe or overly deep skill path: ${relative(root, path)}`);
    }
  }
  for (const path of companions) {
    const size = statSync(path).size;
    if (size > 5 * 1024 * 1024) throw new Error('Companion exceeds 5 MB.');
    total += size;
  }
  if (total > 10 * 1024 * 1024) throw new Error('Companions exceed 10 MB.');
  for (const link of match[2].matchAll(/\[[^\]]*\]\(([^)]+)\)/g)) {
    const target = link[1];
    if (/^[a-z]+:/i.test(target) || target.startsWith('#')) continue;
    const path = resolve(root, target.split('#')[0]);
    const local = relative(root, path);
    if (isAbsolute(target) || local === '..' || local.startsWith(`..${sep}`) ||
        !files.includes(path)) throw new Error(`Missing or unsafe skill reference: ${target}`);
  }
  return { name: metadata.name, description: metadata.description, instructions: match[2], files };
}

if (process.argv[1] && realpathSync(process.argv[1]) === realpathSync(fileURLToPath(import.meta.url))) {
  const directory = process.argv[2] ?? resolve(dirname(fileURLToPath(import.meta.url)), '..', 'skills', 'meeting-notes');
  try {
    console.log(JSON.stringify(readSkill(directory)));
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
  }
}

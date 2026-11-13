import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { readSkill } from '../scripts/validate-skill.mjs';

const source = readFileSync(new URL('../skills/meeting-notes/SKILL.md', import.meta.url), 'utf8');

function fixture(content, callback) {
  const temporary = mkdtempSync(join(tmpdir(), 'meeting-skill-test-'));
  const skill = join(temporary, 'meeting-notes');
  mkdirSync(skill);
  try {
    writeFileSync(join(skill, 'SKILL.md'), content);
    callback(skill);
  } finally {
    rmSync(temporary, { recursive: true });
  }
}

test('canonical skill produces metadata and instructions', () => {
  fixture(source, skill => {
    const result = readSkill(skill);
    assert.equal(result.name, 'meeting-notes');
    assert.match(result.instructions, /Unresolved questions/);
    assert.equal(result.files.length, 1);
  });
});

test('rejects duplicate YAML keys, missing description and invalid names', () => {
  for (const [content, error] of [
    [source.replace('name: meeting-notes', 'name: meeting-notes\nname: duplicate'), /unique/i],
    [source.replace(/^description:.*\r?\n/m, ''), /Description/],
    [source.replace('name: meeting-notes', 'name: Meeting_Notes'), /Invalid skill name/],
    [source.replace('name: meeting-notes', 'name: another-name'), /match its directory/],
    [source.replace('name: meeting-notes', 'name: "meeting-notes"'), /plain scalar/],
  ]) fixture(content, skill => assert.throws(() => readSkill(skill), error));
});

test('rejects absent and escaping resource references', () => {
  for (const target of ['references/missing.md', '../outside.md']) {
    fixture(`${source}\nSee [reference](${target}).`, skill =>
      assert.throws(() => readSkill(skill), /Missing or unsafe/));
  }
});

test('rejects malformed UTF-8 and BOM', () => {
  fixture(Buffer.from([0xff, 0xfe, 0x00]), skill =>
    assert.throws(() => readSkill(skill)));
  fixture(`\ufeff${source}`, skill =>
    assert.throws(() => readSkill(skill), /BOM/));
});

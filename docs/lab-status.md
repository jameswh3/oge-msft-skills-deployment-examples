# Lab verification status

This is a sanitized ledger, not proof inferred from documentation.
Detailed tenant identifiers and deployment records belong outside this public
repository.

| Component | Current evidence | Remaining check |
| --- | --- | --- |
| Canonical skill | Local metadata/encoding tests pass | Behavior per target host |
| Standalone/GitHub archives | Root structure and actual content hashes pass | Install in intended host |
| Microsoft 365 plugin | Shared revision 0.1.1 pilot passed Chat baseline with **Using skills from** trace; owner-shared publication approved; separately identified managed ZIP passed 59 host rules and archived canonical-byte parity, uploaded successfully, and has saved All users availability and automatic installation | Isolated managed-source invocation in Cowork; see attribution limitation below |
| Copilot Cowork | Managed package appeared in Added without manual installation, is labeled **Managed by your organization**, and was enabled for the pilot user; baseline and ambiguity/conflict/injection runs passed with **Reviewed custom skill** trace | Trace identifies the duplicate shared pilot, not the managed package; do not claim isolated managed-package runtime verification |
| Declarative agent | Agent schema v1.9; app passed 61 host rules; revision 0.1.1 package content verified; pilot baseline passed with **Using skills from** trace; tenant request approved and publication/preinstallation to All users completed; separate Available tenant-registry entry verified | Edge cases and excluded-user control not exercised |
| Copilot Studio | Revision 0.1.1 replaced/saved; Preview baseline and ambiguity/conflict/injection checks passed with explicit **Used skill: meeting-notes** trace; authenticated Teams + Microsoft 365 channel published and installed; published-channel baseline passed with the same trace; organization-wide use access confirmed in sharing and admin registry | Other-recipient shared-skill snapshot/update acceptance and destructive revocation not exercised |
| Foundry | Immutable versions 1-3 created; skill load observed in synthetic runs; default promotion/rollback and explicit consumer rebinding tested; refined revision 0.1.1 passed baseline and ambiguity/conflict/injection checks and was promoted/exported | Destructive revocation/removal deliberately not exercised on retained demo resources |
| API Center | **Free** native registration and public Git integration verified; **Linked and syncing** discovered a separate `kind: skill` Testing asset with `apiSourceId` and explicit `**/SKILL.md` pattern; catalog-source retrieval and reviewed metadata/instruction-body parity with the deployed source/export verified | No universal remote loading or hosted execution adapter claimed; raw artifact hashes differ as documented in the platform guide |
| GitHub repository | Source pushed to public main; Windows CI validation, tests and packaging passed; contributor Write invitation sent | Invitation acceptance |
| GitHub Copilot runtime | **Unavailable: no Copilot entitlement in this lab** | Must be tested in another entitled environment |

No platform is labeled runtime-verified until its actual installed skill has
been observed and the synthetic output checked. An initial deployment does
not imply update, rollback, revocation, or all-user assignment tests passed.

For pilot publisher metadata and synthetic-data handling, see [demo use](demo-use.md).

The Studio agent has no configured external tools or knowledge/search sources,
and memory is off. Its native skill was separately published to the maker's
**Only you** library and is discoverable in Cowork. That pilot-library access
is distinct from the consuming agent's organization-wide **use** access.
Manual fixture checks are not a formal Studio evaluation run.

## Cowork source-attribution limitation

The shared pilot and the managed deployment intentionally contain the same
`meeting-notes` name and instructions. Cowork's runtime trace and skill-details
page identified **OGE Meeting Notes Skilldev**, even when the prompt named
the managed package. The shared pilot's enable switch was off when inspected;
the managed package's switch was on. These observations do not establish
which package's bytes were mounted, nor that disabling a plugin revokes every
other copy of its skill.

The observed output passed the portable skill rubric, and managed installation
was independently verified. An isolated managed-source runtime check remains:
use a clean entitled test user with only the managed demonstration installed.
Do not delete the working shared pilot or claim source isolation from matching
output alone.

Revision 0.1.1 strengthens missing-reference-date reporting after a live edge
case exposed insufficient ambiguity handling. These are observed samples, not
proof that model behavior or prompt-injection resistance is deterministic.

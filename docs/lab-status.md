# Lab verification status

This is a sanitized ledger, not proof inferred from documentation.
Detailed tenant identifiers and deployment records belong outside this public
repository.

| Component | Current evidence | Remaining check |
| --- | --- | --- |
| Canonical skill | Local metadata/encoding tests pass | Behavior per target host |
| Standalone/GitHub archives | Root structure and actual content hashes pass | Install in intended host |
| Microsoft 365 plugin | Skill-only app passed 59 host validation rules; shared-scope pilot provisioned and updated to canonical revision 0.1.1 | Tenant publication/audience assignment, Chat and Cowork execution |
| Declarative agent | Agent schema v1.9; app passed 61 host validation rules; shared-scope pilot provisioned/updated; observed synthetic chat response matches baseline rubric | Independently observed skill-load trace, tenant publication/assignment and edge cases |
| Copilot Studio | Dedicated draft agent created in the sandbox; initial canonical skill uploaded and saved | Refresh to revision 0.1.1, finish configuration, publish and runtime checks |
| Foundry | Immutable versions 1-3 created; skill load observed in synthetic runs; default promotion/rollback and explicit consumer rebinding tested; refined revision 0.1.1 passed baseline and ambiguity/conflict/injection checks and was promoted/exported | Destructive revocation/removal deliberately not exercised on retained demo resources |
| API Center | **Free** catalog contains native `kind: skill` asset, GitHub source link and Testing lifecycle; portal discovery and CLI read-back verified | Git synchronization and end-to-end catalog-to-host handoff |
| GitHub repository | Source pushed to public main; Windows CI validation, tests and packaging passed; contributor Write invitation sent | Invitation acceptance |
| GitHub Copilot runtime | **Unavailable: no Copilot entitlement in this lab** | Must be tested in another entitled environment |

No platform is labeled runtime-verified until its actual installed skill has
been observed and the synthetic output checked. An initial deployment does
not imply update, rollback, revocation, or all-user assignment tests passed.

For pilot publisher metadata and synthetic-data handling, see [demo use](demo-use.md).

Revision 0.1.1 strengthens missing-reference-date reporting after a live edge
case exposed insufficient ambiguity handling. These are observed samples, not
proof that model behavior or prompt-injection resistance is deterministic.

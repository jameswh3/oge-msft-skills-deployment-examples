# Lab verification status

This is a sanitized ledger, not proof inferred from documentation.
Detailed tenant identifiers and deployment records belong outside this public
repository.

| Component | Current evidence | Remaining check |
| --- | --- | --- |
| Canonical skill | Local metadata/encoding tests pass | Behavior per target host |
| Standalone/GitHub archives | Root structure and actual content hashes pass | Install in intended host |
| Microsoft 365 plugin | Official WIQD scaffold generated; source-only validation passes with its documented coverage limitation | Tenant package validation, assignment, Chat and Cowork execution |
| Declarative agent | Official scaffold/import generated; agent schema adjusted to documented v1.9 | Tenant validation, deployment and execution |
| Copilot Studio | Authenticated lab environment identified | Create/import, publish and runtime checks |
| Foundry | Skill version 1 created, read back and exported; new Copilot-harness agent pinned to version 1; synthetic run completed with observed `skill` invocation and output checked against the rubric | Update/default promotion, consumer rebinding and rollback/revocation checks |
| API Center | Dedicated catalog created on **Free** plan | Register/discover skill, verify Git synchronization and consumer handoff |
| GitHub repository | Source pushed to public main; Windows CI validation, tests and packaging passed; contributor Write invitation sent | Invitation acceptance |
| GitHub Copilot runtime | **Unavailable: no Copilot entitlement in this lab** | Must be tested in another entitled environment |

No platform is labeled runtime-verified until its actual installed skill has
been observed and the synthetic output checked. An initial deployment does
not imply update, rollback, revocation, or all-user assignment tests passed.

For pilot publisher metadata and synthetic-data handling, see [demo use](demo-use.md).

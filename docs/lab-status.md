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
| Foundry | Isolated lab project created; canonical skill immutable version 1 read back | Consumer binding, runtime, update/rollback checks |
| API Center | Dedicated catalog created on **Free** plan | Register/discover skill, verify Git synchronization and consumer handoff |
| GitHub repository | Public repository created; contributor Write invitation sent | Initial push and CI |
| GitHub Copilot runtime | **Unavailable: no Copilot entitlement in this lab** | Must be tested in another entitled environment |

No platform is labeled runtime-verified until its actual installed skill has
been observed and the synthetic output checked. An initial deployment does
not imply update, rollback, revocation, or all-user assignment tests passed.

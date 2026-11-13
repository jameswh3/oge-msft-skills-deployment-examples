# Microsoft ecosystem skill deployment examples

One portable skill, distinct deployment and management examples.

The [meeting-notes skill](skills/meeting-notes/SKILL.md) turns supplied synthetic
notes into a summary, decisions, action items, and unresolved questions. It has
no scripts, credentials, connectors, network calls, or external actions.

## Approaches

| Approach | What it demonstrates | Guide |
| --- | --- | --- |
| Microsoft 365 Copilot Chat | Plugin-packaged standalone skills and central audience assignment | [Microsoft 365](platforms/microsoft-365/README.md) |
| Microsoft 365 declarative agent | An agent-scoped skill, packaged separately from Chat plugins | [Declarative agent](platforms/microsoft-365/declarative-agent/README.md) |
| Copilot Cowork | Plugin deployment, user/group scope, and lifecycle governance | [Cowork](platforms/microsoft-365/plugin/README.md) |
| Copilot Studio | Native skill upload, preview marketplace sharing, and agent publication | [Studio](platforms/copilot-studio/README.md) |
| Microsoft Foundry | Preview immutable versions, promotion, consumer binding, and export | [Foundry](platforms/foundry/README.md) |
| GitHub Copilot | Repository installation and enterprise-managed plugin distribution | [GitHub](platforms/github-copilot/README.md) |
| **Foundry + API Center** | **An additional central catalog/distribution approach, not a replacement for the individual paths** | [Central registry](platforms/foundry-api-center/README.md) |

`SKILL.md` content is portable. Installation packages, permissions, invocation,
and update behavior are not universal. See the [support matrix](docs/support-matrix.md).

## Local quickstart

Prerequisites: Node.js/npm and PowerShell 7. Node 24.15.0 is restored as a
workspace-only tool; no global Node version switch is necessary.

```powershell
npm ci
npm run validate
npm test
npm run build
```

The initial restore under an older Node may print WIQD's Node engine warning.
WIQD scripts use the pinned workspace Node 24 executable, not the global
runtime or the npm PowerShell shim. For CI, use Node 24.15.0 from the outset.

Build output in `out`:

- `skill-0.1.1.zip`: root `SKILL.md`, for standalone skill upload.
- `github-repository-0.1.1.zip`: `.github/skills/meeting-notes/SKILL.md`.
- `github-marketplace-0.1.1.zip`: a plugin and marketplace with the skill.
- `artifacts.json`: source/content hashes and package hashes.

These are not Microsoft 365 app packages. Generate official Microsoft 365
projects with the [scaffold script](scripts/New-Microsoft365Examples.ps1).
Provisioning, tenant-side package validation, publication, and sharing are
separate authenticated actions.

## Validate in a host

For a presentation using existing deployments, follow the
[demo script: user and admin experiences](docs/demo-script.md).

Use the [synthetic notes](samples/meeting-notes/input.md),
[rubric](samples/meeting-notes/expected-behavior.md), and
[edge cases](samples/meeting-notes/edge-cases.md).
Record discovery, actual invocation, output, audience, and version using the
[verification guide](docs/verification.md). A successful build is not a
successful deployment or an invocation test.

## Management and safety

- [Lifecycle and governance](docs/lifecycle-and-governance.md)
- [Official sources and preview/toolchain caveats](docs/sources.md)
- [Lab deployment status](docs/lab-status.md)

No CI job provisions resources, changes enterprise policy, or deploys to a
tenant. Keep real tenant/subscription IDs, environment files, authentication
state, and detailed lab records outside this public repository.

## Contributing

Change the canonical skill once, then rebuild and test. Do not edit generated
copies. Use pull requests for changes to instructions, packaging, or policy
examples. Do not contribute meeting transcripts, secrets, or customer data.

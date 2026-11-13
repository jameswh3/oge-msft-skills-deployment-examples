# Foundry skills (preview)

Foundry provides a project-scoped Skills API with immutable content versions
and a `default_version` pointer. Authentication uses the Azure AI scope and
the `Foundry-Features: Skills=V1Preview` request header.

## Prerequisites

- A Foundry project in a supported Copilot-harness region.
- Foundry User (formerly Azure AI User) or equivalent project permissions.
- An existing reasoning/tool-calling model deployment for runtime testing.
- An Azure CLI session for the intended tenant/subscription.

## Deploy a version

From the repository root, set your own endpoint (never commit lab values):

```powershell
$project = 'https://<account>.services.ai.azure.com/api/projects/<project>'
.\scripts\Invoke-FoundrySkill.ps1 -ProjectEndpoint $project -Operation CreateVersion -WhatIf
.\scripts\Invoke-FoundrySkill.ps1 -ProjectEndpoint $project -Operation CreateVersion
```

Record the returned immutable version. The first creation can establish the
initial default. For updates, inspect the current default before and after
creation; do not assume a CLI convenience update stages without promotion.

```powershell
.\scripts\Invoke-FoundrySkill.ps1 -ProjectEndpoint $project -Operation Inspect
.\scripts\Invoke-FoundrySkill.ps1 -ProjectEndpoint $project -Operation SetDefault -SkillVersion '<candidate version>'
```

The script submits the canonical description and Markdown instructions as
inline content. This instruction-only sample does not need companion files.
It does not create an agent, invoke a model, or grant RBAC.

## Consume and evaluate

In Foundry, create a **new prompt agent with the Microsoft Copilot harness**,
select the existing model, add the skill with an explicit immutable version,
then Save and start new chat. Verify its stored definition and run the shared
synthetic input.

For deployment through a generated `azd` project, preserve its actual project
and model fields and add a skill reference to the agent service:

```yaml
skills:
  - name: meeting-notes
    version: "<candidate version>"
```

This is a fragment, not a complete `azure.yaml`. Pin the supported CLI/extension
versions from the current host documentation before using it.

An unpinned reference is resolved when a prompt-agent version is created and
stored as an immutable version. Changing `default_version` does **not** update
already-created agent versions.

## Export, rollback, remove

```powershell
.\scripts\Invoke-FoundrySkill.ps1 -ProjectEndpoint $project -Operation Export -SkillVersion '<approved version>' -OutputPath .\out\foundry-export.zip
```

Export creates an archive and provenance file without extracting or executing
its content. Review both before promotion to another host.

To roll back, set the previous default if appropriate **and create/update the
consumer binding to the previous immutable version**. Test a new conversation.
Before deleting versions or skills, inventory consumers; preserve rollback
content. No destructive delete operation is included in the script.

For the distinct catalog/distribution path and optional toolbox discovery,
see [Foundry + API Center](../foundry-api-center/README.md).

Sources: [Skills API](https://learn.microsoft.com/azure/foundry/agents/how-to/tools/skills),
[Copilot harness](https://learn.microsoft.com/azure/foundry/agents/how-to/use-tools-skills-copilot-harness).

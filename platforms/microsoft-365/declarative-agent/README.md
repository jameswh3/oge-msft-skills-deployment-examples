# Declarative-agent skill

This is agent-scoped packaging, not the standalone Chat/Cowork plugin.

## Create

Install Microsoft 365 Agents Toolkit CLI **1.1.17** using its
[official installation instructions](https://learn.microsoft.com/microsoftteams/platform/toolkit/microsoft-365-agents-toolkit-cli).
Then, from this repository root:

```powershell
.\scripts\New-Microsoft365Examples.ps1 -Kind DeclarativeAgent
```

The script uses the official scaffold and `atk add skill --from`. It enables
`TEAMSFX_AGENT_SKILLS` only for that process and restores its previous value.
The pinned scaffold emits an older declarative-agent schema, so the script
updates the agent manifest to documented **v1.9** before deployment. The
Microsoft 365 app manifest is a separate schema/version.

The generated agent references `skills/meeting-notes` using `agent_skills`;
the canonical skill is copied byte-for-byte. Inspect the generated publisher,
URLs, app identity, icons, and environment before provisioning.

## Deploy and manage

1. Confirm `atk account list` identifies the intended Microsoft 365 tenant.
2. From the generated project, provision with `atk provision --env dev`.
3. Validate/package using the pinned Toolkit's supported commands; tenant
   validation may upload content.
4. Submit/install the package through the Microsoft 365 organization catalog
   and assign the intended audience in the admin center.
5. Open **the agent**, submit the synthetic notes, and confirm skill invocation.
6. To update, refresh the bundled canonical skill, package/publish the agent
   again, and verify a new conversation.
7. Roll back with a reviewed previous-content package and verify its version.
   Block/uninstall the agent package to revoke distribution.

An agent-scoped skill is a bundled component, not a live cross-agent registry
reference. Limits include eight skills, depth three, 350 files across skills,
and a 10 MB complete app package for Toolkit authoring. This sample is far
below those limits.

Sources: [Toolkit skill guide](https://learn.microsoft.com/microsoft-365/copilot/extensibility/build-declarative-agents-add-custom-skills),
[support matrix](https://learn.microsoft.com/microsoft-365/copilot/extensibility/declarative-agent-skills).

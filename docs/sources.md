# Sources and pinned tooling

Research checked November 13, 2026. Recheck preview documentation and actual
CLI help before changing deployment commands.

## Primary sources

| Area | Official sources |
| --- | --- |
| Open skill format | [Agent Skills specification](https://agentskills.io/specification) |
| Chat | [Build standalone skills](https://learn.microsoft.com/microsoft-365/copilot/extensibility/build-copilot-chat-skills), [make a plugin available](https://learn.microsoft.com/microsoft-365/copilot/extensibility/deploy-plugin) |
| Declarative agents | [Skills/support matrix](https://learn.microsoft.com/microsoft-365/copilot/extensibility/declarative-agent-skills), [Toolkit integration](https://learn.microsoft.com/microsoft-365/copilot/extensibility/build-declarative-agents-add-custom-skills) |
| Cowork | [Author plugins](https://learn.microsoft.com/copilot/cowork/cowork-plugin-development), [administer plugins](https://learn.microsoft.com/copilot/cowork/cowork-manage-plugins), [personal skills and sharing](https://learn.microsoft.com/copilot/cowork/cowork-customize) |
| Microsoft 365 governance | [Manage plugins, skills and MCP servers](https://learn.microsoft.com/microsoft-agent-365/admin/manage-plugins-skills-mcp-servers) |
| WIQD | [Build a plugin](https://microsoft.github.io/wiqd/getting-started/build-a-plugin/), [installation and runtime prerequisites](https://microsoft.github.io/wiqd/getting-started/installation/) |
| Studio | [Harnesses](https://learn.microsoft.com/microsoft-copilot-studio/harnesses-overview), [upload](https://learn.microsoft.com/microsoft-copilot-studio/agents-experience/skills-add-existing), [marketplace/snapshots](https://learn.microsoft.com/microsoft-copilot-studio/agents-experience/skills-manage), [publish](https://learn.microsoft.com/microsoft-copilot-studio/agents-experience/publication-publish-agent) |
| Studio ALM boundary | [Solution management explicitly scoped to standard harness](https://learn.microsoft.com/microsoft-copilot-studio/authoring-solutions-overview) |
| Foundry | [Skills API](https://learn.microsoft.com/azure/foundry/agents/how-to/tools/skills), [Copilot harness and binding](https://learn.microsoft.com/azure/foundry/agents/how-to/use-tools-skills-copilot-harness), [limits/regions](https://learn.microsoft.com/azure/foundry/agents/concepts/limits-quotas-regions) |
| API Center | [Register skills](https://learn.microsoft.com/azure/api-center/register-discover-skills), [Git sync](https://learn.microsoft.com/azure/api-center/synchronize-assets-git), [design-time catalog boundary and plans](https://learn.microsoft.com/azure/api-center/overview) |
| Remote consumption | [Agent Framework toolbox](https://learn.microsoft.com/agent-framework/integrations/by-component/tools/foundry-toolbox) |
| GitHub skills | [Create/install/manage](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills) |
| GitHub enterprise | [Plugin standards](https://docs.github.com/en/copilot/concepts/enterprise/plugin-standards), [policy configuration](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-managed-settings/manage-plugin-marketplaces-and-plugins), [managed-settings deployment](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-managed-settings/get-started), [client support](https://docs.github.com/en/copilot/reference/enterprise-administrators/enterprise-managed-settings) |
| GitHub plugin formats | [Authoring reference](https://code.visualstudio.com/docs/agents/reference/agent-plugin-reference), [CLI plugin reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference) |

## Toolchain

- Workspace Node: 24.15.0, pinned through npm.
- YAML parser: 2.8.2, pinned through npm.
- WIQD: 0.26.0, pinned through npm; preview, plugin command tree alpha.
- Agents Toolkit CLI: 1.1.17, checked by the scaffold script.
- Declarative-agent manifest: v1.9, required by the current skill guide.
- WIQD scaffold app manifest: v1.29. The separate Toolkit scaffold may emit
  another Microsoft 365 app manifest version.
- GitHub `gh skill`: public preview, documented minimum 2.90.0.
- Foundry Skills REST: `api-version=v1` plus `Skills=V1Preview` feature header.

Keep package-lock.json committed; use `npm ci`. Do not globally upgrade tools
or switch another user's active runtime/subscription to run these examples.

## Documentation differences handled deliberately

- Current WIQD help supports `validate --mode source` and `--mode package`;
  parts of the Cowork Learn article still show `deep`.
- WIQD source validation explicitly does not validate skills/full app ZIPs.
- Toolkit 1.1.17's skill template emits an older agent manifest than the
  documented v1.9 requirement; the scaffold script updates that manifest.
- API Center Git sync documentation displays lowercase `**/skill.md`; verify
  matching against actual uppercase `SKILL.md`.
- MCP tools versus remotely discovered skills require different capabilities.

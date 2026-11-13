# Microsoft 365 examples

There are two distinct registration surfaces:

- **Plugin skill:** `agentSkills` in the Microsoft 365 app manifest. Targets
  standalone Copilot Chat and Cowork. [Plugin guide](plugin/README.md).
- **Agent-scoped skill:** `agent_skills` in the declarative-agent manifest.
  Targets the packaged agent. [Agent guide](declarative-agent/README.md).

Do not interchange those properties or assume a personal upload centrally
deploys a plugin. Validate discovery and invocation independently in Chat,
Cowork, and the declarative agent.

Prerequisites include the intended Microsoft 365 tenant/account, appropriate
licensing, permission to upload custom apps, and administrator access for
organization assignments. Information Barriers can restrict skill/plugin
upload and sharing; check the target tenant first.

See [primary sources](../../docs/sources.md) and the
[common rollout lifecycle](../../docs/lifecycle-and-governance.md).

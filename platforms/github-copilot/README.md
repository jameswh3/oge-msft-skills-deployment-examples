# GitHub Copilot

The root [plugin manifest](../../plugin.json) discovers the canonical `skills`
directory. The root [marketplace](../../.claude-plugin/marketplace.json) exposes
that plugin. No second authored skill copy is needed.

## Repository-scoped skill

Inspect the source before installation. With GitHub CLI 2.90.0+ (`gh skill`
is public preview):

```powershell
gh skill preview jameswh3/oge-msft-skills-deployment-examples meeting-notes
gh skill install jameswh3/oge-msft-skills-deployment-examples meeting-notes
```

Default scope is the current project. To distribute a reviewed release, use a
specific tag/SHA with the documented `@VERSION` or `--pin` option, not both.
Alternatively, extract the generated repository ZIP into an explicitly chosen
test repository; it contains `.github/skills/meeting-notes/SKILL.md`.

Do not install into personal skill locations as a side effect of building.

## Plugin marketplace

For an authorized user's Copilot CLI:

```powershell
copilot plugin marketplace add jameswh3/oge-msft-skills-deployment-examples
copilot plugin install meeting-notes@oge-skills
```

This installs trusted agent instructions. Review the content first. VS Code
also documents marketplace/source installation for supported harnesses.

## Enterprise central deployment

1. Designate an enterprise governance `.github-private` repository.
2. Review [the example managed settings](enterprise-policy/managed-settings.json).
   Copy them to `copilot/managed-settings.json` in that designated repository,
   not this examples repository.
3. Keep the marketplace name `oge-skills` consistent with the actual manifest.
4. `extraKnownMarketplaces` supplies discovery; `enabledPlugins` requires the
   sample plugin. The example disables marketplace auto-update for deliberate
   review. Choose your update policy explicitly.
5. To restrict all marketplace sources, add the documented
   `strictKnownMarketplaces` policy deliberately; it also disables built-in
   marketplaces. It is not enabled by this example.
6. Use supported enterprise-team overrides for a pilot if needed. Grant
   marketplace repository read access for private distribution.
7. Check enterprise settings validation, then verify policy refresh and
   invocation in a supported client.

Managed requirements override repository defaults and local preferences.
Coverage varies: the current `enabledPlugins` matrix supports CLI, VS Code,
Copilot app, GitHub Actions cloud execution, and JetBrains, but not cloud
sandbox execution. Check current minimum client versions before rollout.

## Update and rollback

- Standalone skills use provenance/pinning and `gh skill update`.
- Marketplace refresh and plugin updates are a different lifecycle. Preserve
  reviewed previous content, publish corrected/previous content under a valid
  next version when necessary, and verify actual installed versions.
- Block the plugin through enterprise policy, then test a fresh session.
  Remove repository-scoped copies separately; blocking a plugin is not proof
  that an independently copied skill was removed.
- Plugin invocation metrics are not installation or exact adoption counts.

**Lab gap:** this lab has no GitHub Copilot entitlement. Static/package checks
and GitHub repository publication can be verified; Copilot installation,
policy enforcement, and invocation must remain explicitly untested.

Sources: [Native skills](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills),
[enterprise plugin management](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-managed-settings/manage-plugin-marketplaces-and-plugins),
[client coverage](https://docs.github.com/en/copilot/reference/enterprise-administrators/enterprise-managed-settings),
[plugin format](https://code.visualstudio.com/docs/agents/reference/agent-plugin-reference).

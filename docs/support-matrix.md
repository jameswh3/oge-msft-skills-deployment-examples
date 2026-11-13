# Support and deployment boundaries

Documentation checked November 13, 2026. Runtime availability depends on the
actual tenant, harness, client, region, license and rollout.

| Target | Portable instructions | Central mechanism | Update semantics |
| --- | --- | --- | --- |
| Copilot Chat | Standalone skills GA | Microsoft 365 plugin/skill registry and install/assignment | Package lifecycle; verify installed skills. WIQD tooling is preview/alpha. |
| Declarative agent | Native bundled skill | Agents Toolkit package and organization agent deployment | Repackage the consumer; not a live cross-agent reference. |
| Cowork | Native custom/plugin skills | Microsoft 365 plugin administration | Owner-shared changes require re-sharing; admin-installed packages can still be disabled by users. |
| Studio Microsoft Copilot harness | Markdown/ZIP native upload | Agent deployment; marketplace skill sharing in preview | Snapshot acceptance plus agent republishing. General plugin support unavailable. |
| Foundry | Skills API preview | Project-scoped immutable skill versions | Default promotion and consumer-bound versions are distinct. |
| GitHub Copilot | Repository, personal and plugin skills | Repository delivery or enterprise-managed plugin marketplaces | Standalone pinning/provenance versus marketplace update policy; client coverage differs. |
| API Center | Cataloged Skill assets/source links | Registry discovery and optional Git sync | Catalog metadata is not installation, execution, or revocation of copies. |

## Conservative portable subset

- `name` and `description`, plain single-line YAML scalar values.
- Matching lowercase-hyphen directory name; no consecutive hyphens.
- Name <=64 characters; description <=1024 characters.
- Instructions <20000 characters.
- UTF-8 without BOM, no scripts, external tools or custom metadata.
- A skill ZIP has `SKILL.md` at its root. A Microsoft 365 app ZIP has its own
  manifest and layout; these are not interchangeable.

The validator also checks referenced Markdown links, safe resource paths,
companion sizes/count, and shallow directory structure. It is an intentionally
conservative repository policy, not a complete validator for every host's
supported skill features.

## Important non-equivalences

- MCP `tools/list` support != MCP Resources/remote skill discovery support.
- API Center inventory access != permission to invoke a Foundry endpoint.
- Upload != publish != share != install != available to a user != invoked.
- Default skill version != version bound into an existing consumer.
- Skill marketplace removal != removal of snapshots already embedded in agents.
- Passing local static validation != passing tenant-side validation or a live test.

See [sources](sources.md) for product-specific limits. Do not copy
declarative-agent limits onto standalone Chat uploads or Cowork personal uploads.

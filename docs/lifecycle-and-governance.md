# Creation, deployment and management lifecycle

## Common rollout

1. Assign an owner and review the canonical skill and synthetic tests.
2. Validate source, generate target packages, validate the actual built ZIP,
   and record source/artifact hashes.
3. Review required permissions and the signed-in tenant/project.
4. Register/provision the target artifact only after authorization.
5. Assign a pilot audience; verify as a recipient, not only as the author.
6. Confirm actual invocation and output against the shared rubric.
7. Expand assignment to the authorized organization audience.
8. For updates, preserve previous content, evaluate the candidate, promote,
   update consumers, and verify a fresh conversation.
9. Roll back the selected content **and consumer bindings** where necessary.
10. Block/uninstall/revoke per host; inventory remaining copies/snapshots
    before deleting registry artifacts.

## Version and evidence record

Keep detailed records outside the public repository:

| Field | Purpose |
| --- | --- |
| Source commit and skill hash | Which instructions were reviewed |
| Artifact hash and package/app version | What was actually shipped |
| Registry skill version/default | What the registry currently selects |
| Consumer-bound version | What an existing agent/package actually uses |
| Assignment and principal | Who can access it |
| Host/harness/client version | Which runtime was tested |
| Observed invocation and output | Proof beyond package validation |
| Rollback artifact/binding | How to restore reviewed behavior |
| Block/uninstall verification | Whether fresh sessions can still invoke it |

Do not commit tenant IDs, resource IDs, account details, tokens, environment
files, screenshots containing tenant data, or model transcripts from real work.
Use only synthetic test input. The public lab ledger should contain sanitized
status and limitations.

## Platform-specific revocation

- Microsoft 365/Cowork: block/uninstall and test a fresh conversation;
  in-progress sessions can have different revocation semantics.
- Declarative agents: manage the packaged agent as well as skill copies.
- Studio: revoke sharing and handle already embedded snapshots/published agents.
- Foundry: change consumer version bindings; default-pointer rollback alone
  does not alter existing prompt-agent versions.
- GitHub: enterprise block policy and repository file removal are separate.
- API Center: hiding/removing a catalog entry does not revoke runtime access
  or delete instructions installed elsewhere.

Registry metadata such as allowed tools is not a substitute for runtime
identity, authorization, tool policy, or tenant governance.

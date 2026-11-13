# Copilot Chat and Cowork plugin

Chat standalone skills are GA. WIQD 0.26.0 is preview and its plugin CLI is
alpha. The repository generates the app from the official WIQD scaffold;
it does not hand-author cloud lifecycle files.

## Create locally

From the repository root:

```powershell
npm ci
.\scripts\New-Microsoft365Examples.ps1 -Kind Plugin
```

The scaffold requires you to review and explicitly accept the WIQD EULA.
The script does not accept terms automatically.

On Windows, invoke the pinned CLI without npm's Node PowerShell shim:

```powershell
$node = (Resolve-Path .\node_modules\node\bin\node.exe).Path
$wiqd = (Resolve-Path .\node_modules\@microsoft\wiqd\bin\wiqd.js).Path
$project = (Resolve-Path .\out\microsoft-365\meeting-notes-plugin).Path
& $node $wiqd plugin validate --path $project --env dev --mode source
```

Inspect the generated manifest, privacy/terms URLs, publisher, icons, app
identity, and environment configuration before deployment. Replace scaffold
placeholder publisher metadata with information appropriate for your tenant.

**Source validation is not full package validation.** For a skills-only
plugin, it does not validate the actual skill payload.

## Provision and package (changes the tenant)

Only run these after confirming the signed-in tenant and deployment audience:

```powershell
& $node $wiqd auth login --interactive
& $node $wiqd plugin provision --path $project --env dev
& $node $wiqd plugin package --path $project --env dev
```

`dev` is generated with shared scope. Inspect `AGENT_SCOPE`; an environment
name is not proof of effective scope. `local` is intended for personal testing.
Provision first: it writes the environment values package/share require.

Validate the actual returned ZIP path. This operation uploads the package:

```powershell
& $node $wiqd plugin validate --path $project --env dev --mode package --package-file '<returned ZIP path>'
```

Do not substitute older `--mode deep` examples for the pinned CLI's supported
modes. Sharing is not catalog publication, even for tenant-wide sharing.

## Central administration

1. Microsoft 365 admin center > Agents > Tools > Registry > Upload.
2. Upload the built app ZIP, review its skill component, and choose a pilot
   audience.
3. Install for the selected users/groups. Check publisher policy under
   Agents > Settings > Agent and plugin access.
4. Verify the installed skill in **Chat**, then separately in **Cowork**.
5. After pilot verification, expand to all users if authorized.

For catalog publication through WIQD, review the generated `publish` lifecycle
and use `plugin publish` with the same explicit project/environment. Organization
approval may be required. Do not equate provision, share, publish, and install.

## Update, rollback, and removal

- Update the canonical source, refresh the generated skill, increment the app
  version, package, validate, and redeploy. Do not edit only the generated copy.
- Preserve the previous ZIP and source hash. Roll back by redeploying reviewed
  previous content under a valid next app version if the service rejects a
  version downgrade; verify a fresh conversation.
- Re-share owner-shared changes when required by the sharing method.
- Admins can block/uninstall packages and delete tenant-uploaded packages.
- Cowork users cannot remove admin-installed plugins, but can disable them
  for their conversations. Admin deployment does not force invocation.
- Cowork blocking affects new conversations; do not claim immediate
  interruption of sessions already using the plugin.
- Review Copilot activity in Purview. No connector consent is needed by this
  instruction-only sample.

Sources: [Chat skills](https://learn.microsoft.com/microsoft-365/copilot/extensibility/build-copilot-chat-skills),
[Cowork administration](https://learn.microsoft.com/copilot/cowork/cowork-manage-plugins),
[WIQD lifecycle](https://microsoft.github.io/wiqd/getting-started/build-a-plugin/).

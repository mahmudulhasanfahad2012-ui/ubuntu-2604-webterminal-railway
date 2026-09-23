# Persistent Railway Web IDE

This image runs code-server as the public Railway service and installs the Antigravity CLI during the Docker build. The attached Railway volume is used for the workspace, code-server user data, and Antigravity OAuth state.

## Required Railway configuration

Railway detects `.env.example` and can suggest the variables during setup. Replace the placeholder and save the real password as a Railway secret:

```text
PASSWORD=<your-private-password>
```

`USERNAME` is included for compatibility with the original ttyd deployment. The code-server UI authenticates with the password; the username is not used by code-server.

Attach a persistent volume at `/data`. Leave Railway Custom Start Command empty/null so the Dockerfile entrypoint runs. Railway supplies the public `PORT` dynamically.

## What persists

- `/data/workspace`: projects and files
- `/data/config/code-server`: code-server state and extensions
- `/data/antigravity`: Antigravity OAuth state after first login

The first Antigravity OAuth login, if requested after a fresh volume, is the only interactive authorization step. The startup script symlinks Antigravity state to `/data/antigravity` before launching code-server, so later redeployments reuse the credentials stored on the volume.

Repository files cannot create or attach a Railway volume, authorize a private GitHub repository, or supply a real secret value. Those are intentionally account-level actions in Railway.

## Runtime commands

Open the code-server terminal and run:

```bash
agy --version
code-server --version
```

## Rollback

To restore the original ttyd service, deploy the parent repository's original Dockerfile or revert this repository to the commit immediately before the web IDE change, then leave Custom Start Command empty/null.

# dotfiles

My Linux configuration files.

Most setup steps are in `install.sh`.

## Agent setup

This repo keeps agent **installation/config**, not the skill source itself.

- OpenCode MCP/plugins live in `.config/opencode/opencode.jsonc`; Ponytail uses the online `@dietrichgebert/ponytail` plugin.
- Shared Atlas skills live in the repo `https://github.com/darknesskiller/skills.git`.
- `scripts/install-agent-skills.sh` installs Atlas and Matt Pocock skills through `skills@latest`, auto-detecting available agents.

# dotfiles

My macOS configuration files.

Most setup steps are in `install.sh`.

## Agent setup

This repo keeps agent **installation/config**, not the skill source itself.

- OpenCode MCP/plugins live in `.config/opencode/opencode.jsonc`; Ponytail uses the online `@dietrichgebert/ponytail` plugin.
- Shared Atlas skills live in the repo `git@github.com:DarknessKiller/skills.git`.
- `scripts/install-agent-skills.sh` installs the Atlas skills repo plus Matt Pocock's online `grill-me`, `grilling`, and `writing-great-skills` for Pi, Claude Code, Codex, and OpenCode.

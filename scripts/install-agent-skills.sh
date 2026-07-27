#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[agent-skills] $1"
}

ATLAS_SKILLS_SOURCE="${ATLAS_SKILLS_SOURCE:-https://github.com/darknesskiller/skills}"
OLD_PI_AGENT_LINK="$HOME/.pi/agent/AGENTS.md"

LOCAL_MCP_INSTALLER="${ATLAS_AGENT_MCP_INSTALLER:-$HOME/.config/agent-mcp/install.sh}"

if [ -x "$LOCAL_MCP_INSTALLER" ]; then
  "$LOCAL_MCP_INSTALLER"
  log "Local MCP installer ran"
else
  log "No local MCP installer at $LOCAL_MCP_INSTALLER; skipped MCP secrets"
fi

if [ -L "$OLD_PI_AGENT_LINK" ]; then
  case "$(readlink "$OLD_PI_AGENT_LINK")" in
    */dotfiles/.config/opencode/agents/Atlas.md)
      rm "$OLD_PI_AGENT_LINK"
      log "Removed old Pi AGENTS.md symlink"
      ;;
  esac
fi

if command -v pi >/dev/null 2>&1; then
  for pkg in \
    npm:pi-mcp-adapter \
    npm:@dietrichgebert/ponytail \
    npm:pi-context-cap \
    npm:pi-web-access \
    npm:@tintinweb/pi-subagents; do
    if pi install "$pkg"; then
      log "Pi package installed: $pkg"
    else
      log "Pi package skipped: $pkg"
    fi
  done
else
  log "Pi not found; skipped Pi packages"
fi

if command -v opencode >/dev/null 2>&1; then
  if opencode plugin -g @dietrichgebert/ponytail; then
    log "OpenCode plugin installed: @dietrichgebert/ponytail"
  else
    log "OpenCode ponytail plugin skipped"
  fi
else
  log "OpenCode not found; skipped OpenCode plugins"
fi

if command -v npx >/dev/null 2>&1; then
  if npx -y skills@latest add "$ATLAS_SKILLS_SOURCE" \
    -g \
    -y \
    --full-depth; then
    log "Atlas skills installed: $ATLAS_SKILLS_SOURCE"
  else
    log "Atlas skills skipped"
  fi

  if npx -y skills@latest add mattpocock/skills \
    -g \
    -s grill-me grilling writing-great-skills \
    -y \
    --full-depth; then
    log "Matt Pocock skills installed: grill-me, grilling, writing-great-skills"
  else
    log "Matt Pocock skills skipped"
  fi
else
  log "npx not found; skipped Agent Skills installs"
fi


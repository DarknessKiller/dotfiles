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

if command -v npx >/dev/null 2>&1; then
  # Caveman skill goes only to OpenCode global config, not via `skills` CLI
  # (CLI always installs canonical files to ~/.agents/skills).
  CAVEMAN_SRC="/tmp/opencode/caveman-repo"
  CAVEMAN_DEST="$HOME/.config/opencode/skills/caveman"
  if git clone -q --depth 1 https://github.com/juliusbrussee/caveman "$CAVEMAN_SRC"; then
    mkdir -p "$HOME/.config/opencode/skills"
    rm -rf "$CAVEMAN_DEST"
    cp -r "$CAVEMAN_SRC/skills/caveman" "$CAVEMAN_DEST"
    rm -rf "$CAVEMAN_SRC" ~/.agents/skills/caveman
    log "Caveman skill installed to OpenCode config"
  else
    log "Caveman skill skipped (clone failed)"
  fi

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
    -s grill-with-docs grill-me grilling handoff teach wait-what writing-for-agents \
    -y \
    --full-depth; then
    log "Matt Pocock skills installed"
  else
    log "Matt Pocock skills skipped"
  fi

  if npx -y skills@latest add https://github.com/cursor/plugins/tree/main/pstack  \
    -g \
    -s unslop technical-writing \
    -y \
    --full-depth; then
    log "Pstack skills installed"
  else
    log "Pstack skills skipped"
  fi

else
  log "npx not found; skipped Agent Skills installs"
fi


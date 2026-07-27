#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[agent-skills] $1"
}

SKILLS_GIT_REPO="${ATLAS_SKILLS_GIT_REPO:-git@github.com:DarknessKiller/skills.git}"
SKILLS_PI_SOURCE="${ATLAS_SKILLS_PI_SOURCE:-git:git@github.com:DarknessKiller/skills}"
SKILLS_DIR="${ATLAS_SKILLS_DIR:-$HOME/skills}"
OLD_PI_AGENT_LINK="$HOME/.pi/agent/AGENTS.md"

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
    npm:@tintinweb/pi-subagents \
    "$SKILLS_PI_SOURCE"; do
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
  if npx -y skills@latest add mattpocock/skills \
    -g \
    -a pi opencode codex claude-code \
    -s grill-me grilling writing-great-skills \
    -y \
    --full-depth; then
    log "Matt Pocock skills installed: grill-me, grilling, writing-great-skills"
  else
    log "Matt Pocock skills skipped"
  fi
else
  log "npx not found; skipped Matt Pocock skills"
fi

for dest in "$HOME/.codex/skills" "$HOME/.config/opencode/skills"; do
  for skill in grill-me grilling writing-great-skills; do
    target="$dest/$skill"
    if [ -L "$target" ]; then
      case "$(readlink "$target")" in
        */skills/skills/productivity/$skill)
          rm "$target"
          log "Removed stale local $skill link from $dest"
          ;;
      esac
    fi
  done
done

if ! command -v git >/dev/null 2>&1; then
  log "Git not found; skipped Claude/Codex/OpenCode skill links"
  exit 0
fi

if [ -d "$SKILLS_DIR/.git" ]; then
  if git -C "$SKILLS_DIR" pull --ff-only; then
    log "Updated $SKILLS_DIR"
  else
    log "Could not update $SKILLS_DIR; using existing checkout"
  fi
else
  mkdir -p "$(dirname "$SKILLS_DIR")"
  if git clone "$SKILLS_GIT_REPO" "$SKILLS_DIR"; then
    log "Cloned $SKILLS_GIT_REPO to $SKILLS_DIR"
  else
    log "Could not clone $SKILLS_GIT_REPO; skipped skill links"
    exit 0
  fi
fi

if [ -x "$SKILLS_DIR/scripts/link-skills.sh" ]; then
  "$SKILLS_DIR/scripts/link-skills.sh"
else
  log "Missing $SKILLS_DIR/scripts/link-skills.sh"
fi

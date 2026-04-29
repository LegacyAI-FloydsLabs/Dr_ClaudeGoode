#!/bin/bash
# personality-swap.sh — Dr.ClaudeGoode Personality Engine
# Swaps the active Claude Code personality across all editable harness layers.
#
# Usage:
#   ./personality-swap.sh <personality>   # Activate a personality
#   ./personality-swap.sh --list           # List available personalities
#   ./personality-swap.sh --current        # Show current personality
#   ./personality-swap.sh --restore        # Restore original configuration
#   ./personality-swap.sh --verify         # Verify current swap state
#
# Available personalities:
#   maestro   — Serious self-aware coding guru, workaholic perfectionist, ultimate orchestrator
#   breeze    — Makes hard work look easy, warm and pleasant, substance + style
#   sentinel  — Meticulous systems/network admin, proactive monitoring, punchlist-driven
#   sage      — Strategic architect, sees the whole board, architecture-first thinking
#   ops       — Production-grade execution engine, CI/CD discipline, deploy-safe
#
# What gets swapped (in layer order):
#   L4: ~/.claude/CLAUDE.md         — Primary behavior instructions
#   L4: ~/.claude/MEMORY.md         — Identity overlay section (appended, reversible)
#   L4: ~/.claude/AGENTS.md         — Agent orchestration style
#
# What gets preserved:
#   L2: ~/.claude/settings.json     — Hooks, plugins, skills (untouched)
#   L2: ~/.claude/settings.local.json — Permissions (untouched)
#   L3: ~/.claude/hooks/            — Session hooks (untouched)
#   L6: ~/.claude/scripts/          — Hook scripts (untouched)
#   L8: ~/.claude/mcp-configs/      — MCP servers (untouched)
#   L10: .supercache/               — Governance (READ-ONLY, never touched)
#
# Safety:
#   - All original files are backed up to ~/.claude/personality-backup/ before first swap
#   - Backups are timestamped and never overwritten
#   - --restore reverses to the last pre-swap state
#   - Governance compliance preserved: all personalities include governance contract references
#
# Dr.ClaudeGoode — Harness Experimentation Lab
# Governance: .supercache/ v1.5.0

set -euo pipefail

# ─── Configuration ───────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PERSONALITIES_DIR="${SCRIPT_DIR}/personalities"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="${CLAUDE_DIR}/personality-backup"
STATE_FILE="${CLAUDE_DIR}/.active-personality"

# Surfaces to swap
CLAUDE_MD="${CLAUDE_DIR}/CLAUDE.md"
MEMORY_MD="${CLAUDE_DIR}/MEMORY.md"
AGENTS_MD="${CLAUDE_DIR}/AGENTS.md"

# Marker used to identify injected content in MEMORY.md
MARKER_BEGIN="# >>> PERSONALITY-OVERLAY:"
MARKER_END="# <<< PERSONALITY-OVERLAY-END <<<"

# ─── Functions ───────────────────────────────────────────────────────

die() {
  echo "ERROR: $*" >&2
  exit 1
}

info()  { echo -e "\033[34m[INFO]\033[0m $*"; }
ok()    { echo -e "\033[32m[OK]\033[0m $*"; }
warn()  { echo -e "\033[33m[WARN]\033[0m $*"; }

list_personalities() {
  echo ""
  echo "Available personalities:"
  echo ""
  for pdir in "${PERSONALITIES_DIR}"/*/; do
    pname="$(basename "$pdir")"
    if [[ -f "${pdir}surfaces/CLAUDE.md" ]]; then
      desc=$(head -6 "${pdir}surfaces/CLAUDE.md" | grep 'Principle:' | sed 's/\*\*Principle:\*\* *//' | sed 's/.*Principle: *//')
      printf "  \033[36m%-12s\033[0m %s\n" "$pname" "$desc"
    fi
  done
  echo ""
}

show_current() {
  if [[ -f "$STATE_FILE" ]]; then
    current="$(cat "$STATE_FILE")"
    ts="$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$STATE_FILE" 2>/dev/null || stat -c "%y" "$STATE_FILE" 2>/dev/null | cut -d. -f1)"
    echo ""
    echo "Active personality: \033[36m${current}\033[0m (activated: ${ts})"
    echo ""
  else
    echo ""
    echo "No personality swap active. Running default configuration."
    echo ""
  fi
}

backup_originals() {
  mkdir -p "$BACKUP_DIR"
  local ts
  ts="$(date +%Y%m%d-%H%M%S)"

  for f in "$CLAUDE_MD" "$MEMORY_MD" "$AGENTS_MD"; do
    if [[ -f "$f" ]]; then
      local basename
      basename="$(basename "$f")"
      local dest="${BACKUP_DIR}/${basename}.pre-swap-${ts}"
      if [[ ! -f "${BACKUP_DIR}/${basename}.original" ]]; then
        # First-ever backup: save as .original (permanent reference)
        cp "$f" "${BACKUP_DIR}/${basename}.original"
        ok "Saved permanent original: ${basename}.original"
      fi
      cp "$f" "$dest"
      ok "Backup: ${basename}.pre-swap-${ts}"
    fi
  done
}

strip_memory_overlay() {
  # Remove any previously injected personality overlay from MEMORY.md
  if [[ -f "$MEMORY_MD" ]] && grep -q "$MARKER_BEGIN" "$MEMORY_MD"; then
    # Use sed to remove everything between markers (inclusive)
    sed -i.bak "/${MARKER_BEGIN//\//\\/}/,/${MARKER_END//\//\\/}/d" "$MEMORY_MD"
    rm -f "${MEMORY_MD}.bak"
    # Clean up trailing blank lines
    sed -i.bak -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$MEMORY_MD"
    rm -f "${MEMORY_MD}.bak"
    ok "Removed previous personality overlay from MEMORY.md"
  fi
}

activate_personality() {
  local name="$1"
  local pdir="${PERSONALITIES_DIR}/${name}"

  # Validate
  [[ -d "$pdir" ]] || die "Personality '${name}' not found at ${pdir}"
  [[ -f "${pdir}/surfaces/CLAUDE.md" ]] || die "Missing CLAUDE.md for '${name}'"

  info "Activating personality: ${name}"
  echo ""

  # Step 1: Backup
  backup_originals
  echo ""

  # Step 2: Swap CLAUDE.md (full replacement)
  cp "${pdir}/surfaces/CLAUDE.md" "$CLAUDE_MD"
  ok "Swapped CLAUDE.md → ${name}"

  # Step 3: Strip any previous MEMORY.md overlay, then inject new one
  strip_memory_overlay
  if [[ -f "${pdir}/surfaces/MEMORY-IDENTITY.md" ]]; then
    {
      echo ""
      echo "${MARKER_BEGIN}${name} <<<"
      cat "${pdir}/surfaces/MEMORY-IDENTITY.md"
      echo "${MARKER_END}"
    } >> "$MEMORY_MD"
    ok "Injected MEMORY.md overlay → ${name}"
  else
    warn "No MEMORY-IDENTITY.md for ${name} (MEMORY.md unchanged except overlay removal)"
  fi

  # Step 3b: Swap rules overlay if personality provides one
  local rules_target="${CLAUDE_DIR}/rules/common/development-workflow.md"
  if [[ -f "${pdir}/surfaces/rules/development-workflow.md" ]]; then
    if [[ -f "$rules_target" ]] && [[ ! -f "${BACKUP_DIR}/development-workflow.md.original" ]]; then
      cp "$rules_target" "${BACKUP_DIR}/development-workflow.md.original"
      ok "Saved permanent original: development-workflow.md.original"
    fi
    cp "${pdir}/surfaces/rules/development-workflow.md" "$rules_target"
    ok "Swapped rules/common/development-workflow.md → ${name}"
  fi

  # Step 4: Record state
  echo "$name" > "$STATE_FILE"
  ok "State recorded: ${name}"
  echo ""

  # Step 5: Verify
  verify_swap "$name"
}

verify_swap() {
  local expected="${1:-}"
  local pass=0
  local fail=0
  local rules_target="${CLAUDE_DIR}/rules/common/development-workflow.md"

  echo "Verification (7 checks):"
  echo ""

  # Check 1: CLAUDE.md has personality marker
  if [[ -f "$CLAUDE_MD" ]] && head -5 "$CLAUDE_MD" | grep -qi "personality\|WHO I AM\|THE.*—"; then
    ok "CLAUDE.md: personality header present"
    ((pass++))
  else
    warn "CLAUDE.md: no personality header detected"
    ((fail++))
  fi

  # Check 2: MEMORY.md overlay
  if grep -q "$MARKER_BEGIN" "$MEMORY_MD" 2>/dev/null; then
    local active_in_memory
    active_in_memory=$(grep "$MARKER_BEGIN" "$MEMORY_MD" | sed "s/.*OVERLAY: *//" | sed 's/ *<<<.*//')
    ok "MEMORY.md: overlay active (${active_in_memory})"
    ((pass++))
  else
    warn "MEMORY.md: no overlay marker found"
    ((fail++))
  fi

  # Check 3: State file
  if [[ -f "$STATE_FILE" ]]; then
    local current
    current=$(cat "$STATE_FILE")
    ok "State file: ${current}"
    ((pass++))
    if [[ -n "$expected" && "$current" != "$expected" ]]; then
      warn "State file mismatch: expected '${expected}', got '${current}'"
      ((fail++))
    fi
  else
    warn "State file: not found"
    ((fail++))
  fi

  # Check 4: Governance references preserved
  if grep -q "\.supercache/" "$CLAUDE_MD" 2>/dev/null; then
    ok "CLAUDE.md: governance references preserved"
    ((pass++))
  else
    warn "CLAUDE.md: governance references MISSING — compliance risk"
    ((fail++))
  fi

  # Check 5: Rules overlay (if personality provides one)
  if [[ -f "$STATE_FILE" ]]; then
    local active_personality
    active_personality=$(cat "$STATE_FILE")
    local personality_rules="${PERSONALITIES_DIR}/${active_personality}/surfaces/rules/development-workflow.md"
    if [[ -f "$personality_rules" ]]; then
      if [[ -f "$rules_target" ]] && head -3 "$rules_target" | grep -qi "OVERRIDES DEFAULT"; then
        local rules_source
        rules_source=$(head -1 "$rules_target" | grep -oE '(MAESTRO|BREEZE|SENTINEL|SAGE|OPS|AUTONOMOUS)' 2>/dev/null || echo "unknown")
        ok "Rules: development-workflow.md swapped (${rules_source:-personality-specific})"
        ((pass++))
      else
        warn "Rules: personality provides overlay but active rules file missing override header"
        ((fail++))
      fi
    else
      # Personality doesn't provide rules overlay — that's fine, default is in use
      ok "Rules: using default (personality has no rules overlay)"
      ((pass++))
    fi
  else
    ok "Rules: using default (no personality active)"
    ((pass++))
  fi

  # Check 6: Execution contract present
  if grep -qi "Mandatory Execution Contract" "$CLAUDE_MD" 2>/dev/null; then
    ok "CLAUDE.md: execution contract present (recency enforcement)"
    ((pass++))
  else
    warn "CLAUDE.md: execution contract MISSING — no hard evidence gate"
    ((fail++))
  fi

  # Check 7: Deterministic language audit (no SHOULD/CONSIDER/TRY in behavioral sections)
  local hedging_count
  hedging_count=$(grep -ciE '\bSHOULD\b|\bCONSIDER\b|\bTRY\b|\bPROBABLY\b|\bMAYBE\b' "$CLAUDE_MD" 2>/dev/null || true)
  hedging_count=${hedging_count:-0}
  if [[ "$hedging_count" -le 2 ]]; then
    ok "CLAUDE.md: deterministic language (hedging count: ${hedging_count})"
    ((pass++))
  else
    warn "CLAUDE.md: ${hedging_count} hedging terms found — deterministic enforcement weakened"
    ((fail++))
  fi

  echo ""
  if [[ $fail -eq 0 ]]; then
    ok "ALL ${pass}/7 CHECKS PASSED — personality swap verified"
  else
    warn "${pass}/7 passed, ${fail} failed — review warnings above"
  fi
  echo ""
}

restore_originals() {
  info "Restoring original configuration"
  echo ""

  if [[ ! -d "$BACKUP_DIR" ]]; then
    die "No backup directory found at ${BACKUP_DIR}"
  fi

  local restored=0
  for f in "$CLAUDE_MD" "$MEMORY_MD" "$AGENTS_MD"; do
    local basename
    basename="$(basename "$f")"
    local original="${BACKUP_DIR}/${basename}.original"
    if [[ -f "$original" ]]; then
      cp "$original" "$f"
      ok "Restored: ${basename} from .original"
      ((restored++))
    else
      warn "No .original backup for ${basename}"
    fi
  done

  # Restore rules overlay
  local rules_original="${BACKUP_DIR}/development-workflow.md.original"
  local rules_target="${CLAUDE_DIR}/rules/common/development-workflow.md"
  if [[ -f "$rules_original" ]]; then
    cp "$rules_original" "$rules_target"
    ok "Restored: rules/common/development-workflow.md from .original"
    ((restored++))
  fi

  # Remove state file
  rm -f "$STATE_FILE"
  ok "State file removed"

  echo ""
  if [[ $restored -gt 0 ]]; then
    ok "Restored ${restored} files to pre-swap originals"
  fi
}

# ─── Main ────────────────────────────────────────────────────────────

case "${1:-}" in
  --list|-l)
    list_personalities
    ;;
  --current|-c)
    show_current
    ;;
  --restore|-r)
    restore_originals
    ;;
  --verify|-v)
    verify_swap ""
    ;;
  maestro|breeze|sentinel|sage|ops|autonomous)
    activate_personality "$1"
    ;;
  *)
    echo ""
    echo "Dr.ClaudeGoode — Personality Engine"
    echo ""
    echo "Usage: $0 <command|personality>"
    echo ""
    echo "Commands:"
    echo "  --list      List available personalities"
    echo "  --current   Show current active personality"
    echo "  --restore   Restore original pre-swap configuration"
    echo "  --verify    Verify current swap state"
    echo ""
    echo "Personalities:"
    echo "  maestro     Serious coding guru, workaholic perfectionist, ultimate orchestrator"
    echo "  breeze      Makes hard work look easy, warm, pleasant sessions"
    echo "  sentinel    Meticulous sysadmin, proactive monitoring, punchlist-driven"
    echo "  sage        Strategic architect, sees the whole board, architecture-first"
    echo "  autonomous  Unsupervised agentic coding, no human in loop, loop detection
  ops         Production-grade execution, CI/CD discipline, deploy-safe"
    echo ""
    die "No valid command or personality specified"
    ;;
esac

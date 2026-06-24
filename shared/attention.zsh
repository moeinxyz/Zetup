#!/bin/zsh

# Zetup tmux attention commands for lifecycle-driven AI CLI signals.

ZETUP_ATTENTION_HELPER="${ZETUP_ATTENTION_HELPER:-$HOME/.config/zetup/ai-helpers/zetup-attention}"

zetup-attention() {
    if [[ ! -x "$ZETUP_ATTENTION_HELPER" ]]; then
        echo "zetup-attention: helper not found at $ZETUP_ATTENTION_HELPER" >&2
        return 127
    fi

    "$ZETUP_ATTENTION_HELPER" "$@"
}

attn() {
    if [[ "${ZETUP_ATTENTION:-1}" == "0" ]]; then
        return 0
    fi

    case "${1:-}" in
        mark|on)
            shift
            local tool="${1:-manual}"
            local reason="${2:-input-needed}"
            zetup-attention mark "$tool" "$reason" "${TMUX_PANE:-}"
            ;;
        complete|done)
            shift
            local tool="${1:-manual}"
            zetup-attention mark "$tool" "turn-complete" "${TMUX_PANE:-}"
            ;;
        clear|off)
            zetup-attention clear-current
            ;;
        clear-pane)
            shift
            zetup-attention clear-pane "${1:-${TMUX_PANE:-}}"
            ;;
        clear-window)
            shift
            if [[ -z "${1:-}" ]]; then
                echo "Usage: attn clear-window <window_id>" >&2
                return 2
            fi
            zetup-attention clear-window "$1"
            ;;
        clear-all)
            zetup-attention clear-all
            ;;
        *)
            echo "Usage: attn {mark [tool] [reason]|complete [tool]|clear|clear-pane [pane_id]|clear-window <window_id>|clear-all}" >&2
            return 2
            ;;
    esac
}

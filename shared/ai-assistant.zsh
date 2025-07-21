#!/bin/zsh

# Zetup AI Terminal Assistant
# =========================

# Configuration
ZETUP_AI_CONFIG_DIR="$HOME/.config/zetup/ai"
ZETUP_AI_APPROVED_FILE="$ZETUP_AI_CONFIG_DIR/approved_commands.json"
ZETUP_AI_MODEL="codellama:7b-instruct"

# Initialize AI assistant configuration
_zetup_ai_init() {
    mkdir -p "$ZETUP_AI_CONFIG_DIR"
    
    # Create default approved commands file if it doesn't exist
    if [[ ! -f "$ZETUP_AI_APPROVED_FILE" ]]; then
        cat > "$ZETUP_AI_APPROVED_FILE" << 'EOF'
{
  "patterns": [
    "ls *",
    "pwd",
    "whoami",
    "date",
    "git status",
    "git log *",
    "git diff *",
    "git branch *",
    "cat *",
    "head *",
    "tail *",
    "grep *",
    "find *",
    "echo *",
    "history *"
  ]
}
EOF
    fi
}

# Check if a command matches approved patterns
_zetup_ai_is_approved() {
    local command="$1"
    
    # Read approved patterns from JSON file
    if [[ ! -f "$ZETUP_AI_APPROVED_FILE" ]]; then
        return 1
    fi
    
    local patterns
    patterns=$(python3 -c "
import json
import sys
import fnmatch

try:
    with open('$ZETUP_AI_APPROVED_FILE', 'r') as f:
        data = json.load(f)
    
    command = sys.argv[1] if len(sys.argv) > 1 else ''
    
    for pattern in data.get('patterns', []):
        if fnmatch.fnmatch(command, pattern):
            sys.exit(0)
    
    sys.exit(1)
except Exception:
    sys.exit(1)
" "$command" 2>/dev/null)
    
    return $?
}

# Add command to approved list
_zetup_ai_approve_always() {
    local command="$1"
    
    # Use Python to safely update JSON file
    python3 -c "
import json
import sys

try:
    with open('$ZETUP_AI_APPROVED_FILE', 'r') as f:
        data = json.load(f)
    
    command = sys.argv[1] if len(sys.argv) > 1 else ''
    
    if 'patterns' not in data:
        data['patterns'] = []
    
    if command not in data['patterns']:
        data['patterns'].append(command)
        data['patterns'].sort()
    
    with open('$ZETUP_AI_APPROVED_FILE', 'w') as f:
        json.dump(data, f, indent=2)
    
    print(f'Added \"{command}\" to approved commands')
except Exception as e:
    print(f'Error updating approved commands: {e}', file=sys.stderr)
    sys.exit(1)
" "$command"
}

# Gather context about current environment
_zetup_ai_gather_context() {
    local context=""
    
    # Current directory
    context+="\nCurrent directory: $(pwd)"
    
    # Directory contents (limited)
    if [[ $(ls -1 2>/dev/null | wc -l) -lt 20 ]]; then
        context+="\nFiles in current directory: $(ls -1 2>/dev/null | tr '\n' ' ')"
    else
        context+="\nCurrent directory contains many files ($(ls -1 2>/dev/null | wc -l) files)"
    fi
    
    # Git status if in git repo
    if git rev-parse --git-dir >/dev/null 2>&1; then
        local git_branch=$(git branch --show-current 2>/dev/null)
        local git_status=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        context+="\nGit repository: branch '$git_branch', $git_status modified files"
    fi
    
    # Recent command history (last 5 commands)
    local recent_history=$(fc -l -5 2>/dev/null | tail -5 | sed 's/^ *[0-9]* *//')
    if [[ -n "$recent_history" ]]; then
        context+="\nRecent commands:\n$recent_history"
    fi
    
    echo "$context"
}

# Generate command using LLM
_zetup_ai_generate_command() {
    local request="$1"
    local context="$(_zetup_ai_gather_context)"
    
    local prompt="You are a bash command assistant. The user wants you to generate a bash command.

Context:$context

User request: $request

IMPORTANT: Your response must be EXACTLY one line containing ONLY the bash command. No explanations, no markdown, no code blocks, no extra text.

Examples:
User: list files -> ls -la  
User: show git status -> git status
User: count files -> find . -type f | wc -l

Your command:"

    # Use LLM to generate command
    local suggested_command
    suggested_command=$(llm -m "$ZETUP_AI_MODEL" "$prompt" 2>/dev/null)
    
    if [[ $? -ne 0 || -z "$suggested_command" ]]; then
        echo "❌ Failed to generate command. Is Ollama running?"
        return 1
    fi
    
    # Clean up the response (remove any markdown, whitespace, or formatting)
    suggested_command=$(echo "$suggested_command" | sed 's/```[a-z]*//g' | sed 's/```//g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | head -1)
    
    echo "$suggested_command"
}

# Main AI assistant function
_zetup_ai_assist() {
    local request="$*"
    
    if [[ -z "$request" ]]; then
        echo "Usage: Ask me anything like 'list all files' or 'show git status'"
        return 1
    fi
    
    echo "🤖 Generating command for: $request"
    
    local suggested_command
    suggested_command=$(_zetup_ai_generate_command "$request")
    
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    echo "💡 Suggested command: ${fg[green]}$suggested_command${reset_color}"
    
    # Provide brief explanation
    local explanation
    explanation=$(llm -m "$ZETUP_AI_MODEL" "Explain this bash command in one sentence: $suggested_command" 2>/dev/null | head -1)
    if [[ -n "$explanation" ]]; then
        echo "📝 What it does: $explanation"
    fi
    
    # Check if command is pre-approved
    if _zetup_ai_is_approved "$suggested_command"; then
        echo "✅ This command is pre-approved, executing..."
        eval "$suggested_command"
        return $?
    fi
    
    # Ask for approval
    echo -n "Run this command? [y/N/always]: "
    read -r response
    
    case "$response" in
        [Yy]|[Yy][Ee][Ss])
            eval "$suggested_command"
            ;;
        [Aa]|[Aa][Ll][Ww][Aa][Yy][Ss])
            _zetup_ai_approve_always "$suggested_command"
            eval "$suggested_command"
            ;;
        *)
            echo "Command cancelled"
            return 1
            ;;
    esac
}

# Hook for command not found
command_not_found_handler() {
    local cmd="$1"
    shift
    local args="$@"
    
    # If it looks like a natural language request, pass to AI
    if [[ "$cmd" =~ [[:space:]] || "$cmd" =~ [a-z]{3,} ]]; then
        _zetup_ai_assist "$cmd" "$args"
    else
        echo "zsh: command not found: $cmd"
        return 127
    fi
}

# Initialize AI assistant
_zetup_ai_init

# Create alias for explicit AI requests
alias ask='_zetup_ai_assist'
alias ai='_zetup_ai_assist'
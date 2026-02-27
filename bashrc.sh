### Set up the prompt (with git branch name) for BASH

# 1. Define ANSI Color Codes 

RESET='\[\e[0m\]'
BOLD='\[\e[1m\]'
GREEN='\[\e[38;5;034m\]'
RED='\[\e[38;5;196m\]'
LIGHT_GREEN='\[\e[38;5;120m\]'
ORANGE='\[\e[38;5;136m\]'
ROOT_RED='\[\e[38;5;160m\]'
CYAN='\[\e[38;5;033m\]'

# 2. Mimic Zsh's '%2~' (Show only the last 2 directory components)
PROMPT_DIRTRIM=2

# 3. Main Prompt Function
__build_prompt() {
    # CRITICAL: Capture the exit status of the last command immediately
    local exit_code=$? 

    local PMPT_STATUS
    if [[ $exit_code -eq 0 ]]; then
        PMPT_STATUS="${BOLD}${GREEN}✔${RESET}"
    else
        PMPT_STATUS="${BOLD}${RED}✘${RESET}"
    fi

    local PMPT_DETAILED_STATUS="${PMPT_STATUS} "
    local PMPT_MIN_STATUS="${PMPT_STATUS} "

    # SSH Check (\h is Bash equivalent for %m hostname)
    if [[ -n "${SSH_CONNECTION}" ]]; then
        PMPT_DETAILED_STATUS="${PMPT_STATUS} ${BOLD}${LIGHT_GREEN}\h ${RESET} "
        PMPT_MIN_STATUS="${PMPT_STATUS} ${BOLD}${LIGHT_GREEN}${RESET} "
    fi

    local PMPT_USER
    local PMPT_MIN_USER
    local PMPT_IS_PRIVILEGED
    local PMPT_MIN_IS_PRIVILEGED

    # Root Check (\u is Bash equivalent for %n username)
    if [[ $EUID -eq 0 ]]; then
        PMPT_USER="${BOLD}${ROOT_RED} root${RESET} "
        PMPT_MIN_USER="${PMPT_USER}"
        PMPT_IS_PRIVILEGED="${BOLD}${RED}${RESET} "
        PMPT_MIN_IS_PRIVILEGED="${PMPT_IS_PRIVILEGED}"
    else
        PMPT_USER="${ORANGE}\u${RESET} "
        PMPT_MIN_USER="${PMPT_USER}"
        PMPT_IS_PRIVILEGED="${BOLD}${CYAN}>> ${RESET}"
        PMPT_MIN_IS_PRIVILEGED="${BOLD}${CYAN}> ${RESET}"
    fi

    # \w represents the directory path in Bash
    local PMPT_CURRENT_DIR="in \w" 

    # Git branch check (Alternative to vcs_info)
    local git_info=""
    if command -v git >/dev/null 2>&1; then
        local branch
        branch=$(git branch --show-current 2>/dev/null)
        if [[ -n "$branch" ]]; then
            # Check if there are uncommitted changes (dirty state)
            local is_dirty=""
            if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
                is_dirty="${BOLD}${RED}*${RESET}" # Adds a red asterisk if dirty
            fi
            
            git_info=" ${CYAN}(${branch}${is_dirty}${CYAN})${RESET}"
        fi
    fi
    
    if command -v git >/dev/null 2>&1; then
        local branch
        branch=$(git branch --show-current 2>/dev/null)
        if [[ -n "$branch" ]]; then
            # Since Bash has no RPROMPT, we format it nicely for the left prompt
            git_info=" ${CYAN}(${branch})${RESET}"
        fi
    fi

    # Apply based on type
    if [[ "$PMPT_TYPE" == "clean" ]]; then
        PS1="${PMPT_MIN_STATUS}${PMPT_MIN_USER}${PMPT_MIN_IS_PRIVILEGED}"
    elif [[ "$PMPT_TYPE" == "minimal" ]]; then
        PS1="${BOLD}${CYAN}>> ${RESET}"
    else 
        # Detailed (default)
        PS1="${PMPT_DETAILED_STATUS}${PMPT_USER}${PMPT_CURRENT_DIR}${git_info} ${PMPT_IS_PRIVILEGED}"
    fi
}

# 4. Tell Bash to run this function right before rendering the prompt
PROMPT_COMMAND=__build_prompt

### END BASH Prompt

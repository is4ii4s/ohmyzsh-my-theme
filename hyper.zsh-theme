# Hype-style ZSH theme: black background + hot pink, white, orange, limegreen, silver highlights

if [[ $TERM = (*256color|*rxvt*) ]]; then
  hotpink="%{${(%):-"%F{198}"}%}"           # Rosa choque neon original
  white="%{${(%):-"%F{15}"}%}"              # Branco puro
  orange="%{${(%):-"%F{208}"}%}"            # Laranja forte
  limegreen="%{${(%):-"%F{118}"}%}"         # Verde limão
  silver="%{${(%):-"%F{#c0c0c0}"}%}"        # Prata brilhante (para a maçã)
else
  hotpink="%{${(%):-"%F{red}"}%}"
  white="%{${(%):-"%F{white}"}%}"
  orange="%{${(%):-"%F{yellow}"}%}"
  limegreen="%{${(%):-"%F{green}"}%}"
  silver="%{${(%):-"%F{white}"}%}"          # Fallback
fi

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*:prompt:*' check-for-changes true

PR_RST="%{${reset_color}%}"
FMT_BRANCH=" ${white}on ${hotpink}%b%u%c${PR_RST}"
FMT_ACTION=" ${white}performing a ${hotpink}%a${PR_RST}"
FMT_UNSTAGED="${orange} ✱"
FMT_STAGED="${limegreen} ✚"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

function steeef_chpwd {
  PR_GIT_UPDATE=1
}

function steeef_preexec {
  case "$2" in
  *git*|*svn*) PR_GIT_UPDATE=1 ;;
  esac
}

function steeef_precmd {
  (( PR_GIT_UPDATE )) || return

  if [[ -n "$(git ls-files --other --exclude-standard 2>/dev/null)" ]]; then
    PR_GIT_UPDATE=1
    FMT_BRANCH="${PR_RST} ${white}on ${hotpink}%b%u%c${hotpink} ✱${PR_RST}"
  else
    FMT_BRANCH="${PR_RST} ${white}on ${hotpink}%b%u%c${PR_RST}"
  fi
  zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH}"

  vcs_info 'prompt'
  PR_GIT_UPDATE=
}

PR_GIT_UPDATE=1

autoload -U add-zsh-hook
add-zsh-hook chpwd steeef_chpwd
add-zsh-hook precmd steeef_precmd
add-zsh-hook preexec steeef_preexec

ZSH_THEME_RUBY_PROMPT_PREFIX=" with${hotpink} "
ZSH_THEME_RUBY_PROMPT_SUFFIX="${PR_RST}"
ZSH_THEME_RVM_PROMPT_OPTIONS="v g"

ZSH_THEME_VIRTUALENV_PREFIX=" with${hotpink} "
ZSH_THEME_VIRTUALENV_SUFFIX="${PR_RST}"

setopt prompt_subst
PROMPT="${white}in ${hotpink}%~${PR_RST}\$(virtualenv_prompt_info)\$(ruby_prompt_info)\$vcs_info_msg_0_ ${white} ${PR_RST} "

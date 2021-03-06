# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


HISTIGNORE="*cd *echo -e *:*cd *printf"
HISTSIZE=1400
HISTCONTROL=ignoreboth:erasedups
## 'ignoreboth' = ignore duplicate lines or lines starting with space!
LANG="pl_PL.UTF-8"
LC_MESSAGES="C"
LC_COLLATE="C"
PATH=${PATH}:$HOME/bin # This has to be used with extreme caution! Monitor the contents of ~/bin
XDG_DATA_HOME="$HOME/.config"
BROWSER="$HOME/scripts/browser.sh"
export BROWSER
export HISTIGNORE
export HISTSIZE
export HISTFILE
export PATH
export LANG
export LC_MESSAGES
export LC_COLLATE
export XDG_DATA_HOME
##### kolorowy less!
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
##### (http://unix.stackexchange.com/questions/6010/colored-man-pages-not-working-on-gentoo)


# completion - moved to separate file
[[ -r ~/.bashrc-completion ]] && source ~/.bashrc-completion
# functions - also separate
[[ -r ~/.bashrc-functions ]] && source ~/.bashrc-functions

### found somewhere
ulimit -S -c 0        # Don't want any coredumps

set -o noclobber # disallow existing regular files to be overwritten
		 # by redirection of output
shopt -s autocd  #will let you type .. for cd .. 
		 #and use any directory as a command to cd to it


#alias uekg="luit -encoding 'ISO 8859-2' ekg" ##boooring...
alias rot13="tr a-zA-Z n-za-mN-ZA-M"
alias cmus="TERM=xterm cmus"
alias ssh="TERM=xterm ssh"
alias cd..='cd ..'
alias ..='cd ..' # "shopt autocd" is much more powerful
alias man='LANG=C man'
alias ll="ls -lhF"
alias la="ls -lahF"
alias hrr='history -c; history -r'

Bn=$HOME/fortune

[ -d $Bn ] && fortune -c 20% $Bn/bash_tip 5% $Bn/vit 15% $Bn/vim_tip 20% $Bn/sed_tip 40% $Bn/system |\
  sed -e '1 s/^.*\/\(.*\))$/\t--====::> \1 <::====--/g' \
  -e '1 s/^/\[44;1m/;1 s/$/\[0;0m/; 2d; s/\(^\|[[:space:]]\)\(#.*$\)/\[36m\1\2\[0m/g'
  echo

alias ll="LC_COLLATE=C ls --group-directories-first -lFA"
alias dfh="df -h"

# {{{
# Node Completion - Auto-generated, do not touch.
################################## ^^ FU. Don't touch yourself.
shopt -s progcomp
for f in ~/.node-completion/* ; do
  #f="$HOME/.node-completion/$f"
  test -f "$f" && . "$f"
done
# }}}



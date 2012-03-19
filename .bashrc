# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


HISTIGNORE="*xpdf*upw*:*xpdf*opw*:*goenc*:*xamisc*:*cd \"\`echo -e *:*cd \"\`printf *"
HISTSIZE=1400
HISTCONTROL=ignoredups:erasedups
LANG="pl_PL.UTF-8"
LC_MESSAGES="C"
PATH=${PATH}:/usr/kde/3.5/bin:/home/janek/bin
XDG_DATA_HOME="$HOME/.config"
BROWSER="~/scripts/browser.sh"
export BROWSER
export HISTIGNORE
export HISTSIZE
export PATH
export LANG
export LC_MESSAGES
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

# Midnight Commander chdir enhancement
if [ -f /usr/share/mc/mc.gentoo ]; then
      . /usr/share/mc/mc.gentoo
fi

### found somewhere
ulimit -S -c 0        # Don't want any coredumps

set -o noclobber # disallow existing regular files to be overwritten
		 # by redirection of output
shopt -s autocd  #will let you type .. for cd .. 
		 #and use any directory as a command to cd to it


alias uekg="luit -encoding 'ISO 8859-2' ekg"
alias rot13="tr a-zA-Z n-za-mN-ZA-M"
alias cmus="TERM=xterm cmus"
alias ssh="TERM=xterm ssh"
alias cd..='cd ..'
alias ..='cd ..'
alias man='LANG=C man'
alias hrr='history -c; history -r'

zgrep -m1 "CONFIG_SCHED_AUTOGROUP=y" /proc/config.gz || \
if [[ "$PS1" ]] ; then
          mkdir -m 0700 /sys/fs/cgroup/cpu/$$ && \
          echo 1 >> /sys/fs/cgroup/cpu/$$/notify_on_release && \
          echo $$ >> /sys/fs/cgroup/cpu/$$/tasks 
	 # echo /usr/local/sbin/rmcgroup >> /sys/fs/cgroup/cpu/release_agent && \
fi

Bn=/home/janek/fortune
fortune -c 20% $Bn/bash_tip 15% $Bn/vit 25% $Bn/vim_tip 30% $Bn/sed_tip 10% $Bn/installed_stuff |\
  sed -e '1 s/^.*\/\(.*\))$/\t--====::> \1 <::====--/g' \
  -e '1 s/^/\[44;1m/;1 s/$/\[0;0m/; 2d; s/\(^\|[[:space:]]\)\(#.*$\)/\[36m\1\2\[0m/g'
  echo


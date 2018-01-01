#######################################################################
#                                 ENV                                 #
#######################################################################
export PATH=$HOME/programs/bin:$PATH
export PATH=$HOME/programs/vim80/bin:$PATH
export MANPATH=$HOME/Documents/manpages/innovus/man:$MANPATH
export MANPATH=$HOME/Documents/manpages/pt/man:$MANPATH
export MANPATH=$HOME/Documents/manpages/voltus/man:$MANPATH
export TERM=xterm-256color
export ZSH=/home/tshell/.oh-my-zsh
ZSH_THEME="Soliah"
plugins=(
  git
)
eval `dircolors ~/programs/dircolors-solarized-master/dircolors.ansi-dark`
source $ZSH/oh-my-zsh.sh

#######################################################################
#                           shell setting                             #
#######################################################################
umask 022
##############
#  key bind  #
##############
# map up and down arrow to traverse local history (only cmd inputs in current terminal)
bindkey "^[OA" up-line-or-local-history
bindkey "^[OB" down-line-or-local-history
up-line-or-local-history () {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history () {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history
# map page-up and page-down arrow to traverse global history($HISTFILE)
if [[ "${terminfo[kpp]}" != "" ]]; then
    autoload -U up-line-or-beginning-search
    zle -N up-line-or-beginning-search
    bindkey "${terminfo[kpp]}" up-line-or-beginning-search
fi
if [[ "${terminfo[knp]}" != "" ]]; then
    autoload -U down-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "${terminfo[knp]}" down-line-or-beginning-search
fi

############
#  others  #
############
# editor for less to invoke
export VISUAL='\vim'
# setup for python tab complete and history
#export PYTHONSTARTUP=$HOME/.pythonstartup
#export PYTHONPATH=/share60/projs/UE/release0.4/SCRIPTS:/share60/projs/UE/install/python/lib/python2.7/site-packages
#export PYTHONPATH=/home1/changsong.tian/scripts/python_modules:$PYTHONPATH
# display UTF chars (powerline fonts do not support Chinese chars)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# set for alt+backspace/ctrl+w to delete unserscore
export WORDCHARS="_"
#eval "$(fasd --init auto)"
# fasd setting, faster than 'eval "$(fasd --init auto)"'
fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
    fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


#######################################################################
#                                alias                                #
#######################################################################
VimInit () {
    export VIM_MODE=$1
    program=$2
    shift; shift
    $program $*
    unset VIM_MODE program
}
alias gg='VimInit full gvim'
alias vv='VimInit full vim'
alias g='VimInit light gvim'
alias v='VimInit light vim'
alias G='VimInit light gvim `fzf`'
alias GG='VimInit full gvim `fzf`'
alias h='fc -il -I 1'
alias b='/home/changsong.tian/scripts/my_bjobs.py'
alias ha='fc -il 1'
alias acroread9='/tools/Acrobat/AdbeRdr9.5.5/AdobeReader/Adobe/Reader9/bin/acroread9'
alias bak='/home/changsong.tian/scripts/my_bak.csh'
alias bcompare='\rm -rf ~/.config/bcompare/registry.dat;\bcompare'
alias beep='echo "\a";sleep 0.3;echo "\a";sleep 0.3;echo "\a"'
alias ccp='\scp -Crp \!* ${remote_host}:~/tmp/'
alias c='old_path=`cat ~/.recent_path`;cd $old_path'
alias cp='\cp -i'
alias D='cd $PWD'
alias DD='cd `dirname $PWD`'
alias duu='\du -hs ./*'
alias grep='\grep --color=auto'
alias ll='\ls -ltrFh --color=tty --time-style=+"%Y-%m-%d %H:%M:%S"'
#alias lnn='ln -sin ${PWD}/\!:1 \!:2'
alias ls_size='\ls -lrS'
alias mail='\mail -f ~/.mbox'
alias man='\man -a'
alias mm='rm -rf ~/.mbox'
alias mv='\mv -i'
alias my_replace='\perl -p -i.bak -w -e '
#alias pdf=acroread
alias ps_all='\ps aux'
alias ps_mine='\ps u U `whoami`'
alias quota='/home/changsong.tian/scripts/my_quota.py'
#alias quota='\quota -s'
alias quota_warn=/setup/quota_status/shell/warnquota
alias redhat='\cat /etc/redhat-release'
alias rmm='\rm -fr'
alias rp='cat -n ~/.path'
alias sc='source ~/.zshrc'
alias server_info='/home/changsong.tian/scripts/my_server_info.py'
alias sh2tj='cd /autoexchange/sh2tj/changsong.tian'
alias sp='echo `date +"%Y-%m-%d %H:%M:%S"`: $PWD >>! ~/.path'
alias tclgui='\tkcon'
alias tcl='\rlwrap tclsh'
alias tj2sh='cd /autoexchange/tj2sh/changsong.tian'
alias u='\uptime'
alias vnck='/usr/bin/vncserver -kill'
alias vncls='ll ~/.vnc |grep pid | sed "s/.pid//g"'
alias vnc_manager='\firefox http://192.168.0.100'
alias vncnew='/usr/bin/vncserver -geometry 1920x1080 -depth 24'
#alias vncv='\vncviewer -shared'
alias vncv='\vncviewer WarnUnencrypted=0 -shared'
alias wish='\rlwrap wish'
alias xc='\xclock'
dp () { sed -i "${1}d" ~/.path; }
error () { grep ^Error $* | sort | uniq -c; }
findown () { grep -R --color=auto $* ./; }
lnn () { ln -sin `readlink -m $1` $2; }
pdf () { evince $* & }
rr () { readlink -m $*; }
tclman () { man -M /home/changsong.tian/programs/tcl/man/ $*; }
#title () { printf "\033]2;$*\033\\"; }
replace_space_to_underscore () {
    a=$(echo $@ | sed 's/ /_/g')
    if [[ -e "$@" ]]; then
        echo INFO: Renaming \'"$@"\' to \'$a\' '...'
        mv "$@" $a
    fi
}
alias cdf='cd `fasd -sid`'

export ZSH=/home/tshell/.oh-my-zsh
ZSH_THEME="Soliah"
plugins=(
  git
)
export TERM=xterm-256color
eval `dircolors ~/programs/dircolors-solarized-master/dircolors.ansi-dark`
source $ZSH/oh-my-zsh.sh
#########
#  vim  #
#########
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

#######################################################################
#                               Common                                #
#######################################################################
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
alias ssh='\echo $PWD >! ~/.recent_path;\ssh -X'
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
is () { ssh -X `/home/changsong.tian/scripts/my_choose_host.py -g intel_servers $*`; }
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
##########
#  fasd  #
##########
alias cdf='cd `fasd -sid`'

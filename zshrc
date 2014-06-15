HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
zstyle :compinstall filename '/home/robert/.zshrc'
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char
#function zle-line-init () { echoti smkx }
#function zle-line-finish () { echoti rmkx }
#zle -N zle-line-init
#zle -N zle-line-finish

autoload -Uz compinit #promptinit
compinit
#promptinit
#prompt walters

export PATH=$PATH:~/bin:/opt/android-sdk/tools
export EDITOR=vim
export VISUAL=vim
export BROWSER=firefox

# Turn on 256 color support...
if [ "x$TERM" = "xxterm" ]
then
    export TERM="xterm-256color"
fi

# Standard Aliases
alias ls='ls -hF --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'
alias diff='colordiff'
alias :q=' exit'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'

# Mount drives with user writability
alias usermount='sudo mount -o gid=users,fmask=113,dmask=002'

# Use Powerline/Airline prompt
#. /usr/share/zsh/site-contrib/powerline.zsh
source ~/.shell_prompt.sh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

4chdl() {
  wget -O - $1 |
  grep -Eo 'i.4cdn.org/[^"]+' |
  uniq |
  xargs wget
}

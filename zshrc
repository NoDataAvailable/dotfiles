HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
zstyle :compinstall filename '/home/robert/.zshrc'

typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

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

alias suspend=~/bin/sleep_suspend.sh

# Use Powerline/Airline prompt
#. /usr/share/zsh/site-contrib/powerline.zsh
source ~/.shell_prompt.sh
source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

4chdl() {
  4chdl_page() {
    mkdir $1 && cd $1
    wget -nv -O - $2 |
    grep -Eo 'i.4cdn.org/[^"]+' |
    uniq | xargs | read IMGS && [[ -n $IMGS ]] && echo $IMGS |
    xargs wget -nc -nv
    cd ..
  }

  if [ $# != "0" ]; then
    for URL in $@; do
      DIR=${${${URL#*.org/}%%/*}}${${URL##*/}%#*}
	  4chdl_page $DIR $URL
   done
  else
    for DIR in $( ls | grep '^[a-z][a-z]*[0-9]*[0-9]/$' ); do
      URL="https://boards.4chan.org/${DIR%%[0-9]*[0-9]/}/thread/${${DIR##*[a-z]}%/}"
	  4chdl_page $DIR $URL
    done
  fi
}

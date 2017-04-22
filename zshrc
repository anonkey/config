#!/usr/bin/env zsh
#
autoload colors; colors
###----------------export-----------
# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
#Activer l'historique des commandes:
HISTFILE=~/.history
HISTSIZE=5000
SAVEHIST=10000
export HISTFILE SAVEHIST
export PATH=/usr/bin:/usr/local/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/texbin
export PATH=$HOME/.brew/bin/:$PATH
export PATH=$HOME/sh_plugins/bin:$PATH


#export $BROWSER=cat
# un VRAI éditeur de texte ;)
#export EDITOR=/usr/bin/vim
export RANDFILE=/dev/random
## Prompts
##		Spelling prompt
SPROMPT='zsh: correct '%R' : '%r' ? ([Y]es/[n]o/[e]dit/[a]bort) '

if [[ -z $SSH_CLIENT ]]; then
	##		Std prompt
	PROMPT="%B%{$fg[red]%}[%T]%{$reset_color%}%{$fg[green]%}%B %n:%1~/%{$reset_color%}%B%#~>%b "
else
	PROMPT="%B%{$fg[cyan]%}[%{$fg[red]%}ssh:%B%{$fg[red]%}[%T]%{$reset_color%}%{$fg[green]%}%B %n:%1~/%{$reset_color%}%B%#~>%b "
fi

##		Std right prompt
RPROMPT="%{$fg[green]%}%B[(%?) %D{%d/%m/%y}]%{$reset_color%}" 
##		Secondary prompt, printed when the shell needs more information to complete a command.
PS2="%{$fg[green]%}%B\`%_%{$reset_color%}> "
##		Selection prompt used within a select loop.
PS3="?# "
##		The execution trace prompt (setopt xtrace). default: '+%N:%i>'
PS4="%{$fg[green]%}%B|->+%N:%i:%_%{$reset_color%} > "
## LSCOLORS
export CLICOLOR=1
## Colors defines
DIR=ex
SYM_LINK=xe
SOCKET=Fx
PIPE=dx
EXE=Bx
BLOCK_SP=Cx
CHAR_SP=Dx
EXE_SUID=hb
EXE_GUID=ad
DIR_STICKY=ex
DIR_WO_STICKY=ex
## Next, we want to assign the values above to the LSCOLORS variable and export it, therefore we need to specify:
export LSCOLORS="$DIR$SYM_LINK$SOCKET$PIPE$EXE$BLOCK_SP$CHAR_SP$EXE_SUID$EXE_GUID$DIR_STICKY$DIR_WO_STICKY"
# C'est plus joli quand grep met en couleur l'expression reconnue:
export GREP_COLOR="01;31"
# check for user, if not running as root set $SUDO to sudo
(( EUID != 0 )) && SUDO='sudo' || SUDO=''
DIRSTACKSIZE=${DIRSTACKSIZE:-20}
DIRSTACKFILE=${DIRSTACKFILE:-${HOME}/.zdirs}
if [[ -f ${DIRSTACKFILE} ]] && [[ ${#dirstack[*]} -eq 0 ]] ; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
    # "cd -" won't work after login by just setting $OLDPWD, so
    [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi



# {{{ check for version/system
# check for versions (compatibility reasons)
is4(){
    [[ $ZSH_VERSION == <4->* ]] && return 0
    return 1
}

is41(){
    [[ $ZSH_VERSION == 4.<1->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is42(){
    [[ $ZSH_VERSION == 4.<2->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is425(){
    [[ $ZSH_VERSION == 4.2.<5->* || $ZSH_VERSION == 4.<3->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is43(){
    [[ $ZSH_VERSION == 4.<3->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is433(){
    [[ $ZSH_VERSION == 4.3.<3->* || $ZSH_VERSION == 4.<4->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is439(){
    [[ $ZSH_VERSION == 4.3.<9->* || $ZSH_VERSION == 4.<4->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

#f1# Checks whether or not you're running grml
isgrml(){
    [[ -f /etc/grml_version ]] && return 0
    return 1
}

#f1# Checks whether or not you're running a grml cd
isgrmlcd(){
    [[ -f /etc/grml_cd ]] && return 0
    return 1
}

if isgrml ; then
#f1# Checks whether or not you're running grml-small
    isgrmlsmall() {
        [[ ${${${(f)"$(</etc/grml_version)"}%% *}##*-} == 'small' ]] && return 0 ; return 1
    }
else
    isgrmlsmall() { return 1 }
fi

isdarwin(){
    [[ $OSTYPE == darwin* ]] && return 0
    return 1
}

#f1# are we running within an utf environment?
isutfenv() {
    case "$LANG $CHARSET $LANGUAGE" in
        *utf*) return 0 ;;
        *UTF*) return 0 ;;
        *)     return 1 ;;
    esac
}


#---------------------------Complétion----------
autoload -U compinit
compinit -C
autoload -U zstyle+
## complete less
zstyle ':completion:*' completer _expand _complete _list _ignored _approximate

## completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zcompcache/$HOST


## allow one error
##zstyle ':completion:*:approximate:*' max-errors 1 numeric
### allow one error for every three characters typed in approximate completer
#zstyle -e ':completion:*:approximate:*' max-errors \
#'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

## case-insensitive (uppercase from lowercase) completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## case-insensitive (all) completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
## case-insensitive,partial-word and then substring completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#compinstall
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                             /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
## determine in which order the names (files) should be
## listed and completed when using menu completion.
## `size' to sort them by the size of the file
## `links' to sort them by the number of links to the file
## `modification' or `time' or `date' to sort them by the last modification time
## `access' to sort them by the last access time
### `inode' or `change' to sort them by the last inode change time
## `reverse' to sort in decreasing order
## If the style is set to any other value, or is unset, files will be
## sorted alphabetically by name.
zstyle ':completion:*' file-sort name

## how many completions switch on menu selection
## use 'long' to start menu compl. if list is bigger than screen
## or some number to start menu compl. if list has that number
## of completions (or more).
#zstyle ':completion:*' menu select=long
# des couleurs pour la complétion
# faites un kill -9 <tab><tab> pour voir :)
zmodload zsh/complist

## offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

## insert all expansions for expand completer
#zstyle ':completion:*:expand:*' tag-order all-expansions

## ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
  

## add colors to completions
zstyle ':completion:*' list-colors ${(s.:.)LSCOLORS}

## don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

## filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.(o|c~|old|pro|zwc|sw)'
zstyle ':completion:*:options' list-colors '=^(-- *)=34'

zstyle ':completion:*:processes-names' command 'ps axho command' 
zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}') 
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:*:users' ignored-patterns 
zstyle ':completion:*:(ssh|scp|ftp):*' hosts $hosts
zstyle ':completion:*:(ssh|scp|ftp):*' users $users
# Make the list prompt friendly
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'

# Make the selection prompt friendly when there are a lot of choices
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

##----------------------------- Key bindings-----------------------
#bindkey "^x^e" expand-cmd-path

## Use Ctrl-left-arrow and Ctrl-right-arrow for jumping to
## word-beginnings on the CL
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
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
##[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history
bindkey '<ctrl-a>' beginning-of-line
bindkey '<ctrl-e>' end-of-line


insert-datestamp() { LBUFFER+=${(%):-'%D{%d-%m-%Y }'}; }
zle -N insert-datestamp
#k# Insert a timestamp on the command line (yyyy-mm-dd)
bindkey '^Ed' insert-datestamp

insert-timestamp() { LBUFFER+=${(%):-'%D{%H:%M }'}; }
zle -N insert-timestamp
#k# Insert a timestamp on the command line (yyyy-mm-dd)
bindkey '^Et' insert-timestamp


zle -N mkdir-cd

### jump behind the first word on the cmdline.
### useful to add options.
function jump_after_first_word() {
    local words
    words=(${(z)BUFFER})

    if (( ${#words} <= 1 )) ; then
        CURSOR=${#BUFFER}
    else
        CURSOR=${#${words[1]}}
    fi
}
zle -N jump_after_first_word
#k# jump to after first word (for adding options)
bindkey '^J1' jump_after_first_word


chpwd() {
    local -ax my_stack
    my_stack=( ${PWD} ${dirstack} )
    if is42 ; then
        builtin print -l ${(u)my_stack} >! ${DIRSTACKFILE}
    else
        uprint my_stack >! ${DIRSTACKFILE}
    fi
}

# }}}



# utility functions {{{
# this function checks if a command exists and returns either true
# or false. This avoids using 'which' and 'whence', which will
# avoid problems with aliases for which on certain weird systems. :-)
# Usage: check_com [-c|-g] word
#   -c  only checks for external commands
#   -g  does the usual tests and also checks for global aliases
check_com() {
    emulate -L zsh
    local -i comonly gatoo

    if [[ $1 == '-c' ]] ; then
        (( comonly = 1 ))
        shift
    elif [[ $1 == '-g' ]] ; then
        (( gatoo = 1 ))
    else
        (( comonly = 0 ))
        (( gatoo = 0 ))
    fi

    if (( ${#argv} != 1 )) ; then
        printf 'usage: check_com [-c] <command>\n' >&2
        return 1
    fi

    if (( comonly > 0 )) ; then
        [[ -n ${commands[$1]}  ]] && return 0
        return 1
    fi

    if   [[ -n ${commands[$1]}    ]] \
      || [[ -n ${functions[$1]}   ]] \
      || [[ -n ${aliases[$1]}     ]] \
      || [[ -n ${reswords[(r)$1]} ]] ; then

        return 0
    fi

    if (( gatoo > 0 )) && [[ -n ${galiases[$1]} ]] ; then
        return 0
    fi

    return 1
}

backconf() {
    if [ "$1" != "" ]
    then
		if [ -d $1 ]
		then
			confdir="$1"
		else
			echo 'Usage: backconf [config directory]'
			return 0
		fi
	else
		confdir=~/config
    fi
	cd $confdir
	cp -r ~/sh_plugins $confdir/sh_plugins \
		&& cp ~/.zshrc $confdir/zshrc \
		&& cp ~/.vimrc $confdir/vimrc \
		&& cp -R ~/.vim  $confdir/vim \
		&& git add -A \
		&& git commit -am "autocommit `date`" \
		&& git push origin master
	cd -
}

restconf() {
    if [ "$1" != "" ]
    then
		if [ -d $1 ]
		then
			confdir="$1"
		else
			echo 'Usage: restconf [config directory]'
			return 0
		fi
	else
		confdir=~/config
    fi
	cd $confdir
		git pull origin master \
		&& cp -r $confdir/sh_plugins ~/sh_plugins \
		&& cp $confdir/zshrc ~/.zshrc \
		&& cp $confdir/vimrc ~/.vimrc \
		&& cp -R  $confdir/vim ~/.vim \
	cd -
}

## Usage: simple-extract <file>
## Using option -d deletes the original archive file.
##f5# Smart archive extractor
simple-extract() {
    if [ "$1" = "-h" ]
     then
		echo "Usage: simple-extract <file>
Using option -d deletes the original archive file."
        return 0
    fi
    emulate -L zsh
    setopt extended_glob noclobber
    local DELETE_ORIGINAL DECOMP_CMD USES_STDIN USES_STDOUT GZTARGET WGET_CMD
    local RC=0
    zparseopts -D -E "d=DELETE_ORIGINAL"
    for ARCHIVE in "${@}"; do
        case $ARCHIVE in
            *.(tar.bz2|tbz2|tbz))
                DECOMP_CMD="tar -xvjf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *.(tar.gz|tgz))
                DECOMP_CMD="tar -xvzf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *.(tar.xz|txz|tar.lzma))
                DECOMP_CMD="tar -xvJf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *.tar)
                DECOMP_CMD="tar -xvf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *.rar)
                DECOMP_CMD="unrar x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *.lzh)
                DECOMP_CMD="lha x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *.7z)
                DECOMP_CMD="7z x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *.(zip|jar))
                DECOMP_CMD="unzip"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *.deb)
                DECOMP_CMD="ar -x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *.bz2)
                DECOMP_CMD="bzip2 -d -c -"
                USES_STDIN=true
                USES_STDOUT=true
                ;;
            *.(gz|Z))
                DECOMP_CMD="gzip -d -c -"
                USES_STDIN=true
                USES_STDOUT=true
                ;;
            *.(xz|lzma))
                DECOMP_CMD="xz -d -c -"
                USES_STDIN=true
                USES_STDOUT=true
                ;;
            *)
                print "ERROR: '$ARCHIVE' has unrecognized archive type." >&2
                RC=$((RC+1))
                continue
                ;;
        esac

        if ! check_com ${DECOMP_CMD[(w)1]}; then
            echo "ERROR: ${DECOMP_CMD[(w)1]} not installed." >&2
            RC=$((RC+2))
            continue
        fi

        GZTARGET="${ARCHIVE:t:r}"
        if [[ -f $ARCHIVE ]] ; then

            print "Extracting '$ARCHIVE' ..."
            if $USES_STDIN; then
                if $USES_STDOUT; then
                    ${=DECOMP_CMD} < "$ARCHIVE" > $GZTARGET
                else
                    ${=DECOMP_CMD} < "$ARCHIVE"
                fi
            else
                if $USES_STDOUT; then
                    ${=DECOMP_CMD} "$ARCHIVE" > $GZTARGET
                else
                    ${=DECOMP_CMD} "$ARCHIVE"
                fi
            fi
            [[ $? -eq 0 && -n "$DELETE_ORIGINAL" ]] && rm -f "$ARCHIVE"

        elif [[ "$ARCHIVE" == (#s)(https|http|ftp)://* ]] ; then
            if check_com curl; then
                WGET_CMD="curl -L -k -s -o -"
            elif check_com wget; then
                WGET_CMD="wget -q -O - --no-check-certificate"
            else
                print "ERROR: neither wget nor curl is installed" >&2
                RC=$((RC+4))
                continue
            fi
            print "Downloading and Extracting '$ARCHIVE' ..."
            if $USES_STDIN; then
                if $USES_STDOUT; then
                    ${=WGET_CMD} "$ARCHIVE" | ${=DECOMP_CMD} > $GZTARGET
                    RC=$((RC+$?))
                else
                    ${=WGET_CMD} "$ARCHIVE" | ${=DECOMP_CMD}
                    RC=$((RC+$?))
                fi
            else
                if $USES_STDOUT; then
                    ${=DECOMP_CMD} =(${=WGET_CMD} "$ARCHIVE") > $GZTARGET
                else
                    ${=DECOMP_CMD} =(${=WGET_CMD} "$ARCHIVE")
                fi
            fi

        else
            print "ERROR: '$ARCHIVE' is neither a valid file nor a supported URI." >&2
            RC=$((RC+8))
        fi
    done
    return $RC
}

#f1# Provides useful information on globbing
H-Glob() {
    echo -e "
    /      directories
    .      plain files
    @      symbolic links
    =      sockets
    p      named pipes (FIFOs)
    *      executable plain files (0100)
    %      device files (character or block special)
    %b     block special files
    %c     character special files
    r      owner-readable files (0400)
    w      owner-writable files (0200)
    x      owner-executable files (0100)
    A      group-readable files (0040)
    I      group-writable files (0020)
    E      group-executable files (0010)
    R      world-readable files (0004)
    W      world-writable files (0002)
    X      world-executable files (0001)
    s      setuid files (04000)
    S      setgid files (02000)
    t      files with the sticky bit (01000)

  print *(m-1)          # Files modified up to a day ago
  print *(a1)           # Files accessed a day ago
  print *(@)            # Just symlinks
  print *(Lk+50)        # Files bigger than 50 kilobytes
  print *(Lk-50)        # Files smaller than 50 kilobytes
  print **/*.c          # All *.c files recursively starting in \$PWD
  print **/*.c~file.c   # Same as above, but excluding 'file.c'
  print (foo|bar).*     # Files starting with 'foo' or 'bar'
  print *~*.*           # All Files that do not contain a dot
  chmod 644 *(.^x)      # make all plain non-executable files publically readable
  print -l *(.c|.h)     # Lists *.c and *.h
  print **/*(g:users:)  # Recursively match all files that are owned by group 'users'
  echo /proc/*/cwd(:h:t:s/self//) # Analogous to >ps ax | awk '{print $1}'<"
}

mkdir-cd() {
	mkdir -p $1
	cd $1
}
# -------------------------------------------------------------------
# display a neatly formatted path
# -------------------------------------------------------------------
path() {
  echo $PATH | tr ":" "\n" | \
    awk "{ sub(\"/usr\",   \"$fg_no_bold[green]/usr$reset_color\"); \
           sub(\"/bin\",   \"$fg_no_bold[blue]/bin$reset_color\"); \
           sub(\"/opt\",   \"$fg_no_bold[cyan]/opt$reset_color\"); \
           sub(\"/sbin\",  \"$fg_no_bold[magenta]/sbin$reset_color\"); \
           sub(\"/local\", \"$fg_no_bold[yellow]/local$reset_color\"); \
           print }"
}
# -------------------------------------------------------------------
# shell function to define words
# http://vikros.tumblr.com/post/23750050330/cute-little-function-time
# -------------------------------------------------------------------
givedef() {
  if [[ $# -ge 2 ]] then
    echo "givedef: too many arguments" >&2
    return 1
  else
    curl "dict://dict.org/d:$1"
  fi
}

# -------------------------------------------------------------------
# shell function to show libc header
# -------------------------------------------------------------------
libc() {
  if [[ $# -ne 1 ]] then
    echo "libc: usage: libc [name pattern]" >&2
    return 1
  else
	find /usr/include -name "$1"
  fi
}



##----------------alias------------
alias contrast='xcalib -a -co'
alias scrrst='xcalib -c'
alias setlumi='xrandr --output "eDP1" --brightness'
alias mkdir="nocorrect mkdir"
alias help-zshglob=H-Glob
alias sterm="terminator -m --layout=dfllay"
# Les alias marchent comme sous bash
alias src='source ~/.zshrc'
alias jobs='jobs -l'
alias nrma="norminette ***/*.[hc]"
alias nrm="norminette"
alias nrms="norminette ***/*.[ch] G Error -B 1"
alias re='make re'
alias red='make re DEBUG=1'
alias maked='make DEBUG=1'
alias fclean='make fclean'
alias clean='make clean'
alias tf='tail -F'
alias mk='mkdir-cd'
alias ip="ifconfig | grep 'inet'"
alias grn="grep -Rn"
alias aspi='wget -rkpE'
alias siz='du -sh'
alias pt='peer_tools'

# -------------------------------------------------------------------
# Web
# -------------------------------------------------------------------
alias ions='ionic serve -g'
alias pmk='pm2 kill'
alias pml='pm2 log'
alias npmrs='npm run serv:dev'
alias pmm='pm2 monit'

# -------------------------------------------------------------------
# Git
# -------------------------------------------------------------------
alias gc='git clone'
alias ga='git add'
alias gco='git commit -m'
alias gca='git commit -am'
alias gp='git push'
alias gpl='git pull'
alias glog='git log'
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gs='git status'
alias gd='git diff'
alias gm='git merge'
alias gmt='git mergetool'
alias gb='git branch'
alias gck='git checkout'
alias gckb='git checkout -b'
alias gra='git remote add'
alias grr='git remote rm'
# alias gta='git tag -a -m'
alias gf='git reflog'
alias gv='git log --pretty=format:'%s' | cut -d " " -f 1 | sort | uniq -c | sort -nr'
# leverage aliases from ~/.gitconfig
alias gh='git hist'
alias gt="git log --since=midnight --author='$(git config user.name)' --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gy="git log --since=1.week --author='$(git config user.name)' --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
# curiosities 
# gsh shows the number of commits for the current repos for all developers
alias gsh="git shortlog | grep -E '^[ ]+\w+' | wc -l"
# gu shows a list of all developers and the number of commits they've made
alias gu="git shortlog | grep -E '^[^ ]'"

# Taf
alias taf='. taf'
alias staf='taf -s'
alias ltaf='taf -l'
alias rtaf='taf -r'

# Ls
alias l='ls'
alias ls='ls'
alias la='ls -a'
alias lla='ls -la'
alias ll='ls -l'
alias lr='ls -R'
alias llr='ls -lR'
alias lar='ls -aR'
alias llar='ls -laR'

# Vim
alias vimp="vim -p"
# Cp mv
alias cpr='cp -R'
alias mvr='mv -R'
alias rmf='rm -f'
alias rmrf='rm -rf'

# Brew
alias search="brew search"
alias show="brew list"
alias install='brew install'
alias update='brew update'
alias upgrade='brew upgrade'

# Local Func
alias sX="simple-extract"

# --// Pipes //--
alias -g G='| grep'
alias -g GI='| grep -i'
alias -g GR='| grep -v'
alias -g GRI='| grep -vi'
alias -g CE='| cat -e'
alias -g C='| cat'
alias -g S='| sort'
alias -g L='| less'
alias -g M='| more'
alias -g N1='1>/dev/null'
alias -g N2='2>/dev/null'
alias -g Na='&>/dev/null'
alias -g T='| tail'
alias -g H='| head'
alias -g W='| wc'

# --//Suffixes\\--
alias -s c=$EDITOR
alias -s py=$EDITOR
alias -s rb=$EDITOR
alias -s cpp=$EDITOR
alias -s hpp=$EDITOR
alias -s h=$EDITOR
alias -s php=$EDITOR

# marre de se faire corriger par zsh ;)
alias sl='ls'
# Alias df -h
alias df='df -h'
# on ne peut pas utiliser GREP_OPTIONS pour rajouter la couleur car cela 
# casse /usr/bin/grep sur les freebsd
#export GREP_OPTIONS="--color=auto"
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'



# Les trois lignes suivantes changent le comportement de rm, cp et mv de
# manière à ce que ces programmes demandent confirmation avant d'effacer un
# fichier.
alias rm="nocorrect rm -i"
alias mv="nocorrect mv -i"
alias cp="nocorrect cp -i"


# -------------------------------------------------------------------
# Source: http://aur.archlinux.org/packages/lolbash/lolbash/lolbash.sh
# -------------------------------------------------------------------
alias wtf='dmesg'
alias onoz='cat /var/log/errors.log'
alias rtfm='man'

##----------------setopt-----------
setopt no_beep # don't beep on error
setopt hist_verify # don't beep on error

## History options
setopt incappendhistory \
	extendedhistory \
	histfindnodups \
	histreduceblanks \
	histignorealldups \
	histsavenodups
# Correction des commandes
setopt correctall
setopt extendedglob
unsetopt list_ambigous

## Login Pic
startanim

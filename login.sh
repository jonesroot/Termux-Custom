#!/usr/bin/bash
BOLD=$(tput bold)
RESET=$(tput sgr0)
RED=$(tput setaf 196)
GREEN=$(tput setaf 24)
YELLOW=$(tput setaf 226)
BLUE=$(tput setaf 21)
CYAN=$(tput setaf 51)
WHITE=$(tput setaf 195)

bash $HOME/../usr/etc/banner
echo

read -p "${BOLD}${CYAN}Enter ${GREEN}Username ${CYAN}for ${GREEN}Login:${RESET} " username                
read -p "${BOLD}${CYAN}Enter ${GREEN}Password ${CYAN}for ${GREEN}Login:${RESET} " password 
read -p "${BOLD}${CYAN}Your ${GREEN}Shell ${CYAN}Name: ${RESET} " names

cd $HOME/..usr/etc

if [ -f bash.bashrc ]; then
    mv bash.bashrc bash.bashrc.bak
fi
if [ -f motd.sh ]; then
    mv motd.sh motd.sh.bak
fi

cat <<LOGIN>bash.bashrc                            

trap "" SIGINT
shopt -s autocd
shopt -s cdspell
shopt -s checkhash
shopt -s checkwinsize
shopt -s compat31
shopt -s compat32
shopt -s compat40
shopt -s compat41
shopt -s no_empty_cmd_completion
shopt -s histverify
shopt -s histappend
shopt -s dirspell
shopt -s direxpand
shopt -s compat43
shopt -s compat32
shopt -s lithist
shopt -s extglob
shopt -s nullglob
shopt -s globstar
shopt -s extdebug
shopt -s histappend
shopt -s cmdhist
shopt -s checkwinsize

set -o xtrace
set -o verbose
set -o errexit
set -o errtrace
set -o functrace
set -o pipefail

e="nano"
USER_NAME="Lucifer"
BOLD=$(tput bold)
RESET=$(tput sgr0)
RED=$(tput setaf 196)
GREEN=$(tput setaf 24)
YELLOW=$(tput setaf 226)
BLUE=$(tput setaf 21)
CYAN=$(tput setaf 51)
WHITE=$(tput setaf 195)
export USER=$USER_NAME
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=2000
PS1='${BOLD}${BLUE}╭──[ ${GREEN}${USER}@${CYAN}$(basename $PWD) ]\n${BLUE}╰──>${RESET} '

if [ -x /data/data/com.termux/files/usr/libexec/termux/command-not-found ]; then
    command_not_found_handle() {
        /data/data/com.termux/files/usr/libexec/termux/command-not-found "$1"
    }
fi

[ -r /data/data/com.termux/files/usr/share/bash-completion/bash_completion ] &&
    . /data/data/com.termux/files/usr/share/bash-completion/bash_completion
echo -e "${BOLD}${GREEN}      

┌──────────────────────────┐
│ ____ ____ ____ ____ ____ │
│||L |||O |||G |||I |||N ||│
│||__|||__|||__|||__|||__||│
│|/__\|/__\|/__\|/__\|/__\|│
└──────────────────────────┘

${CYAN}           ────────────────────────────
${YELLOW}               Login To ${GREEN}Continue ..
${CYAN}           ────────────────────────────


${RESET}"
echo
read -p $'       \e${BOLD}${YELLOW}INPUT ${GREEN}USERNAME FOR LOGIN:${RESET} ' user
read -s -p $'       \e${BOLD}${YELLOW}INPUT ${GREEN}PASSWORD FOR LOGIN:${RESET} ' pass                                                
if [[ \$pass == $password && \$user == $username ]]; then
    python3 ~/Termux-Custom/songs/sound_effect.py 1
    sleep 3
    clear
    cd $HOME 
echo -e "${BOLD}${CYAN}


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::_|        _|    _|    _|_|_|  _|_|_|  _|_|_|_|  _|_|_|_|  _|_|_|    ::
::_|        _|    _|  _|          _|    _|        _|        _|    _|  ::
::_|        _|    _|  _|          _|    _|_|_|    _|_|_|    _|_|_|    ::
::_|        _|    _|  _|          _|    _|        _|        _|    _|  ::
::_|_|_|_|    _|_|      _|_|_|  _|_|_|  _|        _|_|_|_|  _|    _|  ::
::                                                                    ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::                                                              

"
echo -e  "     \e[1m\e[32m▂▃▄▅▆▇▓▒░ \033[1mCoded By \e[33mLucifer \e[1m\e[32m░▒▓▇▆▅▄▃▂"
cd $HOME
echo -e "   \033[1m\033[33m]\033[31m──────────────────────────────────────\033[33m["
cd $HOME
cd Termux-Custom
cd
else
echo ""
echo -e "\e[1;31m  You Entered wrong Details! 
\e[0m"
sleep 1
cmatrix -L
fi
trap 2
LOGIN
echo 
echo
echo 
echo -e "\033[1m\e[1;32m Your Termux is \033[33mReady \n
       So please \033[31mExit \033[37mand \033[32mLogin.\e[0m"
echo
echo
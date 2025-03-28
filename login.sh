#!/bin/bash

BOLD=$(tput bold)
RESET=$(tput sgr0)
RED=$(tput setaf 196)
GREEN=$(tput setaf 24)
YELLOW=$(tput setaf 226)
BLUE=$(tput setaf 21)
CYAN=$(tput setaf 51)
WHITE=$(tput setaf 195)

bash "$HOME/../usr/etc/banner"
echo

read -rp "${BOLD}${CYAN}Enter ${GREEN}Username ${CYAN}for ${GREEN}Login:${RESET} " username                
read -rp "${BOLD}${CYAN}Enter ${GREEN}Password ${CYAN}for ${GREEN}Login:${RESET} " password 
read -rp "${BOLD}${CYAN}Your ${GREEN}Shell ${CYAN}Name: ${RESET} " names

cd "$HOME/../usr/etc" || exit

[ -f bash.bashrc ] && mv bash.bashrc bash.bashrc.bak
[ -f motd.sh ] && mv motd.sh motd.sh.bak

cat <<LOGIN > bash.bashrc
trap "" SIGINT
shopt -s autocd cdspell checkhash checkwinsize compat31 compat32 compat40 compat41 no_empty_cmd_completion histverify histappend dirspell direxpand compat43 lithist extglob nullglob globstar extdebug cmdhist
set -o xtrace -o verbose -o errexit -o errtrace -o functrace -o pipefail

export USER="Lucifer"
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=2000
PS1='${BOLD}${BLUE}\u@\h:${GREEN}\w${RESET}$ '

if [ -x /data/data/com.termux/files/usr/libexec/termux/command-not-found ]; then
    command_not_found_handle() {
        /data/data/com.termux/files/usr/libexec/termux/command-not-found "$1"
    }
fi

[ -r /data/data/com.termux/files/usr/share/bash-completion/bash_completion ] && \
    . /data/data/com.termux/files/usr/share/bash-completion/bash_completion

echo -e "${BOLD}${GREEN}\n
┌──────────────────────────┐
│ ____ ____ ____ ____ ____ │
│||L |||O |||G |||I |||N ||│
│||__|||__|||__|||__|||__||│
│|/__\|/__\|/__\|/__\|/__\|│
└──────────────────────────┘\n"

echo
read -rp "${BOLD}${YELLOW}INPUT ${GREEN}USERNAME FOR LOGIN:${RESET} " user
read -rsp "${BOLD}${YELLOW}INPUT ${GREEN}PASSWORD FOR LOGIN:${RESET} " pass

echo
if [[ "\$pass" == "$password" && "\$user" == "$username" ]]; then
    python3 ~/Termux-Custom/songs/sound_effect.py 1
    sleep 3
    clear
    echo -e "${BOLD}${CYAN}\nLogin successful!\n"
else
    echo -e "${RED}You Entered Wrong Details!${RESET}"
    sleep 1
    cmatrix -L
fi
LOGIN

echo -e "${BOLD}${GREEN}Your Termux is Ready. Please exit and login again.${RESET}\n"

#!/usr/bin/bash 

bash banner.sh
echo

read -p $'\e[1;32m  Enter \033[33mUsername \033[37mfor \033[32mLogin:\e[0m ' username                
read -p $'\e[1;32m  Enter \033[33mPassword \033[37mfor \033[32mLogin:\e[0m ' password 
echo
echo
read -p $'\033[1m\033[32m  Your \033[0mShell \033[38;5;209mName\033[31m: \033[33m\033[1m ' names
cd                                                   
cd ..                                               
cd usr/etc                                       
rm motd                                           
rm bash.bashrc                                       
cat <<LOGIN>bash.bashrc                            

trap '' 2                                          
echo -e "\e[1;32m      

┌──────────────────────────┐
│ ____ ____ ____ ____ ____ │
│||L |||O |||G |||I |||N ||│
│||__|||__|||__|||__|||__||│
│|/__\|/__\|/__\|/__\|/__\|│
└──────────────────────────┘

\033[31m           ────────────────────────────
\033[33m               Login To \033[32mContinue
\033[31m           ────────────────────────────


\e[0m"
echo
read -p $'       \e[33m\033[1m\033[33m[\033[31m+\033[33m] \033[37mINPUT \033[33mUSERNAME FOR LOGIN:\033[32m ' user
read -s -p $'       \e[32m\033[1m\033[33m[\033[31m+\033[33m] \033[37mINPUT \033[33mPASSWORD FOR LOGIN:\033[33m ' pass                                                
if [[ \$pass == $password && \$user == $username ]]; then
sleep 3
clear
cd $HOME
cd Termux-Custom
cd Song
python sound_effect.py
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
echo 
PS1='${BOLD}${BLUE}╭──[ ${GREEN}${USER}@${CYAN}$(basename "$PWD") ]\n${BLUE}╰──>${RESET} '
<< comment
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
comment
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
#!/usr/bin/bash

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)

type_effect() {
    text="$1"
    delay=0.02
    for i in $(seq 0 ${#text}); do
        printf "${text:$i:1}"
        sleep "$delay"
    done
    printf "\n"
}

loading_animation() {
    clear
    echo -e "${green}Initializing script...${reset}\n"

    progress=("█1%" "██4%" "███8%" "████10%" "█████12%" "██████15%" "███████19%" 
              "████████28%" "██████████30%" "████████████40%" "█████████████50%" 
              "████████████████60%" "███████████████████88%" "██████████████████████████████100%")

    for i in "${progress[@]}"; do
        clear
        echo -e "${cyan}Progress: ${yellow}/$i.../${reset}"
        sleep 0.1
    done
    
    clear
}

banner_text="
███╗   ███╗███████╗███╗   ██╗██╗   ██╗
████╗ ████║██╔════╝████╗  ██║██║   ██║
██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝
"

loading_animation
clear
echo -e "${red}$(type_effect 'Welcome to')"
echo -e "${cyan}$banner_text${reset}\n"
echo -e "${green}$(type_effect 'Termux - Bash 5.2.37 Ready!')${reset}"
echo -e "${yellow}$(type_effect 'Enjoy Hacking!')${reset}\n"
echo -e "${magenta}$(date)${reset}\n"
echo -e "${blue}Author  : ${white}Lucifer"
echo -e "${blue}Country : ${white}Indonesia"
echo -e "${blue}City    : ${white}Jakarta${reset}\n"

echo -e "${red}Do not forget your username & password!${reset}\n"

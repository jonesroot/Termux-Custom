#!/bin/bash

# Warna
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)

# Banner ASCII Keren
banner_text="
███╗   ███╗███████╗███╗   ██╗██╗   ██╗
████╗ ████║██╔════╝████╗  ██║██║   ██║
██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝
"

# Fungsi untuk animasi efek ketikan
type_effect() {
    text="$1"
    delay=0.02  # Kecepatan animasi
    for i in $(seq 0 ${#text}); do
        printf "${text:$i:1}"
        sleep "$delay"
    done
}

# Bersihkan layar
clear

# Menampilkan banner dengan warna-warni dan animasi
echo -e "${red}$(type_effect 'Welcome to')"
echo -e "${cyan}$banner_text${reset}"
echo -e "${green}$(type_effect 'Termux - Bash 5.2.37 Ready!')${reset}"
echo -e "${yellow}$(type_effect 'Enjoy Hacking!')${reset}\n"

# Tambahan: Menampilkan waktu sistem
echo -e "${magenta}$(date)${reset}"

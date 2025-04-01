#!/usr/bin/env bash

# Warna ANSI
RESET="\e[0m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"

# Sembunyikan dan tampilkan kursor
HIDE_CURSOR="$(tput civis)"
SHOW_CURSOR="$(tput cnorm)"

# Fungsi Progress Bar
progress_bar() {
    local pid=$1 message=$2
    local spin='|/-\\' i=0
    echo -ne "$HIDE_CURSOR"
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r%s [%c]" "$message" "${spin:i++%4:1}"
        sleep 0.1
    done
    printf "\r%s ${GREEN}[✓]${RESET}\n" "$message"
    echo -ne "$SHOW_CURSOR"
}

# Periksa apakah paket sudah terinstal
is_installed() {
    dpkg -l | grep -q "^ii  $1 "
}

is_python_installed() {
    pip3 show "$1" &>/dev/null
}

# Instalasi Dependensi
install_dependencies() {
    local TEMP_DIR="$(mktemp)"

    echo -e "${YELLOW}\nMemperbarui daftar paket ..${RESET}"
    apt update -y &>${TEMP_DIR} & progress_bar $!
    echo -e "${GREEN}\nMenginstal dependensi ..${RESET}"

    while IFS= read -r package; do
        if ! is_installed "$package"; then
            echo -e "${HIDE_CURSOR}"
            echo -e "${YELLOW}Menginstal: ${package}${RESET}"
            pkg install -y "$package" &>"$TEMP_DIR" & progress_bar $!
            clear
        fi
    echo -e "${SHOW_CURSOR}${RESET}"
    done < "$HOME/Termux-Custom/requirements/bash.txt"

    while IFS= read -r package; do
        if ! is_python_installed "$package"; then
            echo -e "${HIDE_CURSOR}"
            echo -e "${YELLOW}Menginstal: $package (Python)${RESET}"
            pip3 install "$package" &>"$TEMP_DIR" & progress_bar $!
            clear
        fi
    echo -e "${SHOW_CURSOR}${RESET}"
    done < "$HOME/Termux-Custom/requirements/python.txt"
}

# Setup File dan Izin Eksekusi
setup_files() {
    echo -e "${GREEN}\nMenyiapkan file dan izin...${RESET}"
    for file in "$HOME/Termux-Custom/"*.sh; do
        [ -f "$file" ] || continue
        echo -e "${HIDE_CURSOR}"
        filebasename="$(basename $file)"
        filename="${filename%.*}"
        echo -e "${YELLOW}Menyalin: ${filebasename} to ${PREFIX}/bin/${filename}${RESET}"
        cp "$file" "$PREFIX/bin/$filename"
        chmod +x "$PREFIX/bin/$filename"
    echo -e "${SHOW_CURSOR}${RESET}"
    done
    echo -e "${GREEN}Semua skrip telah disalin dan dibuat dapat dieksekusi.${RESET}"
}

clear
echo -e "${GREEN}──────────────────────────────────────────────${RESET}"
echo -e "${YELLOW}Memulai instalasi dependensi, harap tunggu...${RESET}"
sleep 2
clear
install_dependencies
sleep 2
clear
setup_files
sleep 2
clear
echo -e "${RED}INSTALASI SELESAI ${GREEN}[✓]${RESET}"
echo -e "${YELLOW}──────────────────────────────────────────────${RESET}"
sleep 2
clear

termux-setup-storage

read -p "Apakah Anda ingin memperbarui repositori sekarang? (y/n): " choice
[[ "$choice" == "y" ]] && apt upgrade -y

bash login.sh

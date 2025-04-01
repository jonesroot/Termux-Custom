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
    echo -e "${YELLOW}\nMemperbarui daftar paket...${RESET}"
    apt update -y &>/dev/null & progress_bar $!
    echo -e "${GREEN}\nMenginstal dependensi...${RESET}"
    TEMP_DIR="$(mktemp)"

    while IFS= read -r package; do
        if ! is_installed "$package"; then
            echo -e "${YELLOW}Menginstal: $package${RESET}"
            pkg install -y "$package" &>"$TEMP_DIR" & progress_bar $!
        fi
    done < "$HOME/Termux-Custom/requirements/bash.txt"

    while IFS= read -r package; do
        if ! is_python_installed "$package"; then
            echo -e "${YELLOW}Menginstal: $package (Python)${RESET}"
            pip3 install "$package" &>"$TEMP_DIR" & progress_bar $!
        fi
    done < "$HOME/Termux-Custom/requirements/python.txt"
}

# Setup File dan Izin Eksekusi
setup_files() {
    echo -e "${GREEN}\nMenyiapkan file dan izin...${RESET}"
    for file in "$HOME/Termux-Custom/"*.sh; do
        [ -f "$file" ] || continue
        filename="$(basename $file .sh)"
        echo -e "${YELLOW}Menyalin: $filename${RESET}"
        cp "$file" "$PREFIX/bin/$filename"
        chmod +x "$PREFIX/bin/$filename"
    done
    echo -e "${GREEN}Semua skrip telah disalin dan dibuat dapat dieksekusi.${RESET}"
}

clear
echo -e "${GREEN}──────────────────────────────────────────────${RESET}"
echo -e "${YELLOW}Memulai instalasi dependensi, harap tunggu...${RESET}"
install_dependencies
setup_files
echo -e "${RED}INSTALASI SELESAI ${GREEN}[✓]${RESET}"
echo -e "${YELLOW}──────────────────────────────────────────────${RESET}"

termux-setup-storage

read -p "Apakah Anda ingin memperbarui repositori sekarang? (y/n): " choice
[[ "$choice" == "y" ]] && apt upgrade -y

bash login.sh

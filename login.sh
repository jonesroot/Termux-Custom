#!/bin/bash

# Warna
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

# Lokasi penyimpanan data login
LOGIN_FILE="$HOME/.login_data"

# Fungsi untuk mengetik perlahan (efek animasi)
type_effect() {
    text="$1"
    delay=0.05
    for i in $(seq 0 ${#text}); do
        printf "${text:$i:1}"
        sleep "$delay"
    done
}

# Fungsi untuk membuat akun pertama kali
create_account() {
    clear
    echo -e "${yellow}$(type_effect 'No login data found. Please create a new account.')${reset}"
    echo ""
    
    # Meminta input username
    while true; do
        echo -ne "${green}Enter a new username: ${reset}"
        read -r new_username
        [[ -n "$new_username" ]] && break
        echo -e "${red}Username cannot be empty!${reset}"
    done

    # Meminta input password (hidden)
    while true; do
        echo -ne "${green}Enter a new password: ${reset}"
        read -s new_password
        echo ""
        [[ -n "$new_password" ]] && break
        echo -e "${red}Password cannot be empty!${reset}"
    done

    # Simpan username dan password (hashed untuk keamanan)
    echo "$new_username:$(echo "$new_password" | sha256sum | awk '{print $1}')" > "$LOGIN_FILE"
    echo -e "${blue}$(type_effect 'Account created successfully!')${reset}"
    sleep 2
}

# Jika tidak ada akun, buat akun baru
if [[ ! -f "$LOGIN_FILE" ]]; then
    create_account
fi

# Login loop
while true; do
    clear
    echo -e "${yellow}$(type_effect 'Welcome to Termux Secure Login!')${reset}"
    echo -e "${cyan}$(type_effect 'Please enter your credentials.')${reset}"
    echo ""

    # Input username
    echo -ne "${green}Username: ${reset}"
    read -r input_username

    # Input password (hidden)
    echo -ne "${green}Password: ${reset}"
    read -s input_password
    echo ""

    # Verifikasi login
    stored_username=$(cut -d':' -f1 "$LOGIN_FILE")
    stored_password=$(cut -d':' -f2 "$LOGIN_FILE")
    input_password_hash=$(echo "$input_password" | sha256sum | awk '{print $1}')

    if [[ "$input_username" == "$stored_username" && "$input_password_hash" == "$stored_password" ]]; then
        echo -e "${blue}$(type_effect 'Login successful!')${reset}"
        sleep 1
        clear
        break
    else
        echo -e "${red}Login failed! Please try again.${reset}"
        sleep 2
    fi
done

# Menampilkan banner setelah login sukses
echo -e "${cyan}"
cat << "EOF"
████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗
╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║
   ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║
   ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║
   ██║   ███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝
   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ 
EOF
echo -e "${reset}"

# Menampilkan waktu sistem
echo -e "${green}$(date)${reset}"

#!/usr/bin/bash

# Define text colors
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

LOGIN_FILE="$HOME/.login_data"
MAX_ATTEMPTS=3
BASHRC_PATH="$PREFIX/etc/bash.bashrc"
BASHRC_BACKUP="$PREFIX/etc/bash.bashrc.bak"

# Function for typing effect
type_effect() {
    local text="$1"
    local delay=0.05
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
    printf "\n"
}

# Function to create a new user account
create_account() {
    clear
    echo -e "${yellow}$(type_effect 'No login data found. Please create a new account.')${reset}\n"

    while true; do
        echo -ne "${green}Enter a new username: ${reset}"
        read -r new_username
        [[ -n "$new_username" ]] && break
        echo -e "${red}Username cannot be empty!${reset}"
    done

    while true; do
        echo -ne "${green}Enter a new password: ${reset}"
        read -s new_password
        echo ""
        [[ -n "$new_password" ]] && break
        echo -e "${red}Password cannot be empty!${reset}"
    done

    echo "$new_username:$(echo "$new_password" | sha256sum | awk '{print $1}')" > "$LOGIN_FILE"
    echo -e "${blue}$(type_effect 'Account created successfully!')${reset}"
    sleep 2
}

# Check if login file exists
if [[ ! -f "$LOGIN_FILE" ]]; then
    create_account
fi

# Check if `sha256sum` is installed
if ! command -v sha256sum &> /dev/null; then
    echo -e "${red}Error: sha256sum command not found! Please install coreutils.${reset}"
    exit 1
fi

# Backup the original bash.bashrc file
if [[ ! -f "$BASHRC_BACKUP" ]]; then
    cp "$BASHRC_PATH" "$BASHRC_BACKUP"
fi

# Writing new bash.bashrc content
cat <<EOF > "$BASHRC_PATH"
trap '' SIGINT

attempt=0
while (( attempt < MAX_ATTEMPTS )); do
    clear
    echo -e "${yellow}$(type_effect 'Welcome to Termux Secure Login!')${reset}"
    echo -e "${cyan}$(type_effect 'Please enter your credentials.')${reset}\n"

    echo -ne "${green}Username: ${reset}"
    read -r input_username

    echo -ne "${green}Password: ${reset}"
    read -s input_password
    echo ""

    stored_username=\$(cut -d':' -f1 "$LOGIN_FILE")
    stored_password=\$(cut -d':' -f2 "$LOGIN_FILE")
    input_password_hash=\$(echo "\$input_password" | sha256sum | awk '{print \$1}')

    if [[ "\$input_username" == "\$stored_username" && "\$input_password_hash" == "\$stored_password" ]]; then
        echo -e "${blue}$(type_effect 'Login successful!')${reset}"
        sleep 1
        clear
        break
    else
        echo -e "${red}Login failed! Please try again.${reset}"
        (( attempt++ ))
        if (( attempt == MAX_ATTEMPTS )); then
            echo -e "${red}Maximum login attempts reached! Exiting...${reset}"
            exit 1
        fi
        sleep 2
    fi
done

trap - SIGINT
echo -e "${cyan}"
cat << "BANNER"
████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗
╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║
   ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║
   ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║
   ██║   ███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝
   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ 
BANNER
echo -e "${reset}"
echo -e "${green}Login time: \$(date)${reset}"
echo -e "${yellow}Type 'exit' to logout.${reset}"
EOF

# Success message
echo -e "${green}Secure login setup completed! Restart Termux to test it.${reset}"

bash banner.sh
echo

# Prompt for login
read -p $'\e[1;32m  Enter \033[33mUsername \033[37mfor \033[32mLogin:\e[0m ' username                
read -p $'\e[1;32m  Enter \033[33mPassword \033[37mfor \033[32mLogin:\e[0m ' password 
echo
echo

# Verify login
stored_username=$(cut -d':' -f1 "$LOGIN_FILE")
stored_password=$(cut -d':' -f2 "$LOGIN_FILE")
input_password_hash=$(echo "$password" | sha256sum | awk '{print $1}')

if [[ "$username" == "$stored_username" && "$input_password_hash" == "$stored_password" ]]; then
    sleep 3
    clear
    cd "$HOME"
    cd TermuX-Custom/Song
    python sound_effect.py
    clear
    cd "$HOME" 

    echo -e "\033[1m\033[33m

██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ 
██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
███████║███████║██║     █████╔╝ █████╗  ██████╔╝
██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝                                                                    

"
    echo -e  "     \e[1m\e[32m▂▃▄▅▆▇▓▒░ \033[1mCoded By \e[33mLucifer \e[1m\e[32m░▒▓▇▆▅▄▃▂"
else
    echo -e "\e[1;31m  You Entered Wrong Details! \e[0m"
    sleep 1
    cmatrix -L
fi

trap 2
echo
echo -e "\033[1m\e[1;32m Your Termux is \033[33mReady \nSo please \033[31mExit \033[37mand \033[32mLogin.\e[0m"

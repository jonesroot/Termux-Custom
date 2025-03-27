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

# Function to check and install packages
install_package() {
    package=$1
    if ! pkg list-installed | grep -q "^$package"; then
        echo -e "${yellow}Installing package: $package${reset}"
        pkg install -y "$package"
    else
        echo -e "${green}Package $package is already installed. Skipping...${reset}"
    fi
}

# Function to check and install Python dependencies
install_python_package() {
    package=$1
    if ! pip3 show "$package" > /dev/null 2>&1; then
        echo -e "${yellow}Installing Python package: $package${reset}"
        pip3 install "$package"
    else
        echo -e "${green}Python package $package is already installed. Skipping...${reset}"
    fi
}

type_effect() {
    local text="$1"
    local delay=0.05
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep "$delay"
    done
    printf "\n"
}

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

if [[ ! -f "$LOGIN_FILE" ]]; then
    create_account
fi

if ! command -v sha256sum &> /dev/null; then
    echo -e "${red}Error: sha256sum command not found! Please install coreutils.${reset}"
    exit 1
fi

if [[ ! -f "$BASHRC_BACKUP" ]]; then
    cp "$BASHRC_PATH" "$BASHRC_BACKUP"
fi

# Install required packages (check before installing)
install_package "nano"
install_package "coreutils"

cat <<LOGIN>"$BASHRC_PATH"
trap '' 2

attempt=0
while (( attempt < MAX_ATTEMPTS )); do
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
    comment
    PS1='${BOLD}${BLUE}╭──[ ${GREEN}${USER}@${CYAN}$(basename "$PWD") ]\n${BLUE}╰──>${RESET} '
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
┏┓┏┳┳━┳━━┳━━┳━┳━┓
┃┃┃┃┃┏┻┃┃┫━┳┫┳┫╋┃
┃┗┫┃┃┗┳┃┃┫┏┛┃┻┫┓┫
┗━┻━┻━┻━━┻┛╋┗━┻┻┛
BANNER
echo -e "${reset}"
echo -e "${green}Login time: \$(date)${reset}"
echo -e "${yellow}Type 'exit' to logout.${reset}"
EOF

echo -e "${green}Secure login setup completed! Restart Termux to test it.${reset}"

bash banner.sh
echo

read -p $'\e[1;32m  Enter \033[33mUsername \033[37mfor \033[32mLogin:\e[0m ' username                
read -p $'\e[1;32m  Enter \033[33mPassword \033[37mfor \033[32mLogin:\e[0m ' password 
echo
echo

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

┏┓┏┳┳━┳━━┳━━┳━┳━┓
┃┃┃┃┃┏┻┃┃┫━┳┫┳┫╋┃
┃┗┫┃┃┗┳┃┃┫┏┛┃┻┫┓┫
┗━┻━┻━┻━━┻┛╋┗━┻┻┛                                                             

"
    echo -e  "     \e[1m\e[32m▂▃▄▅▆▇▓▒░ \033[1mCoded By \e[33mᴸᵘᶜⁱᶠᵉʳ \e[1m\e[32m░▒▓▇▆▅▄▃▂"
else
    echo -e "\e[1;31m  You Entered Wrong Details! \e[0m"
    sleep 1
    cmatrix -L
fi

trap 2
echo
echo -e "\033[1m\e[1;32m Your Termux is \033[33mReady \nSo please \033[31mExit \033[37mand \033[32mLogin.\e[0m"

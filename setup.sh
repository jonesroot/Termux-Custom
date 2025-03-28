#!/usr/bin/bash

RED=$(tput )
GREEN="$(printf '\033[32m')"
ORANGE="$(printf '\033[33m')"
BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"
CYAN="$(printf '\033[36m')"
WHITE="$(printf '\033[37m')"
BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"
GREENBG="$(printf '\033[42m')"
ORANGEBG="$(printf '\033[43m')"
BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"
CYANBG="$(printf '\033[46m')"
WHITEBG="$(printf '\033[47m')"
BLACKBG="$(printf '\033[40m')"
DEFAULT_FG="$(printf '\033[39m')"
DEFAULT_BG="$(printf '\033[49m')"
H_CURSOR=$(tput civis)
S_CURSOR=$(tput cnorm)

progress_bar() {
    pid=$1
    message=$2
    TEMP_DIR=$3
    spin="-\|/"
    i=0
    while kill -0 "$pid" 2>$TEMP_DIR; do
        i=$(((i + 1) % 4))
        printf "\r${spin:$i:1} $message"
        sleep 0.1
    done
    printf "\r$message ${GREEN}Done!\n"
    sleep 2
    clear
}

is_installed() {
    package=$1
    if dpkg -l | grep -q "$package"; then
        return 0
    else
        return 1
    fi
}

is_python_installed() {
    package=$1
    if pip3 show "$package" > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

install_dependencies() {
    echo -e "\n\033[33mUpdating package lists...\033[0m"
    echo -e "\n\033[32mInstalling dependencies...\033[0m"
    TEMP_DIR="$(mktemp)"
    
    total_packages=$(wc -l < "$HOME/Termux-Custom/requirements/bash.txt")
    current_package=0
    while IFS= read -r package; do
        ((current_package++))
        if ! is_installed "$package"; then
            echo -e "\033[33mInstalling: $package ($current_package/$total_packages)...\033[0m"
            progress_bar $! "Installing $package" $TEMP_DIR
            pkg install "$package" -y >$TEMP_DIR 2>&1
        fi
    done < "$HOME/Termux-Custom/requirements/bash.txt"

    total_packages=$(wc -l < "$HOME/Termux-Custom/requirements/python.txt")
    current_package=0
    while IFS= read -r package; do
        ((current_package++))
        if ! is_python_installed "$package"; then
            echo -e "\033[33mInstalling: $package ($current_package/$total_packages)...\033[0m"
            progress_bar $! "Installing $package" $TEMP_DIR
            pip3 install "$package" >$TEMP_DIR 2>&1
        fi
    done < "$HOME/Termux-Custom/requirements/python.txt"
}

setup_files() {
    echo -e "\n\033[32mSetting up files and permissions...\033[0m"
    total_files=$(ls -1 "$HOME/Termux-Custom/"*.sh | wc -l)
    current_file=0

    for file in $HOME/Termux-Custom/*.sh; do
        ((current_file++))
        filename=$(basename "$file" .sh)
        echo -e "\033[33mCopying: $filename ($current_file/$total_files)...\033[0m"
        cp "$file" "$PREFIX/etc/$filename"
        chmod +x "$PREFIX/etc/$filename"
    done

    echo -e "\033[32mAll scripts have been copied and made executable.\033[0m"
}

clear
echo -e "\033[32m{──────────────────────────────────────────────}"
echo -e "\033[33mInstalling All Required Packages! Please Wait...\033[0m"
install_dependencies
setup_files

echo -e "\033[31mINSTALLATION COMPLETED \033[32m[\033[36m✓\033[32m]\033[0m"
echo -e "\033[33m]────────────────────────────────────────────["

termux-setup-storage

read -p "Do you want to update the repository now? (y/n): " choice
if [ "$choice" = "y" ]; then
    update_repository
fi

bash login.sh

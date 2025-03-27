#!/usr/bin/bash

update_repository() {
    echo "Updating repository..."
    bash update.sh
    echo "Repository updated successfully!"
}

install_dependencies() {
    echo -e "\033[33mUpdating package lists...\033[0m"
    apt update && apt upgrade -y 
    echo -e "\033[32mInstalling Bash dependencies...\033[0m"
    while IFS= read -r package; do
        echo -e "\033[33mInstalling: $package...\033[0m"
        pkg install "$package" -y >/dev/null 2>&1
    done < $HOME/Termux-Custom/requirements/bash.txt

    echo -e "\033[32mInstalling Python dependencies...\033[0m"
    while IFS= read -r package; do
        echo -e "\033[33mInstalling: $package...\033[0m"
        pip install "$package" >/dev/null 2>&1
    done < $HOME/Termux-Custom/requirements/python.txt
}

setup_files() {
    echo -e "\033[32mSetting up files and permissions...\033[0m"
    for file in $HOME/Termux-Custom/*.sh; do
        filename=$(basename "$file" .sh)
        cp "$file" "$PREFIX/etc/$filename"
        chmod +x "$PREFIX/etc/$filename"
    done
    echo -e "\033[32mAll scripts have been copied and made executable.\033[0m"
}

clear
echo -e "\033[32m{──────────────────────────────────────────────}"
echo -e "\033[33mInstalling All Required Packages! Please Wait..." | pv -qL 10
install_dependencies
setup_files

echo -e "\033[31mINSTALLATION COMPLETED \033[32m[\033[36m✓\033[32m]" | pv -qL 12
echo -e "\033[33m]────────────────────────────────────────────["

termux-setup-storage

read -p "Do you want to update the repository now? (y/n): " choice
if [ "$choice" = "y" ]; then
    update_repository
fi

bash login.sh

#!/usr/bin/bash

# Function to display real-time progress
progress_bar() {
    local progress=0
    local bar_length=40
    local percent=0
    local last_percent=0

    while [ $progress -le $bar_length ]; do
        percent=$((progress * 100 / bar_length))
        if [ "$percent" -gt "$last_percent" ]; then
            # Display progress bar and percentage
            printf "\r[\033[32m%-${bar_length}s\033[0m] %d%%" "${bar:0:$progress}" "$percent"
            last_percent=$percent
        fi
        sleep 0.1
        ((progress++))
    done
    echo ""
}

# Function to simulate real-time process (e.g., installing a package)
real_time_process() {
    local process_duration=$1
    local progress_step=$((process_duration / 100))

    for i in $(seq 1 100); do
        # Simulate some work (e.g., installation, copying files)
        sleep $progress_step
        # Update progress bar
        progress_bar $i
    done
}

# Function to install dependencies
install_dependencies() {
    echo -e "\n\033[33mUpdating package lists...\033[0m"
    real_time_process 5

    echo -e "\n\033[32mInstalling Bash dependencies...\033[0m"
    total_packages=$(wc -l < "$HOME/Termux-Custom/requirements/bash.txt")
    current_package=0

    while IFS= read -r package; do
        ((current_package++))
        echo -e "\033[33mInstalling: $package ($current_package/$total_packages)...\033[0m"
        real_time_process 3
        pkg install "$package" -y >/dev/null 2>&1
    done < "$HOME/Termux-Custom/requirements/bash.txt"

    echo -e "\n\033[32mInstalling Python dependencies...\033[0m"
    total_packages=$(wc -l < "$HOME/Termux-Custom/requirements/python.txt")
    current_package=0

    while IFS= read -r package; do
        ((current_package++))
        echo -e "\033[33mInstalling: $package ($current_package/$total_packages)...\033[0m"
        real_time_process 3
        pip install "$package" >/dev/null 2>&1
    done < "$HOME/Termux-Custom/requirements/python.txt"
}

# Function to copy and set up files
setup_files() {
    echo -e "\n\033[32mSetting up files and permissions...\033[0m"
    total_files=$(ls -1 "$HOME/Termux-Custom/"*.sh | wc -l)
    current_file=0

    for file in $HOME/Termux-Custom/*.sh; do
        ((current_file++))
        filename=$(basename "$file" .sh)
        echo -e "\033[33mCopying: $filename ($current_file/$total_files)...\033[0m"
        real_time_process 2
        cp "$file" "$PREFIX/etc/$filename"
        chmod +x "$PREFIX/etc/$filename"
    done

    echo -e "\033[32mAll scripts have been copied and made executable.\033[0m"
}

# Main script execution
clear
echo -e "\033[32m{──────────────────────────────────────────────}"
echo -e "\033[33mInstalling All Required Packages! Please Wait...\033[0m"
real_time_process 5
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

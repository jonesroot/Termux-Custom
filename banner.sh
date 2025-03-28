#!/usr/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
RESET=$(tput sgr0)

get_center_x() {
    local text="$1"
    local width=$(tput cols)
    local text_length=${#text}
    echo $(((width - text_length) / 2))
}

border() {
    local term_width=$(tput cols)
    local border_length=$((term_width - 4))
    local text="${1}"
    local border_char="${2:-=}"
    local border_color="${3:-$CYAN}"

    if [[ -n $text ]]; then
        local text_length=${#text}
        local half_border_length=$(((border_length - text_length - 2) / 2))
        local border_left=$(printf "%-${half_border_length}s" | tr " " "$border_char")
        local border_right=$(printf "%-${half_border_length}s" | tr " " "$border_char")
        echo -e "${BOLD}${border_color}${border_left} ${text} ${border_right}${RESET}"
    else
        echo -e "${BOLD}${border_color}$(printf "%-${border_length}s" | tr " " "$border_char")${RESET}"
    fi
}

type_effect() {
    text="$1"
    delay=0.02
    for i in $(seq 0 ${#text}); do
        printf "${text:$i:1}"
        sleep "$delay"
    done
    printf "\n"
}

progress_bar() {
  local MAX_STEPS=${#STEPS[@]}
  local BAR_SIZE="####################"
  local MAX_BAR_SIZE="${#BAR_SIZE}"
  local CLEAR_LINE="\\033[K"

  tput civis -- invisible

  for step in "${!STEPS[@]}"; do
    perc=$((step * 100 / MAX_STEPS))
    percBar=$((perc * MAX_BAR_SIZE / 100))
    echo -ne "\\r- ${STEPS[step]} [ ]$CLEAR_LINE\\n"
    echo -ne "\\r[${BAR_SIZE:0:percBar}] $perc %$CLEAR_LINE"

    ${CMDS[$step]}

    perc=$(((step + 1) * 100 / MAX_STEPS))
    percBar=$((perc * MAX_BAR_SIZE / 100))
    echo -ne "\\r\\033[1A- ${STEPS[step]} [✔]$CLEAR_LINE\\n"
    echo -ne "\\r[${BAR_SIZE:0:percBar}] $perc %$CLEAR_LINE"
  done
  echo ""

  tput cnorm -- normal
}

loading_animation() {
    clear
    echo -e "${GREEN}Initializing ..${RESET}\n"

    progress=("█1%" "██4%" "███8%" "████10%" "█████12%" "██████15%" "███████19%" "████████28%" "██████████30%" "████████████40%" "█████████████50%" "████████████████60%" "███████████████████88%" "██████████████████████████████100%")

    for i in "${progress[@]}"; do
        clear
        echo -e "${CYAN}Progress: ${YELLOW}/$i.../${RESET}"
        sleep 0.1
    done
    
    clear
}

banner_text() {
    cat <<EOF
███╗   ███╗███████╗███╗   ██╗██╗   ██╗
████╗ ████║██╔════╝████╗  ██║██║   ██║
██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝
EOF
}

banner() {
    clear
    border " MENU "

    local lines=($(banner_text))
    local banner_start_y=2
    for ((i = 0; i < ${#lines[@]}; i++)); do
        local text_x=$(get_center_x "${lines[i]}")
        tput cup $((banner_start_y + i)) "$text_x"
        echo -e "${lines[i]}" | lolcat --spread=5.0 --freq=1.0 --seed=256
    done
    echo ""
    border
}

sys_info() {
    DATE=$(TZ=Asia/Jakarta date "+%A, %d-%B-%Y %H:%M:%S")
    BIRTH_YEAR=1997
    CURRENT_YEAR=$(date "+%Y")
    AGE=$((CURRENT_YEAR - BIRTH_YEAR))

    echo ""
    echo -e "${CYAN}Name: ${WHITE} Lucifer${RESET}"
    echo -e "${CYAN}Age: ${WHITE} ${AGE} tahun${RESET}"
    echo -e "${CYAN}Alamat: ${WHITE} Jakarta - Indonesia${RESET}"
    echo -e "${CYAN}Github: ${WHITE} https://github.com/jonesroot${RESET}"
    echo -e "${CYAN}Instagram: ${WHITE} https://www.instagram.com/guagataudah${RESET}"
    echo -e "${CYAN}Telegram: ${WHITE} https://t.me/LuciferReborns${RESET}"
    echo -e "${CYAN}Date: ${WHITE} ${DATE}${RESET}"
    echo ""
    border
}

get_quote() {
    local TEMP_DIR="$(mktemp)"
    local QOTD=$(curl -s https://dummyjson.com/quotes/random | jq -r ".quote" 2>$TEMP_DIR)

    if [ -z "$QOTD" ]; then
        QOTD="Success is not final, failure is not fatal: it is the courage to continue that counts."
    fi

    echo ""
    echo -e "${YELLOW}Quote of The Day:${RESET}"
    echo ""
    echo -e "${GREEN}\"${QOTD}\"${RESET}"
    echo ""
    border
}

create_table() {
    local width=$(tput cols)
    local column_width=$((width / 2 - 4))

    left_menu=("1) Update & Upgrade" "2) Install Libs for Termux" "3) Install Libs for Python3" "4) SpeedTest" "5) Update bash.bashrc")
    right_menu=("6) Clone Repository" "7) Get List Screen" "8) Enter Screen" "9) Go to Home" "x) Close Termux App")

    echo -e "${BOLD}${CYAN}╔$(printf '═%.0s' $(seq 1 $((column_width))))╦$(printf '═%.0s' $(seq 1 $((column_width))))╗${RESET}"
    for i in {0..4}; do
        printf "${BOLD}${CYAN}║${RESET} ${BOLD}${RED}%-*s${RESET} ${BOLD}${CYAN}║${RESET} ${BOLD}${GREEN}%-*s${RESET} ${BOLD}${CYAN}║${RESET}\n" "$column_width" "${left_menu[i]}" "$column_width" "${right_menu[i]}"
    done
    echo -e "${BOLD}${CYAN}╚$(printf '═%.0s' $(seq 1 $((column_width))))╩$(printf '═%.0s' $(seq 1 $((column_width))))╝${RESET}"
}

loading_animation
clear
banner
sys_info
get_quote
create_table
echo -e "${MAGENTA}$(date)${RESET}\n"
echo -e "${BLUE}Author  : ${WHITE}Lucifer"
echo -e "${BLUE}Country : ${WHITE}Indonesia"
echo -e "${BLUE}City    : ${WHITE}Jakarta${RESET}\n"

echo -e "${RED}Do not forget your username & password!${RESET}\n"

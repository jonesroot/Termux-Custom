import os
import socket
import requests
import speedtest

RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
CYAN = "\033[96m"
RESET = "\033[0m"

def check_internet():
    print(f"{YELLOW}Checking internet connection...{RESET}")
    response = os.system("ping -c 1 google.com > /dev/null 2>&1")
    if response == 0:
        print(f"{GREEN}Internet is connected!{RESET}\n")
        return True
    else:
        print(f"{RED}No internet connection!{RESET}\n")
        return False

def get_ip_info():
    try:
        public_ip = requests.get("https://api64.ipify.org?format=json").json()["ip"]
    except requests.RequestException:
        public_ip = "Unable to fetch"

    local_ip = socket.gethostbyname(socket.gethostname())

    print(f"{CYAN}Public IP: {GREEN}{public_ip}{RESET}")
    print(f"{CYAN}Local IP: {GREEN}{local_ip}{RESET}\n")

def speed_test():
    print(f"{YELLOW}Running speed test...{RESET}")
    st = speedtest.Speedtest()
    st.get_best_server()
    download_speed = st.download() / 1_000_000
    upload_speed = st.upload() / 1_000_000

    print(f"{CYAN}Download Speed: {GREEN}{download_speed:.2f} Mbps{RESET}")
    print(f"{CYAN}Upload Speed: {GREEN}{upload_speed:.2f} Mbps{RESET}\n")

def ping_test(host="8.8.8.8"):
    print(f"{YELLOW}Pinging {host}...{RESET}")
    response = os.popen(f"ping -c 4 {host}").read()
    print(response)

if __name__ == "__main__":
    os.system("clear")
    print(f"{CYAN}==== Network Status Checker ===={RESET}\n")
    
    if check_internet():
        get_ip_info()
        speed_test()
        ping_test()

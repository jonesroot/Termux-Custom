import os
import sys

def play_sound(option):
    sounds = {
        "1": "process.mp3",
        "2": "granted.mp3",
        "3": "denied.mp3"
    }
    
    if option not in sounds:
        print("Invalid option. Use 1, 2, or 3.")
        sys.exit(1)
    
    os.system("clear")
    print(
        "\033[1;32m──────────────── Booting Termux Terminal ────────────────\033[0m"
    )
    os.system(
        f"nohup mpv ~/Termux-Custom/songs/{sounds[option]} > /dev/null 2>&1 &"
    )

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(
            "Example:\n"
            "- python3 sound_effect.py 1 (Process)\n"
            "- python3 sound_effect.py 2 (Granted)\n"
            "- python3 sound_effect.py 3 (Denied)\n"
            ""
        )
        sys.exit(1)
    
    play_sound(sys.argv[1])

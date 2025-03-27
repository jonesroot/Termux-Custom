#!/bin/bash

# Warna untuk tampilan
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)

echo -e "${yellow}Going back to old TermuX terminal! Thank You for using TermuX-Custom.${reset}"
sleep 1.0

# Masuk ke direktori konfigurasi Termux
cd $PREFIX/etc || exit

# Mengatur ulang motd (Message of the Day)
echo > motd
echo 'Welcome to Termux!' >> motd
echo >> motd
echo 'Wiki:            https://wiki.termux.com' >> motd
echo 'Community forum: https://termux.com/community' >> motd
echo 'Gitter chat:     https://gitter.im/termux/termux' >> motd
echo "IRC channel:     #termux on freenode" >> motd
echo >> motd
echo 'Working with packages:' >> motd
echo >> motd
echo '* Search packages:   pkg search <query>' >> motd
echo '* Install a package: pkg install <package>' >> motd
echo '* Upgrade packages:  pkg upgrade' >> motd
echo >> motd
echo 'Subscribing to additional repositories:' >> motd
echo >> motd
echo '* Root: pkg install root-repo' >> motd
echo '* Unstable: pkg install unstable-repo' >> motd
echo '* X11:      pkg install x11-repo' >> motd
echo >> motd
echo 'Report issues at https://termux.com/issues' >> motd
echo >> motd
echo -e "${green}✔ motd berhasil dikembalikan.${reset}"

# Mengatur ulang bash.bashrc ke default
echo 'if [ -x /data/data/com.termux/files/usr/libexec/termux/command-not-found ]; then' > bash.bashrc
echo '        command_not_found_handle() {' >> bash.bashrc
echo '                /data/data/com.termux/files/usr/libexec/termux/command-not-found "$1"' >> bash.bashrc
echo '        }' >> bash.bashrc
echo 'fi' >> bash.bashrc
echo >> bash.bashrc
echo "PS1='\$ '" >> bash.bashrc
echo -e "${green}✔ bash.bashrc berhasil dikembalikan.${reset}"

# Hapus banner.sh jika ada
if [ -f "$HOME/banner.sh" ]; then
    rm -f "$HOME/banner.sh"
    echo -e "${green}✔ banner.sh berhasil dihapus.${reset}"
else
    echo -e "${red}✘ banner.sh tidak ditemukan.${reset}"
fi

# Hapus konfigurasi bash pengguna
if [ -f "$HOME/.bashrc" ]; then
    rm -f "$HOME/.bashrc"
    echo -e "${green}✔ .bashrc berhasil dihapus.${reset}"
fi

if [ -f "$HOME/.bash_profile" ]; then
    rm -f "$HOME/.bash_profile"
    echo -e "${green}✔ .bash_profile berhasil dihapus.${reset}"
fi

# Restart shell agar perubahan diterapkan
echo -e "${yellow}Restart Termux untuk melihat perubahan.${reset}"
exit

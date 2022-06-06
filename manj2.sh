#!/bin/bash

   PACKAGES="sudo f2fs-tools mtools ntfs-3g p7zip unrar ark smplayer gparted aspell-ru firefox firefox-i18n-ru audacious conky"

     NVIDIA="mhwd -i pci video-nvidia"
AMD_NOUVEAU="xorg-server xorg-driver"

    echo '13. Устанавливаем NVIDIA AMD_ATI drivers'
    echo '1-NVIDIA_PROPRIETARY, 2-AMD и NOUVEAU'
    read choice
      if [[ "$choice" == "1" ]]; then
mhwd -i pci video-nvidia
    elif [[ "$choice" == "2" ]]; then
pacman -S xorg-server xorg-drivers
      fi
    echo '14. Выставляем регион'
    read -p 'ZONEINFO_' ZONEINFO_
ln -sf /usr/share/zoneinfo/$ZONEINFO_ /etc/localtime
    echo '15. Раскоментируем локаль системы'
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen

    echo '16. Генерируем локаль системы'
locale-gen

    echo '17. Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

    echo '18. Русифицируем консоль'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

    echo '19. Устанавливаем рабочий стол (DE)'
    echo '1-PLASMA, 2-CINNAMON, 3-GNOME, 4-XFCE, 5-LXQT, 6-MATE'
	read choice
	if [[ "$choice" == "1" ]]; then
pacman -S plasma manjaro-kde-settings sddm-breath-theme manjaro-settings-manager-knotifier manjaro-settings-manager-kcm pamac pavucontrol-qt && systemctl enable sddm 
	elif [[ "$choice" == "2" ]]; then
pacman -S cinnamon cinnamon-wallpapers cinnamon-sounds gnome-terminal parcellite lightdm lightdm-slick-greeter lightdm-settings manjaro-cinnamon-settings adapta-maia-theme kvantum-manjaro pamac pulseaudio pavucontrol && systemctl enable lightdm
	elif [[ "$choice" == "3" ]]; then
pacman -S gnome gnome-extra manjaro-settings-manager pamac pulseaudio pavucontrol && systemctl enable gdm
	elif [[ "$choice" == "4" ]]; then
pacman -S xfce4-gtk3 xfce4-goodies xfce4-terminal network-manager-applet xfce4-notifyd-gtk3 xfce4-whiskermenu-plugin-gtk3 tumbler pamac engrampa lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings manjaro-settings-manager pulseaudio pavucontrol && systemctl enable lightdm
	elif [[ "$choice" == "5" ]]; then
pacman -S lxqt xscreensaver lightdm lightdm-slick-greeter lightdm-settings light-locker manjaro-openbox-adapta-maia papirus-maia-icon-theme pamac pulseaudio pavucontrol-qt && systemctl enable lightdm
	elif [[ "$choice" == "6" ]]; then
pacman -S mate network-manager-applet mate-extra dconf-editor lightdm lightdm-slick-greeter lightdm-settings arc-maia-icon-theme papirus-maia-icon-theme manjaro-settings-manager manjaro-settings-manager-notifier pamac pulseaudio pavucontrol && systemctl enable lightdm
	fi
    echo '20. Создаем root пароль'
passwd
    echo '21. Создаём пользователя'
read -p 'USERNAME_' USERNAME_
useradd -m -G users,wheel,audio,video -s /bin/bash -s /bin/bash $USERNAME_
    echo '22. Вписываем такое же имя пользователя'
read -p 'USERNAME_' USERNAME_
    echo '23. Создаём пароль пользователя'
passwd $USERNAME_
    echo '24. Подключаем daemon NetworkManager'
systemctl enable NetworkManager
    echo '25. Устанавливаем grub (Если две и больше ОС раскоментируйте строку 62)'
pacman -S grub os-prober efibootmgr
#echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
    echo '26. Выбор диска установки grub'
read -p 'DISK_' DISK_
grub-install $DISK_
    echo '27. Обновляем grub'
update-grub
    echo '28. Устанавливаем программы'
pacman -S $PACKAGES
    echo '29. Раскоментируем sudoers'
sed -i '82c%wheel ALL=(ALL) ALL' /etc/sudoers
rm -rf /manjaro-install-scripts-main

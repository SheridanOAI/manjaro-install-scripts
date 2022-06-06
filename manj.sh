#!/bin/bash

pacman -Sy
pacman -S manjaro-kering
pacman -S unzip

    #echo 'Выбор места установки разделов (LOCATION)'
  ROOT_LOCATION=/mnt
  BOOT_LOCATION=/mnt/boot/efi
  DATA_LOCATION=/mnt/data
 DATA2_LOCATION=/mnt/data2

    echo '01. Выбор раздела ROOT (/dev/xxx)'
    read -p 'DEV_' DEV_

    echo '02. Форматирование раздела ROOT'

    echo '1 - BTRFS, 2 - EXT4'
    read choice
      if [[ "$choice" == "1" ]]; then
mkfs.btrfs -L Manj -f $DEV_ && mount $DEV_ /mnt && cd /mnt && btrfs sub cre @ && btrfs sub cre @home && btrfs sub cre @cache && btrfs sub cre @log && cd / && umount /mnt
    elif [[ "$choice" == "2" ]]; then
mkfs.ext4 -L Manj $DEV_ && mount $DEV_ /mnt && mkdir /mnt/{data,data2} && mkdir -p /mnt/boot/efi && cd / && umount /mnt
      fi

    echo '03. Монтирование раздела ROOT'
        echo '1 - BTRFS, 2 - EXT4'
    read choice
      if [[ "$choice" == "1" ]]; then
mount -o noatime,autodefrag,compress=zstd,subvol=@ $DEV_ /mnt && mkdir /mnt/{home,data,data2} && mkdir -p /mnt/boot/efi && mkdir -p /mnt/var/log && mkdir -p /mnt/var/cache && mount -o noatime,autodefrag,compress=zstd,subvol=@home $DEV_ /mnt/home && mount -o noatime,autodefrag,compress=zstd,subvol=@cache $DEV_ /mnt/var/cache && mount -o noatime,autodefrag,compress=zstd,subvol=@log $DEV_ /mnt/var/log
    elif [[ "$choice" == "2" ]]; then
mount $DEV_ /mnt
      fi

    echo '04. Монтирование раздела UEFI'
read -p 'BOOT_PARTITION_' BOOT_PARTITION_
mount $BOOT_PARTITION_ $BOOT_LOCATION
    echo '05. Монтирование раздела с данными 1'
read -p 'DATA_PARTITION_' DATA_PARTITION_
mount $DATA_PARTITION_ $DATA_LOCATION
    echo '06. Монтирование раздела с данными 2'
read -p 'DATA2_PARTITION_' DATA2_PARTITION_
mount $DATA2_PARTITION_ $DATA2_LOCATION
    echo '07. Монтирование раздела SWAP'
read -p 'SWAP_PARTITION_' SWAP_PARTITION_
swapon $SWAP_PARTITION_
    echo '08. Копирование и распаковка архива с github'
wget https://github.com/SheridanOAI/manjaro-install-scripts/archive/refs/heads/main.zip
unzip main.zip -d /mnt
    echo '09. Установка зеркал'
pacman-mirrors --fasttrack --api --protocol https

    echo '10. Установка ядра и основных пакетов'
    echo '1-ЯДРО-5.15-LTS, 2-ЯДРО-5.18'
    read choice
      if [[ "$choice" == "1" ]]; then
basestrap /mnt base linux515 mhwd linux-firmware dhcpcd nano
    elif [[ "$choice" == "2" ]]; then
basestrap /mnt base linux518 mhwd linux-firmware dhcpcd nano
    fi
    echo '11. Генерируем fstab'
fstabgen -U /mnt >> /mnt/etc/fstab
    echo '12. Переход в новое окружение'
manjaro-chroot /mnt /bin/bash /manjaro-install-scripts-main/manj2.sh

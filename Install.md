# Installation process
This is the install guide for the Asus laptop with tpm encryption.
The instruction will begin in the installation terminal as the previous steps are straightforward.

# Partitioning
- Spot the disk where you want to install the OS with `lsblk`.
- Use `sudo fdisk /dev/YOUR_DISK` with the following commands :
    - `g` #New GPT table
    - `n` #New partition
    - `1` #Partition 1
    - `2048` #First sector position
    - `+500M` #Partition sized to 500MiB
    - `t` #Change partition type (auto select first and only partition)
    - `1` #Select type 'EFI'
    - `n` #New partition
    - `2` #Partition 2
    - <kbd>Enter ⏎ </kbd> #Default start sector
    - `-8G` #Partition sized to max - 8 GiB
    - `n` #New partition
    - `2` #Partition 3
    - <kbd>Enter ⏎ </kbd> #Default start sector
    - <kbd>Enter ⏎ </kbd> #Default end sector (max size)
    - `t` #Change partition type
    - `3` #For partition 3
    - `19` #Select type 'Linux swap'
    - `w` #Write changes

# Luks encryption
Luks will act as a layer between the raw partitions that contain some encrypted data and the unencrypted partitions that will be used by the OS.
- `sudo cryptsetup luksFormat /dev/YOUR_PARTITION_2` to encrypt your root partition,
  when prompted type `YES` and then <kbd>Enter ⏎ </kbd> two times as the empty passphrase will be disabled when we use tpm
- Repeat this process with the third swap partition
- `sudo cryptsetup config --label LUKSSWAP /dev/$YOUR_PARTITION_2` to name your encrypted root
- `sudo cryptsetup config --label LUKSROOT /dev/$YOUR_PARTITION_3` to name your encrypted swap
  
Now that the partitions are formatted with Luks we need to open and map them:
- `sudo cryptsetup luksOpen /dev/YOUR_PARTITION_2 root` to open the root partition and map it to /dev/mapper/root
- `sudo cryptsetup luksOpen /dev/YOUR_PARTITION_3 swap` to open the swap partition and map it to /dev/mapper/swap

# Formatting
Let's now format the mapped unencrypted partitions and the boot partition:
- `sudo mkfs.ext4 /dev/mapper/root -L NIXROOT` #Formats the root partition with ext4 and gives it the NIXROOT name
- `sudo mkfs.fat -F 32 /dev/YOUR_PARTITION_1` #Formats the boot partition with fat 32
- `sudo fatlabel /dev/YOUR_PARTITION_1 NIXBOOT` #Names the boot partition NIXBOOT
- `sudo mkswap /dev/mapper/swap` #Formats the swap partition to be used as swap

# Mounting
We can now mount our partitions
- `sudo mount /dev/disk/by-label/NIXROOT /mnt` #Mount NIXROOT partition to /mnt
- `sudo mkdir /mnt/boot` #Create a boot directory in our NIXROOT partition
- `sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot` #Mount NIXBOOT partition to /mnt/boot
- `sudo swapon /dev/mapper/swap` #Enable the use of the swap partition

# Creating the nix config
Now that all the filesystem is setup we need to create the NixOs config:
`sudo nixos-generate-config --root /mnt`
We can then modify the auto-generated config by adding the necessary imports:
```nix
{ config, lib, pkgs, ...}:
{
    imports = [
        ./boot-configuration.nix
        ./hardware-configuration.nix
        ./users-configuration.nix
    ]
}
```
and leaving the rest as is.
We then need to copy the configuration files in the same directory as the nixos config files.

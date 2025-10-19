# StradexOS-ISO

> **Status:** Experimental fork of Arch Linux **archiso** with **auto-start archinstall** and **btrfs filesystem** defaults. The installer automatically launches on boot with a 3-second countdown.

---

## What is this?

This repository is a **fork** of the official Arch Linux **[archiso](https://github.com/archlinux/archiso)** project.  
It keeps the upstream toolchain and profile layout, and adds customizations for **StradexOS**:

### ✨ Key Features
- **Auto-start archinstall**: Automatically launches the installer on boot (with 3-second countdown)
- **btrfs filesystem**: Optimized for modern systems with snapshots and compression
- **All installer options**: Disk layout, encryption, users, hostname, etc. remain user-selectable

> **Not an official Arch Linux project.** This is community work maintained by **Stradex**.

---

## Filesystem Choice

This ISO is optimized for **btrfs** filesystem, which provides:
- **Snapshots** - Easy system rollbacks and backups
- **Compression** - Better disk space utilization
- **Subvolumes** - Flexible directory structure
- **Copy-on-write** - Efficient storage management

---

## Credits & License

- Upstream project: **[archlinux/archiso](https://github.com/archlinux/archiso)**  
- Copyright © Arch Linux contributors and respective authors
- This fork keeps the **GPL-3.0** license inherited from upstream. See `LICENSE`.

We are grateful to the ArchISO maintainers and contributors; this project wouldn't exist without their work.

---

## Building the ISO

> Build on Arch Linux (or an Arch chroot/container) with sufficient disk space.

### 1) Install build dependencies
```bash
sudo pacman -Syu --needed archiso mkinitcpio-archiso

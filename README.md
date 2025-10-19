# StradexOS-ISO

> **Status:** Experimental fork of Arch Linux **archiso** with **auto-start archinstall** and multiple filesystem options. The installer automatically launches on boot with a 3-second countdown.

---

## What is this?

This repository is a **fork** of the official Arch Linux **[archiso](https://github.com/archlinux/archiso)** project.  
It keeps the upstream toolchain and profile layout, and adds customizations for **StradexOS**:

### ✨ Key Features
- **Auto-start archinstall**: Automatically launches the installer on boot (with 3-second countdown)
- **Multiple filesystem options**: Choose from ext4, btrfs, xfs, f2fs, jfs, or nilfs2
- **All installer options**: Disk layout, encryption, users, hostname, etc. remain user-selectable

> **Not an official Arch Linux project.** This is community work maintained by **Stradex**.

---

## Available Filesystems

When you run archinstall, you can choose from these filesystem options:

- **ext4** - Stable, widely used, excellent compatibility
- **btrfs** - Advanced features, snapshots, compression, subvolumes
- **xfs** - High performance, especially with large files
- **f2fs** - Optimized for flash storage (SSDs, NVMe)
- **jfs** - Journaled filesystem, good performance
- **nilfs2** - Continuous snapshotting, good for data recovery

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

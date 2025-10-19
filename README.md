# StradexOS-ISO

> **Status:** Experimental fork of Arch Linux **archiso** with light-touch defaults for **Archinstall** (Btrfs filesystem + KDE Plasma desktop). All other installer options remain user-selectable at install time.

---

## What is this?

This repository is a **fork** of the official Arch Linux **[archiso](https://github.com/archlinux/archiso)** project.  
It keeps the upstream toolchain and profile layout, and adds a minimal tweak so that when you run **archinstall** from the live ISO, it **prefills**:
- **Filesystem:** `btrfs`
- **Desktop:** `kde`

Everything else (disk layout details, encryption, users, hostname, etc.) is still chosen interactively.

> **Not an official Arch Linux project.** This is community work maintained by **Stradex**.

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

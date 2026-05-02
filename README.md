<div align="center">

  <img src="https://www.sleuthkit.org/picts/renzik_sm.jpg" alt="Autopsy Logo" width="120"/>

  # Autopsy (Sleuth Kit Labs) AppImage for GNU/Linux

  ![AppImage](https://img.shields.io/badge/-AppImage-bc342d?style=flat-square&logo=appimage&logoColor=white)
  ![Linux](https://img.shields.io/badge/-Linux-FCC624?style=flat-square&logo=linux&logoColor=black)

</div>

> **Autopsy®** is the premier end-to-end open source digital forensics platform. Built by **Sleuth Kit Labs** with the core features you expect in commercial forensic tools, Autopsy is a fast, thorough, and efficient hard drive investigation solution that evolves with your needs.
> — *Extracted from [Autopsy Website](https://www.autopsy.com/)*

---

## Why this repository?

Configuring **Autopsy** on GNU/Linux can sometimes be complex due to Java dependencies, Sleuthkit versions, and environment variables.

This project aims to simplify the process for the community by providing:
1.  **A ready-to-use AppImage:** Just download and run.
2.  **A Build Script:** A transparent way to generate your own AppImage on Debian-based systems.

---

## Getting Started

### Option 1: Using the AppImage (Easiest)

1.  Go to the [Releases](https://github.com/jeiks/autopsy-appimage/releases) page.
2.  Download the latest `.AppImage` file.
3.  Give it execution permission:
    ```bash
    chmod +x Autopsy-x86_64.AppImage
    ```
4.  Run it:
    ```bash
    ./Autopsy-x86_64.AppImage
    ```

### Option 2: Building from Source

If you prefer to build the AppImage yourself on a Debian-based system (like Ubuntu or Debian Trixie), use the provided script:

```bash
git clone https://github.com/jeiks/Autopsy-AppImage.git
cd Autopsy-AppImage/
chmod +x build_appimage.sh
./build_appimage.sh
```

---

## Requirements
* **FUSE**: Needed to run AppImages on most modern distributions (e.g., ``sudo apt install fuse3`` on newer Ubuntu/Debian).

---

## Disclaimer

**No Warranties**. This is an unofficial community effort. This software is provided "as is", without warranty of any kind, express or implied. Use it at your own risk, especially in professional forensic environments.

---

## Contributing
Contributions are welcome! If you find a bug or have an improvement for the build script, feel free to:
* Open an **Issue**.
* Submit a **Pull Request**.

---

## Author
Jacson Rodrigues Correia-Silva (_jeiks_)<br>
_Computer Forensics & AI Researcher_

Developed with focus on education and digital forensics accessibility.

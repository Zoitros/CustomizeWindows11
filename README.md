![Platform](https://img.shields.io/badge/platform-Windows%2010%20%7C%2011-blue)
![Script](https://img.shields.io/badge/script-Batch%20%28CMD%29-lightgrey)
![Deployment](https://img.shields.io/badge/deployment-OOBE%20%7C%20Unattended%20%7C%20MDT-brightgreen)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-stable-success)


🛠️ Windows Post-Setup Automation Script (setup.cmd)

Automated post-setup program installation and cleanup script for Windows images.
Designed for Windows 10 / 11, OOBE, unattended installs, and custom ISO deployments.

This script safely installs common runtimes and applications after Windows setup, while avoiding known setup-phase pitfalls such as file locks, Windows Update conflicts, and cleanup failures.

✨ Features

✅ Setup-safe execution (OOBE / specialize compatible)
✅ Silent installation of common software
✅ Enterprise-grade cleanup using RunOnce
✅ Avoids Windows-managed tools conflicts (MSRT)
✅ No forced reboots
✅ Default User hive support
✅ Modular installer logic (EXE & MSI)

📦 Installed Applications
Software	Method
DirectX End-User Runtime	Silent EXE
Visual C++ Redistributable AIO	Silent EXE
Visual C++ Redistributable (14.40)	Silent EXE
7-Zip (x64)	Silent EXE + file associations
VLC Media Player	Silent EXE
Google Chrome Enterprise (x64)	Silent MSI
OpenHashTab	Silent EXE
Mozilla Firefox (x64)	Silent EXE

💡 All installers are expected to be placed in
C:\Windows\Setup\Programs

⚠️ Important Design Decisions
❌ Windows Malicious Software Removal Tool (KB890830)

MSRT is not executed manually.

Reason:
  * It is automatically handled by Windows
  * It is single-instance only
  * Forcing execution during setup causes file-in-use errors
  * The script detects and safely skips MSRT, matching Microsoft and enterprise deployment best practices.


📁 Expected Folder Structure
C:\Windows\Setup\
│
├─ Programs\
│   ├─ DirectX End-User Runtime x86-x64.exe
│   ├─ Visual B-C++ Redist AIO x86-x64.exe
│   ├─ VC_redist.x64_14.40.33810.exe
│   ├─ 7-Zip x64.exe
│   ├─ vlc-3.0.21-win64.exe
│   ├─ GoogleChromeStandaloneEnterprise64.msi
│   ├─ OpenHashTab x86-x64.exe
│   └─ Firefox x64.exe
│
└─ setup.cmd

🚀 How It Works
  1. Runs during post-setup / first logon
  2. Loads the Default User registry hive
  3. Installs applications silently and sequentially
  4. Applies file associations where applicable
  5. Releases directory locks properly
  6. Defers cleanup using RunOnce (guaranteed)
  7. Leaves Windows Update and servicing intact

🧹 Cleanup Strategy (Why It’s Reliable)
  1. The script does not delete itself
  2. Working directory locks are released via PopD
  3. Cleanup is deferred to next boot using:
       HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce
     This avoids:
       * File-in-use errors
       * MSI handle locks
       * Setup instability
    
  🧩 Customization
  Add a new EXE installer
    CALL :InstallEXE "YourInstaller.exe" "/silent /norestart"
  Add a new MSI installer
    CALL :InstallMSI "YourInstaller.msi" "/qn /norestart"
  Change installer location
    Modify:
      SET "APPPATH=%SystemRoot%\Setup\Programs"


🖥️ Compatibility
  * Windows 10 (22H2+)
  * Windows 11 (22H2 / 23H2 / 24H2)
  * Offline & online images
  * Custom ISOs
  * Unattended installs
  * MDT-compatible


🔐 Best Practices Followed
  * No forced reboots
  * No Windows Update interference
  * No TrustedInstaller conflicts
  * No self-deleting scripts
  * Safe registry hive handling

📜 License
MIT License — free to use, modify, and distribute.


👤 Author
Zoitros
GitHub: https://github.com/zoitros



⭐ Tips
If you find this useful:
  ⭐ Star the repository
  🛠️ Fork and customize
  📄 Submit improvements or fixes

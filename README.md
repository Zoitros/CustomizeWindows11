⚙️ Windows Unattended Setup Configuration (autounattend.xml)

This repository contains a Windows unattended installation configuration using autounattend.xml, designed for automated Windows 10 / 11 deployments.

The configuration streamlines Windows Setup by pre-configuring system settings, skipping unnecessary prompts, and integrating post-setup automation for a clean, repeatable installation experience.



✨ Features

✅ Fully unattended Windows installation
✅ OOBE automation (no manual clicks)
✅ Locale, region, and keyboard preset
✅ Privacy-friendly defaults
✅ Administrator account configuration
✅ Post-setup command execution
✅ Compatible with custom ISOs and USB installers
✅ Safe for Windows servicing and updates


🧩 What This autounattend.xml Does

During Windows Setup, this configuration:
  Automates language, keyboard, and regional settings
  Skips unnecessary OOBE screens (privacy, EULA, account prompts)
  Configures initial user / administrator behavior
  Applies setup-time system defaults
  Triggers post-setup scripts (e.g. setup.cmd)
  Prepares the system for first logon without breaking Windows Update


🖥️ Supported Windows Versions

Windows 10 (22H2+)
Windows 11 (22H2 / 23H2 / 24H2)
⚠️ Not intended for Windows Server editions without modification.


📁 Recommended Folder Layout
ISO_ROOT\
│
├─ autounattend.xml
│
└─ sources\
   └─ $OEM$\
      ├─ $$\
        ├─ Setup\
          ├─ Script\
          ├─ Programs\
    
autounattend.xml must be placed in the root of the installation media (USB or ISO) to be detected automatically by Windows Setup.


🔗 Integration with setup.cmd
This autounattend.xml is designed to work alongside a post-setup automation script, typically executed during:
  - specialize
  - oobeSystem
  - or first logon


The post-setup script can handle:
  ∞ Silent application installation
  ∞ Registry customization
  ∞ Default user configuration
  ∞ Deferred cleanup
💡 See setup.cmd in this repository for the post-setup logic.


🔐 Security & Best Practices
  No forced Windows Update blocking
  No servicing stack interference
  No hard-coded sensitive credentials (recommended)
  Compatible with Secure Boot
  Safe for future Windows feature updates


🛠️ Customization Tips
Change region or keyboard
  Modify the locale and input settings in:
  <International-Core>


Control OOBE behavior
Adjust options under:
  <oobeSystem>


Add or remove post-setup commands
Edit the commands executed during:
  <FirstLogonCommands>


⚠️ Important Notes
Always test in a virtual machine before deploying to real hardware
Keep backups of your original ISO
Feature updates may require minor XML adjustments
Avoid embedding plaintext passwords for public repositories

📜 License
MIT License — free to use, modify, and distribute.

👤 Author
Zoitros
GitHub: https://github.com/zoitros



⭐ Recommendations

If you find this useful:
  ⭐ Star the repository
  🍴 Fork and customize
  🧪 Test before production use

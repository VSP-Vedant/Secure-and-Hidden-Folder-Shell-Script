# Secure-and-Hidden-Folder-Locking-System-Shell-Script
---

## Introduction

The **Secure and Hidden Folder Locking System** is a simple yet robust tool designed to enhance data security by locking and hiding sensitive folders using Shell Scripting. Developed and tested in a Kali Linux environment, the tool provides an easy-to-use command-line interface to secure folders through password protection and a recovery mechanism via security questions.

This project is ideal for users who want to safeguard their confidential files without the overhead of complex software. With a minimal set of prerequisites and a focus on ease of use, the tool can be quickly integrated into your daily workflow.

## Features

- **Password Protection:** Secure your folder with a user-defined password stored as a SHA-256 hash.
- **Folder Hiding:** Lock the folder by renaming it with a hidden attribute, making it invisible in standard file listings.
- **Security Question Recovery:** Reset your password using a security question if you ever forget it.
- **Colored Menu Interface:** A user-friendly command-line menu with ANSI color codes for better visual feedback.
- **Lightweight:** Implemented entirely in Shell Script, ensuring minimal resource usage.

## Prerequisites

Before you begin, ensure that you have the following installed on your system:

- **Operating System:** Kali Linux (or any Linux distribution)
- **Shell:** Bash (default in most Linux distributions)
- **Utilities:** 
  - `sha256sum`
  - `mv`
  - `chmod`
  - `nano` (or your preferred text editor for modifying the script)
  
You can install any missing utilities via your package manager. For example, to install nano on Kali Linux, run:

```bash
sudo apt-get update
sudo apt-get install nano
```

## Usage

1. **Clone the Repository**

   Clone this repository to your local machine using the following command:

   ```bash
   git clone https://github.com/yourusername/secure-hidden-folder-locking-system.git
   cd secure-hidden-folder-locking-system
   ```

2. **Set Up the Tool**

   - Open the script file (e.g., `locker.sh`) using your favorite text editor:

     ```bash
     nano locker.sh
     ```

   - Review the configuration section to ensure that the default folder names and paths meet your requirements.

3. **Run the Script**

   - Make the script executable:

     ```bash
     chmod +x locker.sh
     ```

   - Execute the script:

     ```bash
     ./locker.sh
     ```

4. **Using the Menu**

   Upon running, you will be presented with a colored menu:
   - **Lock Folder:** Locks and hides the specified folder.
   - **Unlock Folder:** Unlocks and reveals the folder after password verification.
   - **Change Password:** Update your current password.
   - **Reset Password:** Reset your password via the security question.
   - **Exit:** Close the application.

   Follow the on-screen prompts to perform the desired operations.

5. **Initial Setup**

   - **Create the Folder:** Manually create a folder named **SafeLocker** in the same directory as the script if it does not already exist.
   - **Set Password:** On the first run, select **option 3 (Change Password)** from the menu to set your password. This step is crucial as it initializes the password protection mechanism required to lock and unlock the folder.

## Contribution

Feel free to fork this repository and contribute improvements or new features. Pull requests are welcome!

## License

Distributed under the MIT License. See `LICENSE` for more information.

## References

- [GNU Bash Manual](https://www.gnu.org/software/bash/manual/bash.html)
- [The Linux Documentation Project](https://tldp.org/LDP/intro-linux/html/sect_03_04.html)
- [Stack Overflow - Hashing in Bash](https://stackoverflow.com/questions/15524356/hash-string-in-bash)
- [GeeksforGeeks - File Locking in Linux](https://www.geeksforgeeks.org/file-locking-in-linux/)
- [GNU Nano Documentation](https://www.nano-editor.org/docs.php)
- [Kali Linux Documentation](https://www.kali.org/docs/general-use/)

---

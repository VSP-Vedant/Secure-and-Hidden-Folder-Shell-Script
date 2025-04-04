#!/bin/bash
# ==============================
# Folder Locker Shell Script with Colored Menu
# Version: 1.2
#
# Features:
#  - Set and change a password (with a one‑time security question/answer for recovery)
#  - Reset the password (if forgotten) by answering your security question
#  - "Lock" a folder by renaming it (hiding it) and "unlock" it by renaming it back
#
# Note: On Linux, folders starting with a dot (.) are hidden.
# ==============================

# Set color variables using ANSI escape sequences
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'    # No Color

# Configuration Variables:
folderName="SafeLocker"
baseDir="$(dirname "$0")"
folderPath="$baseDir/$folderName"
# When locked, the folder is renamed: add a dot and a Windows-like CLSID suffix.
lockedFolderName=".${folderName}.{21EC2020-3AEA-1069-A2DD-08002B30309D}"
lockedFolderPath="$baseDir/$lockedFolderName"
passwordFile="$HOME/.locker_pass"       # stores the SHA-256 hash of the password
securityFile="$HOME/.locker_secQ"         # first line: security question; second line: hashed answer

# Helper function: produce SHA-256 hash of an input string.
hash_string() {
    echo -n "$1" | sha256sum | awk '{print $1}'
}

# Function: compare two hashes (simple string comparison)
compare_hash() {
    [ "$1" == "$2" ]
}

# Function to set (or change) the password
# If a password already exists and we are not forcing a reset, prompt for the current password.
# Also, only set the security question if it doesn't already exist.
save_password() {
    local isNewPassword="$1"  # if "new", then force new password without checking current password

    if [ -f "$passwordFile" ] && [ "$isNewPassword" != "new" ]; then
        echo "A password is already set. To change it, please verify the current password."
        read -s -p "Enter current password: " current_password
        echo
        local current_hash
        current_hash=$(hash_string "$current_password")
        local saved_hash
        saved_hash=$(cat "$passwordFile")
        if ! compare_hash "$current_hash" "$saved_hash"; then
            echo -e "${RED}Invalid current password. Cannot change the password.${NC}"
            return 1
        fi
    fi

    read -s -p "New password: " new_password
    echo
    local new_hash
    new_hash=$(hash_string "$new_password")
    echo "$new_hash" > "$passwordFile"
    echo -e "${GREEN}Password set successfully.${NC}"

    # Only prompt for security question if not set already.
    if [ ! -f "$securityFile" ]; then
        echo "Set a security question and answer for password recovery."
        read -p "Enter security question: " sec_question
        read -s -p "Enter answer to security question: " sec_answer
        echo
        local sec_answer_hash
        sec_answer_hash=$(hash_string "$sec_answer")
        {
            echo "$sec_question"
            echo "$sec_answer_hash"
        } > "$securityFile"
        echo -e "${GREEN}Security question and answer set successfully.${NC}"
    elif [ "$isNewPassword" = "new" ]; then
        echo "Security question remains unchanged."
    fi

    # Clear plaintext variables
    new_password=""
    current_password=""
    sec_answer=""
}

# Function to load the saved password hash.
load_password() {
    if [ -f "$passwordFile" ]; then
        cat "$passwordFile"
    else
        echo -e "${RED}No password found. Please set a password first.${NC}" >&2
        return 1
    fi
}

# Function to load the security question and hashed answer.
load_security_question() {
    if [ -f "$securityFile" ]; then
        local question answer
        question=$(head -n 1 "$securityFile")
        answer=$(tail -n 1 "$securityFile")
        echo "$question||$answer"
    else
        echo -e "${RED}No security question set. Please set one by changing your password.${NC}" >&2
        return 1
    fi
}

# Function to reset the password using the security question.
reset_password() {
    if [ ! -f "$securityFile" ]; then
        echo -e "${RED}No security question set. Cannot reset password.${NC}"
        return 1
    fi
    echo "Answer the following security question to reset your password."
    IFS='||' read -r sec_question saved_sec_answer < <(load_security_question)
    echo "Security Question: $sec_question"
    read -s -p "Enter answer: " user_sec_answer
    echo
    local user_sec_answer_hash
    user_sec_answer_hash=$(hash_string "$user_sec_answer")
    if compare_hash "$user_sec_answer_hash" "$saved_sec_answer"; then
        echo -e "${GREEN}Security answer correct. You can set a new password.${NC}"
        save_password new
    else
        echo -e "${RED}Incorrect answer to security question.${NC}"
        return 1
    fi
}

# Function to lock the folder.
# The folder is locked by renaming it to a hidden name.
lock_folder() {
    if [ ! -d "$folderPath" ]; then
        echo -e "${RED}Folder '$folderPath' not found.${NC}"
        return 1
    fi
    mv "$folderPath" "$lockedFolderPath"
    echo -e "${GREEN}Folder locked and hidden.${NC}"
}

# Function to unlock the folder.
unlock_folder() {
    if [ ! -d "$lockedFolderPath" ]; then
        echo -e "${RED}Locked folder not found.${NC}"
        return 1
    fi
    read -s -p "Enter password to unlock the folder: " user_password
    echo
    local user_hash
    user_hash=$(hash_string "$user_password")
    local saved_hash
    saved_hash=$(load_password)
    if compare_hash "$user_hash" "$saved_hash"; then
        mv "$lockedFolderPath" "$folderPath"
        echo -e "${GREEN}Folder unlocked successfully.${NC}"
    else
        echo -e "${RED}Invalid password.${NC}"
        return 1
    fi
}

# Function to change the password.
change_password() {
    save_password
}

# -------------------------------
# Main Menu with Colored Output
# -------------------------------
while true; do
    echo -e "${CYAN}========== Folder Locker ==========${NC}"
    echo -e "${GREEN}1. Lock Folder${NC}"
    echo -e "${GREEN}2. Unlock Folder${NC}"
    echo -e "${GREEN}3. Change Password${NC}"
    echo -e "${GREEN}4. Reset Password (Forgot Password)${NC}"
    echo -e "${GREEN}5. Exit${NC}"
    echo -e "${CYAN}====================================${NC}"
    prompt_message=$(echo -e "${RED}Enter your choice (1-5): ${NC}")
    read -p "$prompt_message" choice
    case "$choice" in
        1)
            lock_folder
            read -p "Press Enter to continue..." ;;
        2)
            unlock_folder
            read -p "Press Enter to continue..." ;;
        3)
            change_password
            read -p "Press Enter to continue..." ;;
        4)
            reset_password
            read -p "Press Enter to continue..." ;;
        5)
            echo "Exiting..."
            exit 0 ;;
        *)
            echo -e "${RED}Invalid choice. Please select an option between 1 and 5.${NC}"
            read -p "Press Enter to continue..." ;;
    esac
done


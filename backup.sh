#!/bin/bash
NOW=$(date +"%Y-%m-%d") # dont touch

## CONFIG
BACKUP_KEY="$2"
BACKUP_TMP="/tmp/"

# Modes:
#  - attach: Attach the encrypted backup as a file
BACKUP_MODE="attach"

## PROCESS
NL=$'\n'

function do_backup {
        BACKUP_FILE="$BACKUP_TMP$1.gz.enc"
        BACKUP_EMAIL="$2"
        BACKUP_SUBJECT="$3 - $NOW"

        if [[ -f "$BACKUP_FILE" ]]; then
                rm "$BACKUP_FILE"
        fi

        cat - | openssl enc -aes-256-cbc -kfile "$4" -z > "$BACKUP_FILE"
        STATUS=$?

        if [[ $STATUS != "0" ]]; then
                echo "Backup Failed"
                echo "Backup Failed" | mutt -s "[FAIL] $BACKUP_SUBJECT" -- "$BACKUP_EMAIL"
        elif [[ "$1" == "output" ]] ; then
                echo "Backup File: $BACKUP_FILE"
        elif [[ "$5" == "attach" ]]; then
                echo "Backup Complete: $NOW" | mutt -a "$BACKUP_FILE" -s "[OK] $BACKUP_SUBJECT" -- "$BACKUP_EMAIL"
		else 
				FUNC="upload_$5"
				BACKUP_LINK=$(eval ${FUNC} "$BACKUP_FILE")
                echo "Backup Complete: ${NOW}${NL}Backup Link:${BACKUP_LINK}" | mutt -s "[OK] $BACKUP_SUBJECT" -- "$BACKUP_EMAIL"
        fi
}

function do_decrypt {
        cat - | openssl enc -aes-256-cbc -d -kfile "$1" -z
}

case $1 in
"backup")
        echo "Starting Backup"
        do_backup "$3" "$4" "$5" "$BACKUP_KEY" "$BACKUP_MODE"
        ;;
"decrypt")
        do_decrypt "$BACKUP_KEY"
        ;;
*)
        echo "Encrypted Backup Script"
        echo ""
        echo "Usage:"
        echo "./backup.sh backup [KEY] [FILENAME] [EMAIL] [SUBJECT]"
        echo "Description: Take the backup supplied via stdin, compress, encrypt and email to email@email.com"
        echo "Example: take_backup | ./backup.sh backup ~/backup.key backup.sql backup@company.com \"Database Backup\""
        echo ""
        echo "cat file.sql.gz.enc | ./backup.sh decrypt [KEY] > file.sql"
        echo "Description: Decrypt the file file.sql.gz.enc to file.sql"
        echo ""
  ;;
esac
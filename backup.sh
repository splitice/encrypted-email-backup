#!/bin/bash

#####################################
## CONFIG 
#####################################

# The type of encryption to use, options:
#  - unencrypted
#  - symmetric (keyfile)
#  - asymmetric (public/private)
ENCRYPTION_MODE="symmetric"

# The key file path, defaults to a supplied parameter
ENCRYPTION_KEY="$2"

# A temporary directory to store the backup
BACKUP_TMP="/tmp/"

# Modes:
#  - attach: Attach the encrypted backup as a file
BACKUP_MODE="attach"

#####################################
## PROCESS
#####################################

# No configuration below here
NL=$'\n'
NOW=$(date +"%Y-%m-%d") 

# If the file .backupconfig.sh exists then we will include it
# You can override the configuration here!
if [[ -f ".backupconfig.sh" ]]; then
	source ".backupconfig.sh"
fi

function do_encrypt {
	if [[ "$ENCRYPTION_MODE" == "symmetric" ]]; then
		cat - | openssl enc -aes-256-cbc -kfile "$1" -z
	elif [[ "$ENCRYPTION_MODE" == "asymmetric" ]]; then
		cat - | gzip | openssl smime -encrypt -aes256 -binary -outform DEM "$1"
	elif [[ "$ENCRYPTION_MODE" == "unencrypted" ]]; then
		cat - | gzip
	fi
}

function do_backup {
	BACKUP_FILE="$BACKUP_TMP$1.gz.enc"
	BACKUP_EMAIL="$2"
	BACKUP_SUBJECT="$3 - $NOW"

	if [[ -f "$BACKUP_FILE" ]]; then
		rm "$BACKUP_FILE"
	fi

	do_encrypt "$4" > "$BACKUP_FILE"
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
		if [[ -f "upload/$FUNC.sh" ]]; then
			source "upload/$FUNC.sh"
		fi
		BACKUP_LINK=$(eval ${FUNC} "$BACKUP_FILE")
		echo "Backup Complete: ${NOW}${NL}Backup Link:${BACKUP_LINK}" | mutt -s "[OK] $BACKUP_SUBJECT" -- "$BACKUP_EMAIL"
	fi
}

function do_decrypt {
	if [[ "$ENCRYPTION_MODE" == "symmetric" ]]; then
		cat - | openssl enc -aes-256-cbc -d -kfile "$1" -z
	elif [[ "$ENCRYPTION_MODE" == "asymmetric" ]]; then
		cat - | openssl smime -decrypt -binary -inform DEM -inkey "$1" | gzip -d
	elif [[ "$ENCRYPTION_MODE" == "unencrypted" ]]; then
		cat - | gzip -d
	fi
}

function create_keypair {
	openssl req -x509 -nodes -newkey rsa:2048 -keyout "$1" -out "$2"
}

case $1 in
"backup")
	echo "Starting Backup"
	do_backup "$3" "$4" "$5" "$ENCRYPTION_KEY" "$BACKUP_MODE"
	;;
"decrypt")
	do_decrypt "$ENCRYPTION_KEY"
	;;
"keypair")
	create_keypair "backup.key" "backup.pem"
	echo "Keypair created as backup.key and backup.pem"
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
	echo "./backup.sh keypair"
	echo "Description: Create a keypair suitable for use with the asymmetric encryption method"
	echo ""
  ;;
esac
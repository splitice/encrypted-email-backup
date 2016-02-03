#!/bin/bash
GDRIVE_FOLDER=${GDRIVE_FOLDER-backups}

function upload_gdrive {
	FOLDER_ID=$(drive list -q "TITLE='backups'" | tail -n +2 | head -n 1 | awk '{print $1}')
	if [[ "z$FOLDER_ID" == "z" ]]; then
		FOLDER_ID=$(drive folder --title "$GDRIVE_FOLDER" | grep "Id:" | awk '{print $2}')
	fi
	ID=$(drive upload --file "$1" --parent "$FOLDER_ID" | grep "Id:" | awk '{print $2}')
	drive url --id "$ID"
}
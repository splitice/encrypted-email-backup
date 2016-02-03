#!/bin/bash
GDRIVE_FOLDER=${GDRIVE_FOLDER-backups}

function upload_gdrive {
	FOLDER_ID=$(drive folder --title "$GDRIVE_FOLDER" | grep "Id:" | awk '{print $2}')
	ID=$(drive upload --file "$1" --parent "$FOLDER_ID" | grep "Id:" | awk '{print $2}')
	drive url --id "$ID"
}
#!/bin/bash
SCP_USER=${SCP_USER-backups}
SCP_HOST=${SCP_HOST-backup_server}
SCP_PATH=${SCP_PATH-/backups/}

function upload_scp {
	f=$(basename "$1")
	scp $1 $SCP_USER@$SCP_HOST:$SCP_PATH/$f >/dev/null
	echo $SCP_HOST:$SCP_PATH/$f
}
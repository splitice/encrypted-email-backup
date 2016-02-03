#!/bin/bash

function upload_gdrive {
	ID=$(drive upload --file "$1" | grep "Id:" | awk '{print $2}')
	drive url --id "$ID"
}
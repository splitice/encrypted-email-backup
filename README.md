# encrypted-email-backup
A simple script to backup your server to a email address as an encrypted compressed backup. The script itself is independent of your software being backed up, just pipe it the the backup (for multiple files, use tar).

## Requirements
 - mutt: To send emails
 - openssl: For encryption
 - gzip: For compression
 - bash: language of the script
 
## Usage

## How to Use
Using this software is simple, its just a matter of piping your backup to the script, and supplying the required parameters.

### Usage
```
Encrypted Backup Script

Usage:
./backup.sh backup [KEY] [FILENAME] [EMAIL] [SUBJECT]
Description: Take the backup supplied via stdin, compress, encrypt and email to email@email.com
Example: take_backup | ./backup.sh backup ~/backup.key backup.sql backup@company.com "Database Backup"

cat file.sql.gz.enc | ./backup.sh decrypt [KEY] > file.sql
Description: Decrypt the file file.sql.gz.enc to file.sql
```

### Instructions & Examples
See the post at: [soon]

## License
The MIT License (MIT). See LICENSE.
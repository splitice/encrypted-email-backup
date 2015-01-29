# encrypted-email-backup
A simple script to backup your server to a email address as an encrypted compressed backup. The script itself is independent of your software being backed up, just pipe it the the backup (for multiple files, use tar).

Developed to support an article sponsored by the [VpsBoard](https://www.vpsboard.com/) article bounty program.

## Requirements
 - mutt: To send emails
 - openssl: For encryption
 - gzip: For compression
 - bash: language of the script
 
## Limitations
Mail is sent with the backup as an attachment, you may be limited by the attachment size of your mail provider if you are not using your own mail server. See the wishlist if you want to develop an alternative upload method.
 
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
See the post at: https://vpsboard.com/page/index.html/_/linux-vps-tutorials/how-to-create-secure-linux-server-backups

## Planned Features / Wishlist
 - FTP Upload & HTTP Download
 - Dropbox or Cloud service upload / download
 
Feel free to submit a pull request.

## License
The MIT License (MIT). See LICENSE.
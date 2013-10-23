My setup for running my own infrastructure

This provides

- Mail via postfix/dovecot, using virtual users
- Spam protection using dspam and postgrey
- DKIM signing
- Full-text search over imap via dovecot-clucene

Planned:

- XMPP
- CalDAV / CardDAV

Requirements:

- Arch target host
- Sudo privileges on the target host
- /group_vars/communication:
  smtpd_host: $hostname
- SSL certificate in /roles/mail/files/ssl/certs/$hostname.pem
- SSL certificate key in /roles/mail/files/ssl/private/$hostname.key.enc
  This is expected to be encrypted with
  openssl aes-256-cbc -in $hostname.key -out $hostname.key.enc

- Opendkim keys below /roles/mail/files/opendkim/keys
  One folder per domain, below that a key named default.private.enc
  Again, this is encrypted with openssl (see ssl key above)

  Example:
  /roles/mail/files/opendkim/keys/example.com/default.private.enc

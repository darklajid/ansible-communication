My setup for running my own infrastructure

This provides:

- NTP (as a prerequisite)
- Mail via postfix/dovecot, using virtual users
- Spam protection using dspam and postgrey
- DKIM signing/verification
- Full-text search over imap via dovecot-clucene
- XMPP for all mail accounts

Open issues:

- postfix, add smtpd_sender_login_maps to allow sending from aliases?
- postfix, think about adding proxymap to pool connections?
- test sieve and managedsieve
- radicale is installed from git, which is less than optimal for reproducable builds..
- backup & restore scripts

Roadmap:

- Evaluate Mozilla Persona / OpenID
- Evaluate bitmessage
- Offer CalDAV/CardDAV web interfaces?
  CalDavZAP & CardDavMate?
- Offer webmail?
  Roundcube?
- Administrative interface for domains/users

Requirements:

- Arch target host
- Sudo privileges on the target host
- SSL certificate in /roles/common/files/certs/{{ansible_fqdn}}.pem
- SSL certificate private key in /roles/common/files/certs/{{ansible_fqdn}}.key.enc
  This is expected to be encrypted with
  openssl aes-256-cbc -in $hostname.key -out $hostname.key.enc

- Opendkim keys below /roles/mail/files/opendkim/keys
  One folder per domain, below that a key named default.private.enc
  Again, this is encrypted with openssl (see ssl key above)

  Example:
  /roles/mail/files/opendkim/keys/example.com/default.private.enc

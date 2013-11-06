CREATE TABLE IF NOT EXISTS virtual_domains (id SERIAL, name varchar(256) NOT NULL, PRIMARY KEY (id), UNIQUE (name));

CREATE TABLE IF NOT EXISTS virtual_users (id SERIAL, domain_id int NOT NULL REFERENCES virtual_domains(id) ON DELETE CASCADE, username varchar(100) NOT NULL, password varchar(128) NOT NULL, quota_limit_bytes int DEFAULT 104857600, PRIMARY KEY (id), UNIQUE (domain_id,username));

CREATE TABLE IF NOT EXISTS virtual_aliases (id SERIAL, domain_id int NOT NULL REFERENCES virtual_domains(id) ON DELETE CASCADE, username varchar(100) NOT NULL, destination varchar(100) NOT NULL, PRIMARY KEY (id), UNIQUE (domain_id,username));

CREATE TABLE IF NOT EXISTS recipient_access (id SERIAL, address varchar(100) NOT NULL, action varchar(100) NOT NULL Default 'reject', PRIMARY KEY (id), UNIQUE (address));

CREATE OR REPLACE VIEW dspam_virtual_uids AS SELECT u.Id, concat(u.username,'@',d.name) AS Email FROM virtual_users u LEFT JOIN virtual_domains d ON (u.domain_id = d.id);

CREATE TABLE IF NOT EXISTS virtual_domains (id SERIAL, name varchar(256) NOT NULL, PRIMARY KEY (id), UNIQUE (name));

CREATE TABLE IF NOT EXISTS virtual_users (id SERIAL, domain_id int REFERENCES virtual_domains(id) ON DELETE CASCADE, username varchar(100) NOT NULL, password varchar(128) NOT NULL, quota_limit_bytes int DEFAULT 104857600, PRIMARY KEY (id), UNIQUE (domain_id,username));

CREATE TABLE IF NOT EXISTS virtual_aliases (id SERIAL, domain_id int REFERENCES virtual_domains(id) ON DELETE CASCADE, username varchar(100) NOT NULL, destination varchar(100) NOT NULL, PRIMARY KEY (id), UNIQUE (domain_id,username));

CREATE OR REPLACE VIEW dspam_virtual_uids AS SELECT u.Id, concat(u.username,'@',d.name) AS Email FROM virtual_users u LEFT JOIN virtual_domains d ON (u.domain_id = d.id);

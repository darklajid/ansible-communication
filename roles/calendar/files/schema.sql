CREATE TABLE IF NOT EXISTS collection (
	       path varchar primary key not null,
	       parent_path varchar references collection (path));

CREATE TABLE IF NOT EXISTS item (
	       name varchar primary key not null,
	       tag varchar not null,
	       collection_path varchar references collection (path) not null);

CREATE TABLE IF NOT EXISTS header (
	       key varchar not null,
	       value varchar not null,
	       collection_path varchar references collection (path) not null,
	       primary key (key, collection_path));

CREATE TABLE IF NOT EXISTS line (
	       key varchar not null,
	       value varchar not null,
	       item_name varchar references item (name) not null,
	       timestamp timestamp not null);

CREATE TABLE IF NOT EXISTS property (
	       key varchar not null,
	       value varchar not null,
	       collection_path varchar references collection (path) not null,
	       primary key (key, collection_path));



CREATE TABLE IF NOT EXISTS dspam_token_data (
	  uid INT,
	  token BIGINT,
	  spam_hits INT,
	  innocent_hits INT,
	  last_hit DATE,
	  UNIQUE (uid, token)
) WITHOUT OIDS;

CREATE TABLE IF NOT EXISTS dspam_signature_data (
	  uid INT,
	  signature varchar(128),
	  data BYTEA,
	  length INT,
	  created_on DATE,
	  UNIQUE (uid, signature)
) WITHOUT OIDS;

CREATE TABLE IF NOT EXISTS dspam_stats (
	  uid INT PRIMARY KEY,
	  spam_learned INT,
	  innocent_learned INT,
	  spam_misclassified INT,
	  innocent_misclassified INT,
	  spam_corpusfed INT,
	  innocent_corpusfed INT,
	  spam_classified INT,
	  innocent_classified int
) WITHOUT OIDS;

CREATE TABLE IF NOT EXISTS dspam_preferences (
	  uid INT,
	  preference VARCHAR(128),
	  value VARCHAR(128),
	  UNIQUE (uid, preference)
) WITHOUT OIDS;

CREATE OR REPLACE FUNCTION lookup_tokens(integer,bigint[])
  returns setof dspam_token_data
  language plpgsql stable
  as '
declare
  v_rec record;
begin
  for v_rec in select * from dspam_token_data
    where uid=$1
      and token in (select $2[i]
        from generate_series(array_lower($2,1),array_upper($2,1)) s(i))
  loop
    return next v_rec;
  end loop;
  return;
end;';

CREATE OR REPLACE FUNCTION lookup_tokens(integer,integer,bigint[])
  returns setof dspam_token_data
  language plpgsql stable
  as '
declare
  v_rec record;
begin
  for v_rec in select * from dspam_token_data
    where uid=$1
      and token in (select $3[i]
        from generate_series(array_lower($3,1),array_upper($3,1)) s(i))
  loop
    return next v_rec;
  end loop;
  for v_rec in select * from dspam_token_data
    where uid=$2
      and token in (select $3[i]
	from generate_series(array_lower($3,1),array_upper($3,1)) s(i))
  loop
    return next v_rec;
  end loop;
  return;
end;';

/* For much better performance
 * see http://archives.postgresql.org/pgsql-performance/2004-11/msg00416.php
 * and http://archives.postgresql.org/pgsql-performance/2004-11/msg00417.php
 * for details
 */
ALTER TABLE dspam_token_data ALTER token SET STATISTICS 200;
ALTER TABLE dspam_signature_data ALTER signature SET STATISTICS 200;
ALTER TABLE dspam_token_data ALTER innocent_hits SET STATISTICS 200;
ALTER TABLE dspam_token_data ALTER spam_hits SET STATISTICS 200;
ANALYZE;

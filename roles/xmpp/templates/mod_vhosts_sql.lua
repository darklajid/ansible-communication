module:set_global();

local log = require "util.logger".init("vhosts_sql");
local dbi = require "DBI"
local hostmanager = require "core.hostmanager";

local params = module:get_option("sql");
local prosody = _G.prosody;

local function connect()
	module:log("debug", "Connecting to the database");
	prosody.unlock_globals();
	local dbh, err = dbi.Connect(
		params.driver, params.database,
		params.username, params.password,
		params.host, params.port
	);
	prosody.lock_globals();
	if not dbh then
		module:log("error", "Database connection failed: %s", tostring(err));
		return nil, err;
	end
	module:log("debug", "Successfully connected to the database");
	dbh:autocommit(true);
	return dbh;
end

local function get_statement(con)
	local stmt, err = con:prepare(params.query);
	if not stmt then
		module:log("error", "Failed to create the statement: %s %s",
		  err, debug.traceback());
		return nil, err;
	end

	local ok, err = stmt:execute();
	if not ok then
		module:log("error", "Failed to execute the statement: %s %s",
		  err, debug.traceback());
		return nil, err;
	end

	return stmt;
end

local function load_vhosts_from_db()
	local con, err = connect();
	if not con then return; end

	local stmt, err = get_statement(con);
	if not stmt then return; end;

	local host_config = { enable = true };
	for row in stmt:rows() do
		module:log("debug", "Activating host %s", row[1]);
		hostmanager.activate(row[1], host_config);
	end

	assert(con:close());
end

module:hook("server-started", load_vhosts_from_db);


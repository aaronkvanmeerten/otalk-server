admins = { "ADMIN@HOST" }
daemonize = true
pidfile = "/var/run/prosody/prosody.pid"

plugin_paths = { "/opt/otalk-server" }

modules_enabled = {
    "roster";
    "saslauth";
    "tls";
    "dialback";
    "disco";
    "private";
    "vcard";
    "privacy";
    "compression";
    "smacks";
    "carbons";
    "mam";
    "lastactivity";
    "offline";
    "pubsub";
    "version";
    "uptime";
    "time";
    "ping";
    "pep";
    "register";
    "adhoc";
    "admin_adhoc";
    "posix";
    "bosh";
    "websocket";
    "http_altconnect";
    "turncredentials";
    "idlecompat";
};

allow_registration = false;

ssl = {
    key = "/path/to/key";
    certificate = "/path/to/cert";
}

c2s_require_encryption = true
s2s_secure_auth = true

cross_domain_bosh = true

authentication = "internal_hashed"

storage = {archive2 = "sql2"}

sql = { driver = "SQLite3", database = "prosody.sqlite" }

default_archive_policy = "roster"

--turncredentials_secret = "yoursecretthing";
--turncredentials = {
--    { type = "stun", host = "8.8.8.8" },
--    { type = "turn", host = "8.8.8.8", port = 3478 },
--    { type = "turn", host = "8.8.8.8", port = 80, transport = "tcp" }
--}

log = {
    debug = "/var/log/prosody/prosody.log";
    error = "/var/log/prosody/prosody.err";
}

VirtualHost "HOST"

component_ports = { 5347 }
Component "muc.HOST" "muc"

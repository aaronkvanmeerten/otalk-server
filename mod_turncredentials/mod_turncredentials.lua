-- XEP-0215 implementation for time-limited turn credentials
-- Copyright (C) 2012-2013 Philipp Hancke
-- This file is MIT/X11 licensed. 

--turncredentials_secret = "keepthissecret";
--turncredentials = {
--    { type = "stun", host = "8.8.8.8" },
--    { type = "turn", host = "8.8.8.8", port = 3478 },
--    { type = "turn", host = "8.8.8.8", port = 80, transport = "tcp" }
--}
-- for stun servers, host is required, port defaults to 3478
-- for turn servers, host is required, port defaults to tcp, 
--          transport defaults to udp

local st = require "util.stanza";
local hmac_sha1 = require "util.hashes".hmac_sha1;
local base64 = require "util.encodings".base64;
local os_time = os.time;
local secret = module:get_option_string("turncredentials_secret");
local ttl = module:get_option_number("turncredentials_ttl", 86400);
local hosts = module:get_option("turncredentials") or {};
if not (secret) then
    module:log("error", "turncredentials not configured");
    return;
end

module:hook_global("config-reloaded", function()
    module:log("debug", "config-reloaded")
    secret = module:get_option_string("turncredentials_secret");
    ttl = module:get_option_number("turncredentials_ttl", 86400);
    hosts = module:get_option("turncredentials") or {};
end);

module:hook("iq-get/host/urn:xmpp:extdisco:1:services", function(event)
    local origin, stanza = event.origin, event.stanza;
    if origin.type ~= "c2s" then
        return;
    end
    local now = os_time() + ttl;
    local userpart = tostring(now);
    local nonce = base64.encode(hmac_sha1(secret, tostring(userpart), false));
    local reply = st.reply(stanza):tag("services", {xmlns = "urn:xmpp:extdisco:1"})
    for idx, item in pairs(hosts) do
        if item.type == "stun" or item.type == "stuns" then
            -- stun items need host and port (defaults to 3478)
            reply:tag("service", item):up();
        elseif item.type == "turn" or item.type == "turns" then
            -- turn items need host, port (defaults to 3478), 
	          -- transport (defaults to udp)
	          -- username, password, ttl
            item.username = userpart;
            item.password = nonce;
            item.ttl = ttl;
            reply:tag("service", item):up();
        end
    end
    origin.send(reply);
    return true;
end);

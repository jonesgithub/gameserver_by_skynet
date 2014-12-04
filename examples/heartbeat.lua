local skynet = require "skynet"
local redis = require "redis"
local netpack = require "netpack"
local socket = require "socket"

local CMD = {}

function CMD.heartbeat(...)

end

skynet.start(function()
	skynet.dispatch("lua", function(session, address, cmd, ...)
		local f = CMD[cmd]
		
		skynet.ret(skynet.pack(f(...)))
	end)
end)

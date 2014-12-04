-- by: peimin@outlook.com

package.path = "lualib/?.lua;gameserver/?.lua;3rd/json/?.lua"
package.cpath = "luaclib/?.so;3rd/json/?.so"

local skynet   = require "skynet"
local socket   = require "socket"
local json     = require "json"
local packdeal = require "packdeal"

local CMD = {}
local client_fd -- save client fd

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function (msg, sz)		
		return skynet.tostring(msg,sz)	
	end,
	dispatch = function (session, address, text)
		-- 这里收到包可以先解压
		print("recv: ", text)

		local req = json.decode(text)
		if req then
			print("proto: "..req["proto"])

			if "heartbeat" == req["proto"] then
				skynet.send("heartbeat", "lua", "heartbeat_deal", client_fd, req)
			else
				print("no this proto")
			end
		end		
	end
}

function CMD.start(gate, fd)
	client_fd = fd
	skynet.call(gate, "lua", "forward", fd)
end

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)

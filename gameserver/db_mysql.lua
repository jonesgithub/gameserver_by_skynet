-- by: peimin@outlook.com

local skynet = require "skynet"
local mysql  = require "mysql"

local CMD = {}
local DB;

function CMD.start()
	
end

skynet.start(function()
	local db=mysql.connect{	
		host="127.0.0.1",
		port=3306,
		database="test",
		user="root",
		password="mysql123456",
		max_packet_size = 1024 * 1024
	}
	if not db then
		print("failed to connect")
	end
	print("success to connect to mysql server")

	DB = db	

	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)

	--db:disconnect()
	--skynet.exit()
end)


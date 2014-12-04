-- by: peimin@outlook.com

package.cpath = "luaclib/?.so;3rd/json/?.so"
package.path = "lualib/?.lua;3rd/json/?.lua;gameserver/?.lua"

local socket = require "socket"
local bit32  = require "bit32"
local json   = require "json"

local packdeal = {}

-- notice: we use 2 bytes save pack_len in pack head

function packdeal.send_package(client_fd, ack)
	local pack = json.encode(ack)

	print("send: "..pack)

	-- 这里可以压缩

	local size = #pack
	local package = string.char(bit32.extract(size,8,8))..string.char(bit32.extract(size,0,8))..pack

	socket.write(client_fd, package)
end

function packdeal.unpack_package(text)
	local size = #text
	if size < 2 then
		return nil
	end
	local s = text:byte(1) * 256 + text:byte(2) -- s == pack_len -> size == s + 2
	if size < s+2 then
		return nil
	end

	-- 这里可以解压缩

	return json.decode(text:sub(3,2+s))
end

return packdeal
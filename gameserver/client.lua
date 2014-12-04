-- by: peimin@outlook.com

package.cpath = "luaclib/?.so;3rd/json/?.so"
package.path = "lualib/?.lua;gameserver/?.lua;3rd/json/?.lua"

local socket = require "clientsocket"
local bit32  = require "bit32"
local json   = require "json"

local fd = assert(socket.connect("127.0.0.1", 8888))

-- 这里发送包的时候会加上2个字节的头部来表示包的长度
local function send_package(fd, pack)
	local size = #pack
	local package = string.char(bit32.extract(size,8,8)) ..
		string.char(bit32.extract(size,0,8))..
		pack

	socket.send(fd, package)
end

-- 解包先处理头部的2字节长度
local function unpack_package(text)
	local size = #text
	if size < 2 then
		return nil, text
	end
	local s = text:byte(1) * 256 + text:byte(2)
	if size < s+2 then
		return nil, text
	end

	return text:sub(3,2+s)
end

local send_msg ={}
send_msg["proto"] = "heartbeat"
send_msg["hello"] = "world"

send_package(fd, json.encode(send_msg))
print("send: ", json.encode(send_msg)) --  {"proto":"heartbeat","hello":"world"}

while true do
	local recv_buf = socket.recv(fd)
	if recv_buf then
		print("recv: "..unpack_package(recv_buf)) --  {"ret":0,"proto":"heartbeat_ack"}

		local ret_msg = json.decode(unpack_package(recv_buf)) -- 客户端收到应答包先处理2字节的头部，再json解包成lua table。
		if ret_msg then
			print("proto: "..ret_msg["proto"])
			print("ret  : "..ret_msg["ret"])
		end
	end
end

socket.close(fd)
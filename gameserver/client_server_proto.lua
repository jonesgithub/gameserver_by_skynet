-- by: peimin@outlook.com
-- 客户端 服务器通信协议 
-- 这里用了lua来描述，在发包的时候会打包成json格式。
-- 协议第一个字段proto当做协议id来使用, 比如这里的heartbeat -> {"proto": "heartbeat", "hello": "wolrd"}
-- 由于这里是请求应答式协议，应答必须带一个"ret"字段，通常返回0表示服务器收到这个协议并且处理成功。

-------------------------- 系统使用的协议 ---------------------

-- 心跳 
proto.heartbeat = {
	proto = "heartbeat",
	hello = "wolrd",
}
proto.heartbeat_ack = {
	proto = "heartbeat_ack",
	ret = 0,
}

-------------------------- 登录系统 ------------------





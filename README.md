gameserver_by_skynet
====================
>基于skynet的游戏服务器

>使用的是skynet的v0.8.1版本，你也可以替换成其他版本。客户端服务器通信是请求应答式，使用了json做为通信的数据格式，具体的可以参考gameserver/client_server_proto.lua文件中心跳协议格式。

>目前是gate->agent->heartbeat->client，每一个连接对应一个agent，以后也可以考虑agent复用。

>编译的时候记得编译3rd/json下面的json库  skynet/3rd/json/ make

> ./skynet gameserver/config 

> ./lua gameserver/client.lua 

# -*- coding: utf-8 -*-
## secure random wrapper
def SECURE_RANDOM(len)
  return (Time.now.to_f * 1000).to_s
  return Ramdom::rand(10).to_s
end

Server   = get_server_class
r        = Server::Request.new
userdata = Userdata.new "redis_data_key"
redis    = userdata.redis
v        = Server::Var.new

## 各種パラメータを一旦保存する
key = SECURE_RANDOM(10)
redis.set("DBX:"+key+":allow",    v.arg_allow)
redis.set("DBX:"+key+":filename", v.arg_filename)
redis.set("DBX:"+key+":auth",     "Basic " + Base64::encode(v.arg_user+":"+v.arg_pass))
redis.set("DBX:"+key+":body",     r.var.request_body.to_s)

## 応答処理
hout = Server::Headers_out.new
hout['Content-Type'] = 'application/json'
Server.echo '{"key":"'+key+'"}'

Server.return Server::HTTP_OK

## EOF ##

# -*- coding: utf-8 -*-
Server = get_server_class
userdata = Userdata.new "redis_data_key"
redis    = userdata.redis
v        = Server::Var.new

## ダウンロードデータの読み取り
filename = redis.get("DBX:"+v.arg_key+":filename")
if (filename)
  ## ファイルがあれば、指定されたファイル名を元に配信
  hout = Server.Headers_out.new
  Server.echo redis.get("DBX:"+v.arg_key+":body")
  hout['Content-Disposition'] = 'attachment; filename="'+filename+'"'
  Server::return Server::HTTP_OK
else
  ## ファイルが無ければ終了
  Server::return Server::HTTP_FORBIDDEN
end

## EOF ##

# -*- coding: utf-8 -*-
## 認証チェック
## FIXME : 本当はこの書き方は良くない。
def CHECK_AUTH(cfg, req, salt)
  if (cfg && cfg == req)
    return true
  end
  return false
end

Server = get_server_class

userdata = Userdata.new "redis_data_key"
redis    = userdata.redis

v        = Server::Var.new
r        = Server::Request.new
c        = Server::Connection.new

## allow / deny処理
flg_allow = false
allowcfg = redis.get("DBX:"+v.arg_key+":allow")
if (allowcfg)
  allows = allowcfg.split(",")
  ## 許可IPに含まれていればアクセス許可
  if (allows.include? c.remote_ip)
    flg_allow = true
  end
end
if (!flg_allow)
  Server::return Server::HTTP_FORBIDDEN
else
  ## 以下BASIC認証の処理
  flg_auth = false
  r.headers_in.all.keys.each do |k|
    if (k == 'Authorization')
      if (CHECK_AUTH(redis.get("DBX:"+v.arg_key+":auth"), r.headers_in['Authorization'], "SALT"))
        flg_auth = true
      end
      break
    end  
  end
  if (!flg_auth)
    r.headers_out['WWW-Authenticate'] = 'Basic realm="dbx"'
    Server::return Server::HTTP_UNAUTHORIZED
  else
    # TROUGH
  end
end

## EOF ##

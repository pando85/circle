local _M = {}

function _M.check(claim_spec)
    local jwt = require "resty.jwt"


    local auth_header = ngx.var.http_Authorization
    if auth_header then
        -- The character `%´ works as an escape or special character
        _, _, token = string.find(auth_header, "Bearer%s+(.+)")
    end

    if token == nil then
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.header.content_type = "application/json; charset=utf-8"
        ngx.say("{\"error\": \"missing Authorization header\"}")
        ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end

    local public_key = ngx.shared.jwt:get("public_key")
    if public_key == nil then
        -- get RSA pubkey
        local pubkey_path = "/etc/nginx/jwt/public.pem"
        local file = assert(io.open(pubkey_path, "rb"))
        public_key = file:read "*all"
        file:close()
        local _, _, _ = ngx.shared.jwt:set("public_key", public_key)
    end

    jwt:set_alg_whitelist({RS256=1})

    local jwt_obj = jwt:load_jwt(token)
    local jwt_obj = jwt:verify(public_key, token, claim_spec)
    if not jwt_obj.verified then
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.header.content_type = "application/json; charset=utf-8"
        ngx.log(ngx.WARN, jwt_obj.reason)
        ngx.say("{\"error\": \"" .. jwt_obj.reason .. "\"}")
        ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end
    -- if we need to propagate user and admin.
    ngx.header["user"] = jwt_obj.payload["name"];
    ngx.header["admin"] = tostring(jwt_obj.payload["admin"]);
    return jwt_obj
end

return _M

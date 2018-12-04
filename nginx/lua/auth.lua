local _M = {}

function _M.check(claim_spec)
    local jwt = require "resty.jwt"


    local auth_header = ngx.var.http_Authorization
    if auth_header then
        -- The character `%´ works as an escape or special character
        _, _, token = string.find(auth_header, "circle%-token%s+(.+)")
    end

    if token == nil then
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.header.content_type = "application/json; charset=utf-8"
        ngx.say("{\"error\": \"missing Authorization header\"}")
        ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end

    -- validate any specific claims you need here
    -- https://github.com/SkyLothar/lua-resty-jwt#jwt-validators
    local validators = require "resty.jwt-validators"

    local key = os.getenv("JWT_SECRET")
    -- make sure to set and put "env JWT_SECRET;" in nginx.conf
    local jwt_obj = jwt:load_jwt(token)
    local verified = jwt:verify_jwt_obj(key, token, claim_spec)
    if not verified then
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.log(ngx.WARN, jwt_obj.reason)
        ngx.header.content_type = "application/json; charset=utf-8"
        ngx.say("{\"error\": \"" .. jwt_obj.reason .. "\"}")
        ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end
    -- if we need to propagate user and role.
    -- ngx.header["user"] = jwt_obj["payload"]["name"];
    -- ngx.header["role"] = jwt_obj["payload"]["role"];
    return jwt_obj
end

return _M

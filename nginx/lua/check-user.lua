local auth = require "/etc/nginx/lua/auth"

-- validate any specific claims you need here
-- https://github.com/SkyLothar/lua-resty-jwt#jwt-validators
local validators = require "resty.jwt-validators"

local claim_spec = {
    -- validators.set_system_leeway(15), -- time in seconds
    -- exp = validators.is_not_expired(),
    -- iat = validators.is_not_before(),
    -- iss = validators.opt_matches("^http[s]?://yourdomain.auth0.com/$"),
    -- sub = validators.opt_matches("^[0-9]+$"),
    -- name = validators.equals_any_of({ "John Doe", "Mallory", "Alice", "Bob" }),
    -- admin = validators.equals_any_of(true),
}

local jwt_obj = auth:check(claim_spec)

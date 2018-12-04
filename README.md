# circle

Circle app deployment repo

## config

### music

Save music directory and link it to `/music` in nginx container.

### JWT key

We will need to create `nginx/jwt/public.pem` file and we have to sign token with `nginx/jwt/private.pem`.

You will need to create a key to use in JWT:

```bash
cd nginx/jwt/
# create private key
openssl genrsa -out private.pem 2048
# create public key
openssl rsa -in private.pem -outform PEM -pubout -out public.pem
```

### Test example

```bash
curl -H "Authorization:circle-token eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.s_Pel7w_r6o7xkS73DUXO3EeIOoj0rxAZvQ1m8aCT5lN1AnMGcdqfpkkhVlo4IyMUwCWOOkslRY1jlz27PSWNLzD1WXiVvzBvTuig-WFrldcsUhi5d2Vy9Yzqzo8DZEfqr86552_YzT1g3GQzZJ5ugDbxg5CMbFCDuGysNhCp0itUKNHQcZ9WIiHq7oRkZItbMXLkVohbFxiOoVFihy0p3Cv3cGs3qVdkQ7oVOvSk1n_BbLqVfB0Ra6jodZg02Mf0SG16joewx_dDrECsw1ofG7r2429LwQPk3oo76JCfHURE3WzS22cUYhDzrjTSfJZCDZxL52UyS_AhsTnPtGiNg" localhost:80/file-browser/ -i
```

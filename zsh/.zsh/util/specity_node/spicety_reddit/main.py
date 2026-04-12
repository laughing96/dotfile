import browser_cookie3
import json
cj = browser_cookie3.chrome(domain_name='.reddit.com')
cookie = ';'.join(f'{c.name}={c.value}' for c in cj)
res = {
    'cookie': cookie
}
print(json.dumps(res))

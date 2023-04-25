import requests

url = 'http://localhost'

try:
    response = requests.get(url)
    if response.status_code == 200:
        print('URL is up and running')
    else:
        print(f'URL returned a {response.status_code} status code')
except requests.ConnectionError:
    print('URL is unreachable')
import requests
import time
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

urls_file = 'urls.txt'
slack_token = 'xoxb-1888268564902-5177890087124-PN2bnbdnSg8nmQcrUveCtuVB' #'xoxb-1888268564902-5153819784950-I4byQrtS2HraiZJIcNZplRCy'  #'xoxb-1888268564902-5153819784950-ZhS9atWCEq2A7Kj6zXf3vsH3'
slack_channel = 'general'
statuses = {}

client = WebClient(token=slack_token)

while True:
    with open(urls_file) as f:
        urls = f.read().splitlines()

    for url in urls:
        try:
            response = requests.get(url)
            if response.status_code == 200:
                new_status = f'URL {url} is up and running'
            else:
                new_status = f'URL {url} returned a {response.status_code} status code'
        except requests.ConnectionError:
            new_status = f'URL {url} is unreachable'

        if url not in statuses or new_status != statuses[url]:
            statuses[url] = new_status
            try:
                response = client.chat_postMessage(channel=slack_channel, text=new_status)
                print(f'Slack notification sent: {new_status}')
            except SlackApiError as e:
                print(f'Slack API error: {e}')

    time.sleep(300) # sleep for 5 minutes
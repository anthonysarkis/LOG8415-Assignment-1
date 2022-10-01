import requests
import time
import os


def thread1_requests(url, headers):
    for i in range(1000):
        requests.get(url, headers=headers)


def thread2_requests(url, headers):
    for i in range(500):
        requests.get(url, headers=headers)

    time.sleep(60)

    for i in range(1000):
        requests.get(url, headers=headers)


if __name__ == '__main__':
    url = "http://" + os.environ['url']
    headers = {"content-type": "application/json"}

    thread1_requests(url, headers)
    thread2_requests(url, headers)
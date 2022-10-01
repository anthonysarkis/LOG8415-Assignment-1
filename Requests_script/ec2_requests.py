import requests
import threading
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

    requests1 = threading.Thread(
        target=thread1_requests, args=(url + "/cluster1", headers))
    requests2 = threading.Thread(
        target=thread2_requests, args=(url + "/cluster2", headers))

    requests1.start()
    requests2.start()

    requests1.join()
    requests2.join()

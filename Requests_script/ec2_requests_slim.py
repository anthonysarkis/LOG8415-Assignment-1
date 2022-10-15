# docker image build -f Dockerfile_requests_slim -t ec2_requests_slim .
# docker run -e url="htiz:amazon.foss" -e invert=False ec2_requests_slim

import requests
import threading
import time
import os

def thread1_requests(url, headers):
    print("Start of thread 1")

    for i in range(10):
        r = requests.get(url, headers=headers)
        print("Thread1 #", i, ":", r.status_code, r.text, "to cluster 1")

    print("End of thread1")


def thread2_requests(url, headers):
    print("Start of thread 2")

    for i in range(5):
        r = requests.get(url, headers=headers)
        print("Thread2:", i, ":", r.status_code, r.text, "to cluster 2")

    print("Delay 10 seconds")
    time.sleep(10)

    for i in range(10):
        r = requests.get(url, headers=headers)
        print("Thread2 #", i, ":", r.status_code, r.text, "to cluster 2")
    
    print("End of thread2")


if __name__ == '__main__':
    time.sleep(30)

    url = "http://" + os.environ['url']
    headers = {"content-type": "application/json"}

    r1 = threading.Thread(target=thread1_requests, args=(url + "/cluster1", headers))
    r2 = threading.Thread(target=thread2_requests, args=(url + "/cluster2", headers))

    r1.start()
    r2.start()

    r1.join()
    r2.join()

    print()
    print("End of first wave")
    print()

    if os.environ['invert']:
        r1 = threading.Thread(target=thread1_requests, args=(url + "/cluster2", headers))
        r2 = threading.Thread(target=thread2_requests, args=(url + "/cluster1", headers))

        r1.start()
        r2.start()

        r1.join()
        r2.join()

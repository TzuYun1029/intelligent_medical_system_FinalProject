# !/usr/bin/env python
# _*_coding:utf-8_*_

#客戶端 ，用來呼叫service_Server.py
import socket
import sys
import struct
### Don't touch
def askForService(token,data):
    # HOST, PORT 記得修改
    global HOST
    global PORT
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    received = ""
    try:
        sock.connect((HOST, PORT))
        msg = bytes(token+"@@@"+data, "utf-8")
        msg = struct.pack(">I", len(msg)) + msg
        sock.sendall(msg)
        received = str(sock.recv(1024), "utf-8")
    finally:
        sock.close()
    return received
### Don't touch

def process(token,data):
    # 可在此做預處理

    # 送出
    result = askForService(token,data)
    # 可在此做後處理

    return result

global HOST
global PORT
HOST, PORT = "140.116.245.149", 27002
# token = "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MDUyMzAzMzIsImlhdCI6MTY0MjE1ODMzMiwic3ViIjoiIiwiYXVkIjoid21ta3MuY3NpZS5lZHUudHciLCJpc3MiOiJKV1QiLCJ1c2VyX2lkIjoiMjk5IiwibmJmIjoxNjQyMTU4MzMyLCJ2ZXIiOjAuMSwic2VydmljZV9pZCI6IjEwIiwiaWQiOjQyNywic2NvcGVzIjoiMCJ9.mQgZ36wk8_G77l54ycPdQKDcVTOVyBHL3IDPerKpqj0hFfYMBx7x6Skuh5oHm2F9EvSOZhTZ6Tupyz5ZpUyN32p3acusuI2DBiWCxLDvQQrOuAZnfH5m5atmK_lj-PMZkLSAAz1uVnHXIjJetwrya1WOZmG6-ZSFxKNsok8OhN8"
# data = "我腹肚"
# for i in range(1):print("Client : ",process(token,data))
# token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJpZCI6MjAsInVzZXJfaWQiOiIzIiwic2VydmljZV9pZCI6IjIiLCJzY29wZXMiOiIwIiwic3ViIjoiIiwiaWF0IjoxNTM2NDgyNTIyLCJuYmYiOjE1MzY0ODI1MjIsImV4cCI6MTU2ODAxODUyMiwiaXNzIjoiSldUIiwiYXVkIjoid21ta3MuY3NpZS5lZHUudHciLCJ2ZXIiOjAuMX0.pFUwhNkqcM32kKjIN17EMSIzq3nQLWXq7Ed-MTn6Tq-TrOUeRcmPm1MC42gg_5KkdtcDqP6UEHtPE7VyB9_28LLvNLihfgP8sby9oAL8_aBc6fxFywyadZbV_D_fyYHViYKyKjUjrMYYFOgFzLSJuQcTsjINmWB2O33YPQB2rXo"
# data = "Manners maketh man."
# for i in range(1):print("Client : ",process(token,data))
# token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJpZCI6MjEsInVzZXJfaWQiOiIzIiwic2VydmljZV9pZCI6IjMiLCJzY29wZXMiOiIwIiwic3ViIjoiIiwiaWF0IjoxNTM2NDgyNTI0LCJuYmYiOjE1MzY0ODI1MjQsImV4cCI6MTU2ODAxODUyNCwiaXNzIjoiSldUIiwiYXVkIjoid21ta3MuY3NpZS5lZHUudHciLCJ2ZXIiOjAuMX0.IlAGrnwzWptJUB7SmLerMaWr0Yd2TVHC0PV_s9O5zcBZa-zGl97p837c5J9D3oADkCqg6pRkMCLpkh-UlB8gBGgba0aYJKiE5KMOGVCLtg-WG0zu0Im6Opy0Lky1Pxy_swFrkKDv7o3fWhiKX4-kqV1dKxzR0qcrwQdcp4KvJhc"
# data = "Manners maketh man."
# for i in range(1):print("Client : ",process(token,data))

@echo off
curl -k -XPOST https://api.pushover.net/1/messages.json ^
    -d user=u2ZHW5XdXfKKnfRmWCSADiwt7H9cy5 ^
    -d token=a7rShXWiSmzvkED8frUuwTQrktcm2a ^
    -d message="%*"

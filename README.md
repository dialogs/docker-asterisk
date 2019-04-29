## Docker for asterisk + WebRTC

Use `docker build -t dialog/asterisk .` to create the image,

Run the container with `./run`

To create your own certificates
```
mkdir /etc/asterisk/keys
cd asterisk-15.4.0/contrib/scripts/
./ast_tls_cert -C sip.dialog.im -O "Dialog SIP" -d /etc/asterisk/keys
```

Try with https://www.doubango.org/sipml5/call.htm using

### Registration

| Field | Value |
| --- | --- |
| Display Name | 199 |
| Private Identity | 199 |
| Public Identity | sip:199@DOCKER_IP_ADDRESS |
| Password | 199 |
| Realm | asterisk |

### Expert settings

| Field | Value |
| --- | --- |
| Disable Video |true |
| WebSocket Server URL | wss://DOCKER_IP_ADDRESS:8089/ws |
| ICE Servers | [{url: 'stun://stun.l.google.com:19302'}] |

### Call control

| Extension | result |
| --- | --- |
| 1000 | for welcome message |
| 1001 | for echo |

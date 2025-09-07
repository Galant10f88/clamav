# ClamAV daemon in Docker

This image runs ClamAV clamd (TCP) with sane defaults for containers.

## Build

`powershell
# From this folder
 docker build -t clamav-tcp .
``n
## Run

`powershell
# Expose TCP 3310 and mount a host folder at /scan if you want to scan host files
 docker run -d --name clamav -p 3310:3310 -v C:\Users\bronc\Desktop\clamav:/scan clamav-tcp
``n
The container primes signatures at build time and updates on start. It listens on TCP 3310.

## Health check

`powershell
# Expect PONG
 echo PING | ncat 127.0.0.1 3310
``n
If you do not have ncat, use PowerShell:

`powershell
 = New-Object System.Net.Sockets.TcpClient('127.0.0.1',3310);
 = .GetStream();
 = [System.Text.Encoding]::ASCII.GetBytes('PING
');
.Write(,0,.Length);
 = New-Object byte[] 1024;
 = .Read(,0,.Length);
[System.Text.Encoding]::ASCII.GetString(,0,)
.Close()
``n
## Scan files

Option A: Mount files into the clamd container and exec clamdscan:

`powershell
# Run container with volume (shown above), then:
 docker exec -it clamav clamdscan --config-file=/etc/clamav/clamd.conf /scan
``n
Option B: Use a temporary client container that shares the network with the server container:

`powershell
 docker run --rm --network container:clamav -v C:\Users\bronc\Desktop\clamav:/scan clamav/clamav:1.3 clamdscan --config-file=/etc/clamav/clamd.conf /scan
``n
Note: On Windows, host networking is limited for Linux containers. Using --network container:clamav avoids host-network issues.

## Config

See clamd.conf for tuned limits (40G stream/file/scan) and TCP settings.

## License

MIT


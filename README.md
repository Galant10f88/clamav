# ClamAV daemon in Docker

This image runs ClamAV clamd (TCP) with sane defaults for containers.

## Build

```powershell
# From this folder
 docker build -t clamav-tcp .
```

## Run

```powershell
# Expose TCP 3310 and mount a host folder at /scan if you want to scan host files
 docker run -d --name clamav -p 3310:3310 -v ${PWD}:/scan clamav-tcp
```

The container primes signatures at build time and updates on start. It listens on TCP 3310.

## Health check

```powershell
# Expect PONG
 echo PING | ncat 127.0.0.1 3310
```

If you do not have ncat, use PowerShell:

```powershell
$tcp = New-Object System.Net.Sockets.TcpClient('127.0.0.1',3310);
$stream = $tcp.GetStream();
$bytes = [System.Text.Encoding]::ASCII.GetBytes("PING`r`n");
$stream.Write($bytes,0,$bytes.Length);
$buf = New-Object byte[] 1024;
$read = $stream.Read($buf,0,$buf.Length);
[System.Text.Encoding]::ASCII.GetString($buf,0,$read)
$tcp.Close()
```

## Scan files

Option A: Mount files into the clamd container and exec clamdscan:

```powershell
# Run container with volume (shown above), then:
 docker exec -it clamav clamdscan --config-file=/etc/clamav/clamd.conf /scan
```

Option B: Use a temporary client container that shares the network with the server container:

```powershell
 docker run --rm --network container:clamav -v ${PWD}:/scan clamav/clamav:1.3 clamdscan --config-file=/etc/clamav/clamd.conf /scan
```

Note: On Windows, host networking is limited for Linux containers. Using `--network container:clamav` avoids host-network issues.

## Railway deployment

- The container will listen on the `$PORT` environment variable provided by Railway (defaults to 3310 when not set).
- No custom start command is required. Railway should build the Dockerfile and run the container.
- Ensure you expose the service externally if you plan to connect from another service.

```text
Service: Dockerfile
Port: $PORT (Railway sets this automatically)
```

## Config

See `clamd.conf` for tuned limits (40G stream/file/scan) and TCP settings.

## License

MIT
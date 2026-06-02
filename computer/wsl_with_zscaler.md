# WSL with ZScaler

# Issue

When you use WSL with ZScaler, sometimes you might suffer from the issue that you cannot download files from repositories. Here is How I solved it.

# Symptoms

When you run the command `sudo docker run hello-world` in WSL, you might get the following error:

```bash
$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
docker: failed to copy: httpReadSeeker: failed open: failed to do request: Get "
https://docker-images-prod.6aa30f8b08e16409b46e0173d6de2f56.r2.cloudflarestorage.com/
registry-v2/docker/registry/v2/blobs/sha256/1b/
1b44b5a3e06a9aae883e7bf25e45c100be0bb81a0e01b32de604f3ac44711634/
data?X-Amz-Algorithm=AWS4-HMAC-SHA256&
X-Amz-Credential=f1baa2dd9b876aeb89efebbfc9e5d5f4%2F20251202%2Fauto%2Fs3%2Faws4_request&
X-Amz-Date=20251202T034442Z&
X-Amz-Expires=1200&
X-Amz-SignedHeaders=host&
X-Amz-Signature=8b77d11de5f71e8920a5b0cb5fbf462114027bfc3f6e579a14c82a774eff4a78%22:
tls: failed to verify certificate: x509: certificate signed by unknown authority

Run 'docker run --help' for more information
```

Test if your https doesn't work. Run the commands `curl https://www.google.com/` and `curl http://www.google.com/`. You should get nothing with the first one and with the second one something returns. `CTRL-C` to cancel the command after waiting for a while nothing is returned from commands.\
Note that sometimes the curl works well but your other applications don't work.\

# Solution

## On Windows

Go to `certmgr.msc`\
`Trusted Root Certification Authorities/Certificates/ZScaler Root CA`
Double click on it. `Details` -> `Copy to file` -> `DER encoded binary X.509 (.CER)` -> save it

## On Linux

Use the following command to add the ZScaler Root CA to your Linux machine.

```bash
openssl x509 -inform DER -in /path/to/your/cert -out /usr/local/share/ca-certificates/zscaler.crt
```

sudo permission is required. Change `/path/to/your/cert to` the path that you saved the cert on Windows.\
For example, if you save the cert in `C:\User\John\Downloads\zscaler.cert` then it is in `\mnt\c\User\John\Downloads\zscaler.cert` in the WSL environment.\
Use the command `update-ca-certificates` to update your cert on Linux.\
Test the command `curl https://www.google.com/`. You should get something returned this time. This means the connection via https is fixed now.\

## On Windows again

But docker service hasn't gotten the new cert yet. So restart your Linux again with the command `wsl --shutdown`

## On Linux again

`docker run hello-world` should work now.

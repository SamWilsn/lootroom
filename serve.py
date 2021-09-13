#!/usr/bin/env python3

from http.server import HTTPServer, SimpleHTTPRequestHandler
import ssl


class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs, directory="docs")


httpd = HTTPServer(('0.0.0.0', 4443), Handler)

httpd.socket = ssl.wrap_socket(
    httpd.socket,
    keyfile="notes/key.pem",
    certfile="notes/cert.pem",
    server_side=True
)

httpd.serve_forever()

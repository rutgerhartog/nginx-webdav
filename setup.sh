#!/bin/sh 
mkdir -p /data && chown -R nginx:nginx /data 

cat > /etc/nginx/http.d/default.conf <<EOF 
server {
    listen 8000;
    root /data;

    location / {
        dav_methods PUT DELETE MKCOL COPY MOVE;
        dav_ext_methods PROPFIND OPTIONS;
        dav_access user:rw group:rw all:rw;

        client_max_body_size 0;
        create_full_put_path on;
        client_body_temp_path /tmp/;

    }
}
EOF


cat > /etc/nginx/nginx.conf << EOF 
worker_processes auto;
pcre_jit on;
error_log /dev/stderr warn;
include /etc/nginx/modules/*.conf;
events {
        worker_connections 1024;
}
http {
        include /etc/nginx/mime.types;
        default_type application/octet-stream;
        server_tokens off;
        client_max_body_size 1m;
        sendfile on;
        tcp_nopush on;
        gzip on;
        gzip_vary on;
        include /etc/nginx/http.d/*.conf;
}
EOF
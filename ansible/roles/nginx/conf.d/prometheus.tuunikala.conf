server {
        listen 80;
        listen [::]:80;
        server_name prometheus.tuunikala.com;
        return 301 https://$server_name$request_uri;
}
server {
        listen 443 ssl;
        listen [::]:443 ssl;
        server_name prometheus.tuunikala.com;

        include /etc/nginx/snippets/ssl-tuunikala.conf;

        location / {
          proxy_pass http://10.0.1.167:9090;
          include /etc/nginx/snippets/proxy-headers.conf;
        }

}

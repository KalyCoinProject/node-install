# RPC Node Installation

This guide will help you set up a KalyChain RPC node that provides API access for applications and services.

> **Prerequisites:** This guide assumes you have completed the [Server Setup](server-setup.md) guide for security hardening.

We provide this guide to encourage developers to run their own RPC nodes whenever possible. KalyChain community members who wish to support the network can run an RPC node to provide additional public RPC endpoints.


## Getting Started

Follow the [Regular Node Installation Guide](regular-node.md) just as you would with a regular node, except change the kalynode.service file line:

```sh
ExecStart=/home/$USER/node/../kaly/bin/besu --config-file=/home/$USER/node-install/configs/regular/config.toml
```

To this so it reads the proper _config.toml_ file for RPC nodes:

```sh
ExecStart=/home/$USER/node/../kaly/bin/besu --config-file=/home/$USER/node-install/configs/rpc/config.toml
```

{% hint style="info" %} :fire: **Pro Tip** The included a bash script *start_node.sh* is already setup to start your node with RPC services. Make the file exicutable by running *chmod +x start_node.sh*
{% endhint %}

## Point your Domain

To use a domain name with your RPC service you'll need to create an A record that points to your node's IP address. Sub-doamins are also allowed.

[NameCheap Guide](https://www.namecheap.com/support/knowledgebase/article.aspx/319/2237/how-can-i-set-up-an-a-address-record-for-my-domain/)
[GoDaddy Guide](https://www.godaddy.com/help/add-an-a-record-19238)

## Setup Nginx Reverse Proxy  

Install Nginx

```sh
sudo apt install nginx
```

Adjust your firewall rules

```sh
sudo ufw allow 'Nginx FULL'
```

Create a server block so Nginx can serve RPC and WS calls, replace *your_domain* with the domain name you pointed to the server.

```sh
sudo nano /etc/nginx/sites-available/your_domain
```

Paste in the following configuration

```sh
server {
  server_name rpc3.kalychain.io;

  location ^~ /ws {
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-NginX-Proxy true;
    proxy_pass http://0.0.0.0:8546/;
  }

  location ^~ /rpc {
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-NginX-Proxy true;
    proxy_pass http://0.0.0.0:8545/;
  }
}
```
{% hint style="warning" %}
Dont forget replace *your_domain* with your domain name before saving
{% endhint %}

Create a link from the file to the *sites-enabled* directory

```sh
sudo ln -s /etc/nginx/sites-available/rpc2.kalychain.io /etc/nginx/sites-enabled/
```

Test to make sure that there are no syntax errors in your Nginx files

```sh
sudo nginx -t
```
If there are no errors restart Nginx to enable the changes

```sh
sudo systemctl restart nginx
```

## Get a free SSL certificate with Let's Encrypt

Install Certbot and the Nginx plugin

```sh
sudo apt install certbot python3-certbot-nginx
```

Get the SSL Cert for your domain 

```sh
sudo certbot --nginx -d rpc3.kalychain.io
```

If that’s successful, certbot will ask how you’d like to configure your HTTPS settings.

```sh
Output
Please choose whether or not to redirect HTTP traffic to HTTPS, removing HTTP access.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
1: No redirect - Make no further changes to the webserver configuration.
2: Redirect - Make all requests redirect to secure HTTPS access. Choose this for
new sites, or if you're confident your site works on HTTPS. You can undo this
change by editing your web server's configuration.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate number [1-2] then [enter] (press 'c' to cancel):

```

Select your choice then hit ENTER

A message telling you the process was successful and where your certificates are stored will show on screen:

```sh
Output
IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/example.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/example.com/privkey.pem
   Your cert will expire on 2020-08-18. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot again
   with the "certonly" option. To non-interactively renew *all* of
   your certificates, run "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le

```

## Share your new RPC service

For JSON-RPC calls use:

```sh
https://example.com/rpc
```
For WebSocet use:

```sh
https://example.com/ws
```
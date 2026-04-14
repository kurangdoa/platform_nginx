# platform_nginx
nginx deployment for kurangdoa platform

## 🔒 SSL & The "Chicken and Egg" Nginx Problem

When setting up this project on a new server for the first time, you will run into a classic "Chicken and Egg" problem with Nginx and Let's Encrypt (Certbot).

**The Problem:**
* **Nginx** will crash and refuse to start if it is told to listen on port 443 (HTTPS) but the SSL certificates don't exist on the server yet.
* **Certbot** cannot generate those SSL certificates for you unless Nginx is successfully running on port 80 (HTTP) to prove you own the domain. 

**The Solution: The 3-Step Dance**
To successfully deploy this, you must run the setup in three stages:

### Step 1: Start with HTTP Only
Before running `docker compose up -d` for the Proxy Gateway, open the `nginx.conf` file and make sure the HTTPS (`listen 443 ssl;`) server blocks are completely commented out (hidden behind `#` symbols). 

Start the containers. Nginx will boot up happily on port 80.

This is made simple with the `make up_start`

### Step 2: Generate the Certificates
With Nginx running on port 80, run your Certbot command. Certbot will safely talk to Let's Encrypt, verify your domain, and download the `.pem` certificate files onto your server.

#### the certbot command looks like this
```
docker run -it --rm --name certbot \
  -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
  -v "$(pwd)/certbot/www:/var/www/certbot" \
  certbot/certbot certonly \
  --webroot -w /var/www/certbot \
  -d movie-trip.kurangdoa.com \
  --email rando.bayor@gmail.com \
  --agree-tos \
  --no-eff-email
```

or made simple with `make cert-init-all`

#### restart nginx

Restart Nginx to apply the changes:
```bash
docker compose restart nginx
```

### Step 3: Activate HTTPS
Now that the certificate files actually exist on your hard drive, open `nginx.conf` again and **uncomment** the HTTPS blocks (remove the `#` symbols). 

or made simple by doing `make down_start` and then `make up`


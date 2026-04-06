# platform_nginx
nginx deployment for kurangdoa platform

### 🔒 SSL & The "Chicken and Egg" Nginx Problem

When setting up this project on a new server for the first time, you will run into a classic "Chicken and Egg" problem with Nginx and Let's Encrypt (Certbot).

**The Problem:**
* **Nginx** will crash and refuse to start if it is told to listen on port 443 (HTTPS) but the SSL certificates don't exist on the server yet.
* **Certbot** cannot generate those SSL certificates for you unless Nginx is successfully running on port 80 (HTTP) to prove you own the domain. 

**The Solution: The 3-Step Dance**
To successfully deploy this, you must run the setup in three stages:

#### Step 1: Start with HTTP Only
Before running `docker compose up -d` for the Proxy Gateway, open the `nginx.conf` file and make sure the HTTPS (`listen 443 ssl;`) server blocks are completely commented out (hidden behind `#` symbols). 

Start the containers. Nginx will boot up happily on port 80.

#### Step 2: Generate the Certificates
With Nginx running on port 80, run your Certbot command. Certbot will safely talk to Let's Encrypt, verify your domain, and download the `.pem` certificate files onto your server.

#### Step 3: Activate HTTPS
Now that the certificate files actually exist on your hard drive, open `nginx.conf` again and **uncomment** the HTTPS blocks (remove the `#` symbols). 

Restart Nginx to apply the changes:
```bash
docker compose restart nginx
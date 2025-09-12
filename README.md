# Nginx Proxy Container

Containerized nginx reverse proxy with unified authentication for multiple services.

## Services Proxied

- `/code/` - Code Server (port 8080)
- `/vnc/` - Browser VNC (port 8001)  
- `/terminal/` - Web Terminal/ttyd (port 7681)
- `/browser-viewer/` - Playwright Browser Viewer (port 6080)

## Quick Start

### 1. Initial Setup

```bash
# Stop existing nginx if running
sudo systemctl stop nginx

# Start the container
docker-compose up -d

# View logs
docker-compose logs -f
```

### 2. Rebuild After Changes

```bash
docker-compose down
docker-compose build
docker-compose up -d
```

## Configuration

### SSL Certificates

Currently using self-signed certificates. To generate new ones:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ssl/nginx-selfsigned.key \
  -out ssl/nginx-selfsigned.crt
```

### Authentication

Uses basic auth with htpasswd file. Manage users:

```bash
# Add new user
htpasswd nginx/.htpasswd newuser

# Change password
htpasswd nginx/.htpasswd existinguser

# Remove user
htpasswd -D nginx/.htpasswd username
```

### Modify Proxy Routes

Edit `nginx/conf.d/secure-proxy.conf` and rebuild:

```bash
docker-compose restart
```

## File Structure

```
nginx-proxy/
├── Dockerfile
├── docker-compose.yml
├── nginx/
│   ├── conf.d/
│   │   └── secure-proxy.conf
│   └── .htpasswd
└── ssl/
    ├── nginx-selfsigned.crt
    └── nginx-selfsigned.key
```

## Environment Variables

You can create a `.env` file for configuration:

```env
# Example .env file
HTTP_PORT=80
HTTPS_PORT=443
```

## Troubleshooting

### Container can't reach host services

Ensure services are listening on all interfaces (0.0.0.0) not just localhost (127.0.0.1).

### Permission issues

```bash
chmod 644 nginx/.htpasswd
chmod 644 ssl/*.crt
chmod 600 ssl/*.key
```

### View container logs

```bash
docker-compose logs nginx-proxy
```

## Security Notes

1. **SSL Certificates**: Replace self-signed certs with proper ones for production
2. **Passwords**: Use strong passwords in htpasswd
3. **Firewall**: Ensure only necessary ports are exposed
4. **Updates**: Keep nginx image updated

## Git Repository Setup

```bash
cd /root/nginx-proxy
git init
git add .
git commit -m "Initial nginx proxy container setup"
```
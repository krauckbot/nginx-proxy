FROM nginx:alpine

# Copy nginx configuration
COPY nginx/conf.d/ /etc/nginx/conf.d/
COPY nginx/.htpasswd /etc/nginx/.htpasswd

# Copy SSL certificates
COPY ssl/ /etc/nginx/ssl/

# Ensure proper permissions
RUN chmod 644 /etc/nginx/.htpasswd && \
    chmod 644 /etc/nginx/ssl/nginx-selfsigned.crt && \
    chmod 600 /etc/nginx/ssl/nginx-selfsigned.key

# Expose ports
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
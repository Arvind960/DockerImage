FROM nginx:latest

# Install curl and wget in a single RUN command with cleanup to keep image size small
RUN apt-get update && \
    apt-get install -y curl wget && \
    rm -rf /var/lib/apt/lists/*

# Copy custom nginx configuration (overwrite default.conf)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the HTML page directly (no need to mkdir since the directory exists in nginx image)
COPY index.html /usr/share/nginx/html/

# Expose port 80 (default Nginx port)
EXPOSE 80

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]

FROM nginx:latest

# Update package lists and install basic utilities
RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Create a simple HTML page
RUN mkdir -p /usr/share/nginx/html
COPY index.html /usr/share/nginx/html/

# Expose port 8081
EXPOSE 8081

# Command to run when container starts
CMD ["nginx", "-g", "daemon off;"]

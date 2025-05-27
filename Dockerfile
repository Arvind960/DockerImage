FROM ubuntu:20.04

# Update package lists and install basic utilities
RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    git \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Create a non-root user
RUN useradd -m dockeruser
USER dockeruser

# Command to run when container starts
CMD ["bash"]

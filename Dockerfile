# Accept the Ubuntu version as an argument. Default to "latest" if not specified
ARG UBUNTU_VERSION=latest

# Use the specified Ubuntu version as the base image
FROM ubuntu:${UBUNTU_VERSION}

# Install dependencies
RUN apt-get update -qq && apt-get install -y curl git docker.io && rm -rf /var/lib/apt/lists/*

# Install act
RUN curl -sL https://raw.githubusercontent.com/nektos/act/master/install.sh | bash

# Set the working directory
WORKDIR /github/workspace

# Default command
CMD ["act"]

ARG FROM=ubuntu:latest
FROM ${FROM}
RUN apt-get update -qq && apt-get install -y curl git docker.io && rm -rf /var/lib/apt/lists/* && curl -sL https://raw.githubusercontent.com/nektos/act/master/install.sh | bash
WORKDIR /github/workspace
CMD ["act"]

FROM stedolan/jq as jq
FROM chef/inspec:4.35.1

LABEL maintainer=zaslow \
      version=0.0.2

# Install AWS CLI
RUN apt-get update && \
    apt-get install -y curl unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    apt-get remove -y curl unzip

# Get jq executable
COPY --from=jq /usr/local/bin/jq /usr/local/bin/jq

COPY . /usr/local/src
WORKDIR /usr/local/src

ENTRYPOINT ./docker-entrypoint.sh

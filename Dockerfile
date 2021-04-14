FROM stedolan/jq as jq
FROM chef/inspec:4.32.0

# Install aws-cli & dependencies
ENV AWS_CLI_VERSION 2.0.30
RUN apt-get update && \
	apt-get install -y groff unzip && \
	wget -c "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -O "awscliv2.zip" && \
	unzip awscliv2.zip && \
	./aws/install

# Get jq executables
COPY --from=jq /usr/local/bin/jq /usr/local/bin/jq

COPY . /usr/local/src
WORKDIR /usr/local/src

ENTRYPOINT ./docker-entrypoint.sh

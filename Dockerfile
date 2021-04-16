FROM stedolan/jq as jq
FROM hashicorp/terraform:0.15.0 as terraform
FROM chef/inspec:4.32.0

LABEL maintainer=zaslow \
      version=0.0.1

# Install aws-cli & dependencies
ENV AWS_CLI_VERSION 2.0.30
RUN apt-get update && \
    apt-get install -y groff unzip && \
    wget -c "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -O "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Get jq & terrafrom executables
ENV EXEC_DIR /usr/local/bin
COPY --from=jq $EXEC_DIR/jq $EXEC_DIR/jq
COPY --from=terraform /bin/terraform $EXEC_DIR/terraform

ENV SRC_DIR /usr/local/src
COPY . $SRC_DIR
WORKDIR $SRC_DIR

ENTRYPOINT ./docker-entrypoint.sh

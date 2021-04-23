FROM zaslowd/aws-cli-jq:0.0.1

LABEL maintainer=zaslow \
      version=0.0.1

# Install Chef InSpec
RUN curl https://omnitruck.chef.io/install.sh | bash -s -- -P inspec

COPY . /usr/local/src
WORKDIR /usr/local/src

ENTRYPOINT ./docker-entrypoint.sh

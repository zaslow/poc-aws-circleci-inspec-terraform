FROM hashicorp/terraform:0.15.0 as terraform
FROM zaslowd/aws-cli-jq:0.0.1

LABEL maintainer=zaslow \
      version=0.0.1

# Get jq & terrafrom executables
COPY --from=terraform /bin/terraform /usr/local/bin/terraform

ENV SRC_DIR /usr/local/src
COPY ./tf $SRC_DIR
COPY ./docker-entrypoint.tf.sh $SRC_DIR/docker-entrypoint.sh
WORKDIR $SRC_DIR

ENTRYPOINT ./docker-entrypoint.sh

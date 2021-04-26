FROM stedolan/jq as jq
FROM hashicorp/terraform:0.15.0 as terraform
FROM amazon/aws-cli:2.1.39

LABEL maintainer=zaslow \
      version=0.0.2

# Get jq & terrafrom executables
ENV EXEC_DIR /usr/local/bin
COPY --from=jq $EXEC_DIR/jq $EXEC_DIR/jq
COPY --from=terraform /bin/terraform $EXEC_DIR/terraform

ENV SRC_DIR /usr/local/src
COPY ./tf $SRC_DIR
COPY ./docker-entrypoint.tf.sh $SRC_DIR/docker-entrypoint.sh
WORKDIR $SRC_DIR

ENTRYPOINT ./docker-entrypoint.sh

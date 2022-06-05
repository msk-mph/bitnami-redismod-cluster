FROM redislabs/redisearch:latest as redisearch
FROM redislabs/redisgraph:latest as redisgraph
FROM redislabs/rejson:latest as rejson
FROM redislabs/rebloom:latest as rebloom
FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "anyili <anyili0928@gmail.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ENV LD_LIBRARY_PATH /usr/lib/redis/modules

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libssl1.1 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redis" "6.2.7-0" --checksum 555683fb888226648a27b72f4ebce7f998a35aa7fadc64101886923d277f0144
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y &&  apt-get -q install -y libgomp1 && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY --from=redisearch ${LD_LIBRARY_PATH}/redisearch.so ${LD_LIBRARY_PATH}/
COPY --from=redisgraph ${LD_LIBRARY_PATH}/redisgraph.so ${LD_LIBRARY_PATH}/
COPY --from=rejson ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=rebloom ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/


COPY rootfs /
RUN /opt/bitnami/scripts/redis-cluster/postunpack.sh
ENV APP_VERSION="6.2.7" \
    BITNAMI_APP_NAME="redis-cluster" \
    PATH="/opt/bitnami/redis/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 6379

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/redis-cluster/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redis-cluster/run.sh", \
    "--loadmodule", "/usr/lib/redis/modules/redisearch.so", \
    "--loadmodule", "/usr/lib/redis/modules/redisgraph.so", \
    "--loadmodule", "/usr/lib/redis/modules/rejson.so", \
    "--loadmodule", "/usr/lib/redis/modules/redisbloom.so"]

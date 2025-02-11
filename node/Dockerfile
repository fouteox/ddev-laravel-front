FROM node:22-slim

ARG uid=0
ARG gid=0

WORKDIR /app

USER root

RUN if [ "$uid" != 0 ]; then \
    if getent group "$gid" > /dev/null; then \
        moved_group_id="99$gid"; \
        existing_group_name=$(getent group "$gid" | cut -d: -f1); \
        groupmod -g "$moved_group_id" "$existing_group_name"; \
    fi && \
    if getent passwd "$uid" > /dev/null; then \
        moved_user_id="99$uid"; \
        existing_username=$(getent passwd "$uid" | cut -d: -f1); \
        usermod -u "$moved_user_id" "$existing_username"; \
    fi && \
    groupmod -g $gid node && \
    usermod -u $uid -g $gid node; \
fi

COPY --link --chmod=755 docker-entrypoint.sh /usr/local/bin/docker-entrypoint

# Drop privileges back to node user
USER node

ENTRYPOINT ["docker-entrypoint"]

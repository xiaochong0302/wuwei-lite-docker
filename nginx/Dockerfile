FROM nginx:1.28-bookworm

RUN if ! getent group www-data > /dev/null; then \
        groupadd -g 33 www-data; \
    fi && \
    if ! getent passwd www-data > /dev/null; then \
        useradd -u 33 -g www-data -s /bin/bash -M www-data; \
    fi

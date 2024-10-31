FROM linuxserver/qbittorrent

RUN apk add --no-cache --virtual .build-deps wget unzip

ARG ARCH
ARG QB_VERSION=4.6.7.10

# 根据架构下载和替换 qbittorrent-nox
RUN cd /tmp && echo $QB_VERSION \
    && case "$ARCH" in \
    "linux/amd64") wget -O qbittorrent.zip https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases/download/release-$QB_VERSION/qbittorrent-enhanced-nox_x86_64-linux-musl_static.zip ;; \
    "linux/arm64") wget -O qbittorrent.zip https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases/download/release-$QB_VERSION/qbittorrent-enhanced-nox_aarch64-linux-musl_static.zip ;; \
    *) echo "Unsupported architecture"; exit 1 ;; esac \
    && echo -e "WebUI\\CSRFProtection=false\nWebUI\\ClickjackingProtection=false\nWebUI\\HostHeaderValidation=false" > /defaults/qBittorrent.conf \
    && rm /usr/bin/qbittorrent-nox \
    && unzip qbittorrent.zip -d /usr/bin \
    && chmod +x /usr/bin/qbittorrent-nox \
    && rm qbittorrent.zip

RUN apk del .build-deps

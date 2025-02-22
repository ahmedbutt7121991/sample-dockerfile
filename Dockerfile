FROM ubuntu:bionic

# === GENERATED BROWSER DEPENDENCIES ===

# (generated with ./updateDockerDeps.js)

# tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb

# chromium
RUN apt-get update && apt-get install -y --no-install-recommends \
    fonts-liberation\
    libasound2\
    libatk-bridge2.0-0\
    libatk1.0-0\
    libatspi2.0-0\
    libcairo2\
    libcups2\
    libdbus-1-3\
    libdrm2\
    libgbm1\
    libglib2.0-0\
    libgtk-3-0\
    libnspr4\
    libnss3\
    libpango-1.0-0\
    libx11-6\
    libxcb1\
    libxcomposite1\
    libxdamage1\
    libxext6\
    libxfixes3\
    libxrandr2

# firefox
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg\
    libatk1.0-0\
    libcairo-gobject2\
    libcairo2\
    libdbus-1-3\
    libdbus-glib-1-2\
    libfontconfig1\
    libfreetype6\
    libgdk-pixbuf2.0-0\
    libglib2.0-0\
    libgtk-3-0\
    libpango-1.0-0\
    libpangocairo-1.0-0\
    libpangoft2-1.0-0\
    libx11-6\
    libx11-xcb1\
    libxcb-shm0\
    libxcb1\
    libxcomposite1\
    libxcursor1\
    libxdamage1\
    libxext6\
    libxfixes3\
    libxi6\
    libxrender1\
    libxt6

# webkit
RUN apt-get update && apt-get install -y --no-install-recommends \
    gstreamer1.0-libav\
    gstreamer1.0-plugins-bad\
    gstreamer1.0-plugins-base\
    gstreamer1.0-plugins-good\
    libatk-bridge2.0-0\
    libatk1.0-0\
    libbrotli1\
    libcairo2\
    libegl1\
    libenchant1c2a\
    libepoxy0\
    libfontconfig1\
    libfreetype6\
    libgdk-pixbuf2.0-0\
    libgl1\
    libgles2\
    libglib2.0-0\
    libgstreamer-gl1.0-0\
    libgstreamer1.0-0\
    libgtk-3-0\
    libharfbuzz-icu0\
    libharfbuzz0b\
    libhyphen0\
    libicu60\
    libjpeg-turbo8\
    libnotify4\
    libopenjp2-7\
    libopus0\
    libpango-1.0-0\
    libpng16-16\
    libsecret-1-0\
    libvpx5\
    libwayland-client0\
    libwayland-egl1\
    libwayland-server0\
    libwebp6\
    libwebpdemux2\
    libwoff1\
    libx11-6\
    libxcomposite1\
    libxdamage1\
    libxkbcommon0\
    libxml2\
    libxslt1.1

# === GENERATED BROWSER DEPENDENCIES END ===

# === INSTALL Node.js ===

# Install node14
RUN apt-get update && apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Feature-parity with node.js base images.
RUN apt-get update && apt-get install -y --no-install-recommends git ssh && \
    npm install -g yarn

# Create the pwuser (we internally create a symlink for the pwuser and the root user)
RUN adduser pwuser

# Install Python 3.8

RUN apt-get update && apt-get install -y python3.8 python3-pip && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# === BAKE BROWSERS INTO IMAGE ===

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# 1. Add tip-of-tree Playwright package to install its browsers.
#    The package should be built beforehand from tip-of-tree Playwright.
# COPY ./playwright.tar.gz /tmp/playwright.tar.gz

# 2. Install playwright and then delete the installation.
#    Browsers will remain downloaded in `/ms-playwright`.
#    Note: make sure to set 777 to the registry so that any user can access
#    registry.
RUN mkdir /ms-playwright && \
    mkdir /tmp/pw && cd /tmp/pw && npm init -y && \
    # npm i /tmp/playwright.tar.gz && \
    npm i playwright && \
    rm -rf /tmp/pw && rm /tmp/playwright.tar.gz && \
    chmod -R 777 /ms-playwright
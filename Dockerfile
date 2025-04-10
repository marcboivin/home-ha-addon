ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail"]

# Install dependencies
RUN "apk add --no-cache \
    ca-certificates \
    wget \
    tzdata"

# Set environment variables
ENV HBOX_MODE=production
ENV HBOX_STORAGE_DATA=/share/homebox/
ENV HBOX_DATABASE_SQLITE_PATH=/share/homebox/homebox.db?_pragma=busy_timeout=2000&_pragma=journal_mode=WAL&_fk=1&_time_format=sqlite

# Download latest release of Homebox or use a specific version
# Using a specific version for stability in this example
ARG HOMEBOX_VERSION=v0.18.0
RUN "mkdir /app"

RUN "wget -O /tmp/homebox.tar.gz https://github.com/sysadminsmedia/homebox/releases/download/${HOMEBOX_VERSION}/homebox_Linux_x86_64.tar.gz"
RUN "tar -xzf /tmp/homebox.tar.gz /app && \
    rm /tmp/homebox.tar.gz && \
    chmod +x /app/homebox"

# Copy our run script
COPY run.sh /
RUN chmod a+x /run.sh

# Expose the port Homebox runs on
EXPOSE 7745

# Healthcheck to verify it's still running
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 -O - http://localhost:7745/api/v1/status || exit 1

# Start Homebox when the container starts
CMD [ "/run.sh" ]
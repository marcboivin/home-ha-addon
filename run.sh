#!/usr/bin/env bashio

# Get configuration values
CONFIG_PATH=/data/options.json
ALLOW_REGISTRATION=$(bashio::config 'allow_registration')
DATABASE_PATH=$(bashio::config 'database_path')
STORAGE_PATH=$(bashio::config 'storage_path')
AUTO_INCREMENT_ASSET_ID=$(bashio::config 'auto_increment_asset_id')
ASSET_ID_PREFIX=$(bashio::config 'asset_id_prefix')
ALLOW_ANALYTICS=$(bashio::config 'allow_analytics')
TIMEZONE=$(bashio::config 'timezone')
CREATE_ADMIN_USER=$(bashio::config 'create_admin_user')
ADMIN_USERNAME=$(bashio::config 'admin_username')
ADMIN_PASSWORD=$(bashio::config 'admin_password')
ADMIN_EMAIL=$(bashio::config 'admin_email')

# Get Home Assistant URL for CORS
HA_URL=$(bashio::supervisor info | jq -r '.data.homeassistant' | sed 's/^http/https/')
HA_HTTP_URL=$(echo "$HA_URL" | sed 's/^https/http/')

# Create directories if they don't exist
mkdir -p "${STORAGE_PATH}"

# Ensure database directory exists with proper permissions
DATABASE_DIR=$(dirname "${DATABASE_PATH}")
mkdir -p "${DATABASE_DIR}"
chmod 755 "${DATABASE_DIR}"

# Log storage locations for debugging
bashio::log.info "Using database path: ${DATABASE_PATH}"
bashio::log.info "Using storage path: ${STORAGE_PATH}"

# Set timezone
export TZ="${TIMEZONE}"

# Create config file
CONFIG_FILE="${STORAGE_PATH}/config.yml"
cat > "${CONFIG_FILE}" << EOF
mode: production
server:
  host: 0.0.0.0
  port: 7745
  cors:
    allowedOrigins:
      - ${HA_URL}
      - ${HA_HTTP_URL}
    allowedMethods:
      - GET
      - POST
      - PUT
      - DELETE
      - OPTIONS
    allowedHeaders:
      - Content-Type
      - Authorization
      - X-Requested-With
    exposedHeaders:
      - Content-Length
    allowCredentials: true
frontend:
  registration: ${ALLOW_REGISTRATION}
database:
  type: sqlite
  sqlite:
    path: ${DATABASE_PATH}?_pragma=busy_timeout=5000&_pragma=journal_mode=WAL&_pragma=synchronous=NORMAL&_fk=1&_time_format=sqlite
storage:
  data: ${STORAGE_PATH}/
assetId:
  autoIncrement: ${AUTO_INCREMENT_ASSET_ID}
  prefix: "${ASSET_ID_PREFIX}"
analytics:
  enabled: ${ALLOW_ANALYTICS}
EOF

# Prepare admin user configuration if enabled
if [ "${CREATE_ADMIN_USER}" = "true" ] && [ -n "${ADMIN_USERNAME}" ] && [ -n "${ADMIN_PASSWORD}" ]; then
  # Create admin user configuration file
  ADMIN_CONFIG_FILE="${STORAGE_PATH}/admin.yml"
  cat > "${ADMIN_CONFIG_FILE}" << EOF
username: ${ADMIN_USERNAME}
password: ${ADMIN_PASSWORD}
email: ${ADMIN_EMAIL}
EOF
  
  # Log admin user creation
  bashio::log.info "Creating admin user configuration..."
  
  # Start Homebox with admin user creation
  cd /app
  exec ./homebox -C "${ADMIN_CONFIG_FILE}" "${CONFIG_FILE}"
else
  # Start Homebox normally
  cd /app
  exec ./homebox "${CONFIG_FILE}"
fi
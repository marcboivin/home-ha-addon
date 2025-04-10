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

# Create directories if they don't exist
mkdir -p "${STORAGE_PATH}"

# Set timezone
export TZ="${TIMEZONE}"

# Create config file
CONFIG_FILE="${STORAGE_PATH}/config.yml"
cat > "${CONFIG_FILE}" << EOF
mode: production
server:
  host: 0.0.0.0
  port: 7745
frontend:
  registration: ${ALLOW_REGISTRATION}
database:
  type: sqlite
  sqlite:
    path: ${DATABASE_PATH}
storage:
  data: ${STORAGE_PATH}/
assetId:
  autoIncrement: ${AUTO_INCREMENT_ASSET_ID}
  prefix: "${ASSET_ID_PREFIX}"
analytics:
  enabled: ${ALLOW_ANALYTICS}
EOF

# Start Homebox
cd /app
exec ./homebox "${CONFIG_FILE}"
# Homebox Home Assistant Addon

This addon lets you run [Homebox](https://github.com/hay-kot/homebox) directly in Home Assistant.

## About Homebox

Homebox is a home inventory management system designed to help you keep track of your items, valuables, and collections with a modern user interface.

## Features

- Track your household items, warranties, receipts, and maintenance tasks
- Generate QR codes for items to easily retrieve information
- Search and filter items by location, label, or custom fields
- Attach files and images to items
- Supports multiple users
- Mobile-friendly web interface
- Runs completely in your Home Assistant environment

## Installation

1. Add this repository to your Home Assistant addon store.
2. Install the Homebox addon.
3. Start the addon.
4. Open the web UI by clicking "Open Web UI" or access it at `http://homeassistant.local:7745`.

## Configuration

| Option | Description |
|--------|-------------|
| allow_registration | Enable/disable user registration |
| database_path | Path to SQLite database file |
| storage_path | Directory to store Homebox data |
| auto_increment_asset_id | Automatically increment asset IDs |
| asset_id_prefix | Optional prefix for asset IDs |
| allow_analytics | Enable/disable anonymous analytics |
| timezone | Set the timezone for date handling |

## First Steps

1. On first launch, register a new account (if registration is enabled).
2. Login with your credentials.
3. Start organizing your items by creating locations and adding items.

## Data Storage

All data is stored in the `/share/homebox` directory by default. This ensures your data persists across addon updates.

For backup purposes, make sure to include the `/share/homebox` directory in your Home Assistant backups.
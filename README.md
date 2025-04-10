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

### Example Configuration

Here's an example configuration with sensible defaults for Home Assistant:

```yaml
allow_registration: true
database_path: "/share/homebox/homebox.db"
storage_path: "/share/homebox"
auto_increment_asset_id: true
asset_id_prefix: "HB-"
allow_analytics: false
timezone: "America/New_York"
```

This configuration:
- Enables new user registration (you can disable after creating your account)
- Stores the database in the `/share/homebox` directory, which persists across updates
- Uses automatic asset ID generation with a "HB-" prefix (e.g., HB-001, HB-002)
- Disables anonymous analytics
- Sets the timezone to Eastern Time (EST/EDT)

The `/share` directory in Home Assistant is ideal for persistent data storage as it's preserved during backups and updates. All file attachments, images, and data will be stored here.

## First Steps

1. On first launch, register a new account (if registration is enabled).
2. Login with your credentials.
3. Start organizing your items by creating locations and adding items.

## Data Storage

All data is stored in the `/share/homebox` directory by default. This ensures your data persists across addon updates.

### Backup and Restore

To ensure your Homebox data is properly backed up:

1. **Home Assistant Backups**: When creating backups in Home Assistant, make sure the "Share" option is enabled to include the `/share` directory where Homebox stores its data.

2. **Manual Backups**: You can also manually back up the `/share/homebox` directory, which contains:
   - `homebox.db`: The SQLite database with all your inventory data
   - Attachments folder: Contains all uploaded images and files
   - Configuration file: Contains your Homebox settings

3. **Restoring Data**: When restoring from a backup:
   - Stop the Homebox addon
   - Restore the Home Assistant backup (with Share data)
   - Start the Homebox addon

4. **Database Maintenance**: If you need to perform SQLite maintenance, stop the addon first to prevent database corruption.

For extra protection, consider periodically exporting your inventory data using Homebox's built-in export functionality.
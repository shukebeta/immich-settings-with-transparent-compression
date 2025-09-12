# Immich with Transparent Image Compression

This repository provides a complete setup for running [Immich](https://immich.app) with transparent image compression using a multipart upload proxy. The setup automatically compresses uploaded images to reduce storage usage while maintaining full client compatibility.

## Features

- **Transparent Compression**: Automatically compresses images during upload without modifying the Immich application
- **Client Compatibility**: Works seamlessly with existing Immich mobile and web clients
- **Configurable Compression**: Customize image dimensions and quality settings
- **Selective Processing**: Only POST requests to `/api/assets` are processed through the compression proxy
- **Authentication Preservation**: Maintains all Immich authentication and security features

## Architecture

The setup uses a multipart upload proxy container that sits between clients and the Immich server:

```
Client → Nginx → Upload Proxy (compression) → Immich Server
                     ↓ (GET requests bypass proxy)
Client → Nginx → Immich Server
```

## Configuration

### Upload Proxy Settings

The compression proxy supports the following environment variables:

- `IMG_MAX_WIDTH`: Maximum image width (default: 1600px)
- `IMG_MAX_HEIGHT`: Maximum image height (optional)
- `JPEG_QUALITY`: JPEG compression quality 1-100 (configurable in image)
- `FORWARD_DESTINATION`: Target Immich API endpoint
- `FILE_UPLOAD_FIELD`: Multipart field name for asset data
- `LISTEN_PATH`: API path to intercept

### Nginx Configuration

The included nginx configuration (`photos.dev.shukebeta.com.conf`) provides:

- Precise routing for `/api/assets` POST requests to the compression proxy
- Direct routing for all other requests to Immich server
- Large file upload support (50GB limit)
- WebSocket support for real-time features
- SSL termination with Let's Encrypt

## Setup Instructions

1. **Clone this repository**:
   ```bash
   git clone <repository-url>
   cd immich-settings-with-transparent-compression
   ```

2. **Create environment file**:
   Create a `.env` file with your Immich configuration:
   ```env
   IMMICH_VERSION=release
   UPLOAD_LOCATION=/path/to/your/photos
   DB_DATA_LOCATION=/path/to/your/database
   DB_PASSWORD=your_database_password
   DB_USERNAME=immich
   DB_DATABASE_NAME=immich
   ```

3. **Start the services**:
   ```bash
   docker compose up -d
   ```

4. **Configure nginx** (if using the provided configuration):
   - Copy `photos.dev.shukebeta.com.conf` to your nginx sites directory
   - Update server names and proxy destinations to match your domain and server setup
   - Reload nginx configuration
   
   **Note**: The configuration file uses `photos.dev.shukebeta.com` as an example domain and `e6420.shukebeta.eu.org` as the backend server. Replace these with your actual domain name and server address.

## Services

- **immich-server**: Main Immich application (port 2283)
- **upload-proxy**: Image compression proxy (port 6743)  
- **immich-machine-learning**: ML processing for face detection, etc.
- **redis**: Caching and job queue
- **database**: PostgreSQL with vector extensions

## Backup

The included `sync_files.sh` script provides a simple rsync-based backup solution:

- Syncs Immich library to multiple destinations
- Excludes temporary files
- Designed to run via cron for regular backups

Edit the script to configure your backup destinations:

```bash
SOURCE_DIR="/path/to/immich/library"
DEST_DIR1="remote1:/backup/path"
DEST_DIR2="remote2:/backup/path"
```

## Verification

After setup, verify the compression proxy is working:

1. Check container status: `docker compose ps`
2. Upload a test image through Immich client
3. Verify the uploaded image has been compressed to your specified dimensions
4. Confirm storage usage is reduced compared to original images

## Customization

### Image Compression Settings

Modify the `upload-proxy` service environment variables in `docker-compose.yml`:

```yaml
environment:
  - IMG_MAX_WIDTH=2048    # Increase for higher resolution
  - IMG_MAX_HEIGHT=2048   # Set height limit
  - JPEG_QUALITY=85       # Adjust quality (requires custom image)
```

## Based On

- [Immich](https://immich.app) - Self-hosted photo and video management
- [multipart-upload-proxy](https://github.com/shukebeta/multipart-upload-proxy) - Image compression proxy
- Docker image: `shukebeta/multipart-upload-proxy:unified-compression`

## License

See [LICENSE](LICENSE) file for details.

## Support

For issues related to:
- Immich functionality: [Immich GitHub](https://github.com/immich-app/immich)
- Upload proxy: [multipart-upload-proxy GitHub](https://github.com/shukebeta/multipart-upload-proxy)
- This configuration: Open an issue in this repository
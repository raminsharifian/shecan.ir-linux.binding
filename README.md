# Shecan DNS Configuration Script (Debian/Ubuntu)

A Bash script to configure systemd-resolved to use Shecan DNS servers on systemd-based Linux systems.

## Features

- Automatically backs up your current DNS configuration
- Configures systemd-resolved to use Shecan DNS servers (178.22.122.100, 185.51.200.2)
- Sets Google DNS (8.8.8.8) as fallback servers
- Verifies the configuration after applying changes

## Prerequisites

- System running systemd (most modern Linux distributions)
- systemd-resolved service active and running
- Root/sudo privileges

## Usage

1. Download the script:

```bash
curl -O https://raw.githubusercontent.com/raminsharifian/shecan.ir-linux.binding/refs/heads/main/src/shecan-dns.sh
```

2. Make the script executable:

```bash
chmod +x shecan-dns.sh
```

3. Run the script with sudo:

```bash
sudo ./shecan-dns.sh
```

## What the Script Does

1. **Checks prerequisites**: Verifies root privileges and systemd-resolved availability
2. **Creates backup**: Saves a copy of your current `/etc/resolv.conf`
3. **Configures DNS**: Creates systemd-resolved configuration files for Shecan DNS
4. **Applies changes**: Restarts systemd-resolved and updates `/etc/resolv.conf`
5. **Verifies setup**: Displays the current DNS configuration for confirmation

## Files Created/Modified

- `/etc/systemd/resolved.conf.d/shecan.conf` - Shecan DNS configuration
- `/etc/resolv.conf.backup` - Backup of original resolv.conf (if none existed)
- `/etc/resolv.conf` - Symlink to systemd-resolved's stub resolver

## Reverting Changes

To revert to your original DNS configuration:

1. Restore the backup:

```bash
sudo cp /etc/resolv.conf.backup /etc/resolv.conf
```

2. Remove the Shecan configuration:

```bash
sudo rm /etc/systemd/resolved.conf.d/shecan.conf
```

3. Restart systemd-resolved:

```bash
sudo systemctl restart systemd-resolved
```

## Important Notes

- This script is designed for systems using systemd-resolved
- The script will not overwrite existing backup files
- Shecan DNS is specifically useful for Iran-based users to bypass restrictions
- Always verify the DNS servers are working correctly after configuration

## Troubleshooting

If you encounter issues:

1. Check if systemd-resolved is running:

```bash
systemctl status systemd-resolved
```

2. Verify DNS configuration:

```bash
resolvectl status
```

3. Test DNS resolution:

```bash
nslookup dl.google.com
```

## Contributing

Feel free to submit issues and enhancement requests through the GitHub repository.

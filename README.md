# Environment Variables Tool for Penetration Testing

A ZSH-based interactive tool for managing environment variables and credential sets commonly used in penetration testing workflows, particularly for OSCP+ scenarios.

## Features

- **Interactive Variable Management**: Easy-to-use interface for setting and managing 11 common penetration testing variables
- **Credential Set Management**: Store and switch between multiple credential sets with different authentication methods
- **Export Functionality**: Export credentials to files for use with other tools
- **Persistent Storage**: Variables and credential sets are saved to `~/.config/.my_vars.env`
- **Color-coded Interface**: Easy-to-read colored output for better user experience
- **Multiple Authentication Types**: Support for passwords, NT hashes, and AES keys

## Variables Managed

- `OUTDIR` - Output directory for exports
- `C2` - Command & Control server
- `TARGET` - Target IP/hostname
- `TARGETS` - Multiple targets
- `CIDR` - Network CIDR notation
- `DC` - Domain Controller
- `DOMAIN` - Domain name
- `USER` - Username
- `PASSWORD` - Password
- `NT_HASH` - NT hash for pass-the-hash attacks
- `AES_KEY` - AES key for Kerberos authentication

## Requirements

- **ZSH shell** (version 5.0 or higher)
- Standard Unix tools: `grep`, `mv`, `rm`, `mkdir`, `printf`
- Terminal with color support (recommended)

## Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/var-tool.git
cd var-tool
```

2. Make the script executable:

```bash
chmod +x var.sh
```

3. Source the script:

```bash
source var.sh
```

## Usage

### Interactive Mode

Start the interactive interface:

```bash
source var.sh
```

### Command Line Options

```bash
# Show help
source var.sh -h

# List all variables and credential sets
source var.sh -l

# Source environment file and show variables
source var.sh -s

# Delete all data
source var.sh -d
```

### Interactive Commands

Once in interactive mode:

- **1-11**: Edit variables by number
- **12+**: Load credential sets by number
- **A**: Add new credential set
- **E**: Edit existing credential set
- **D**: Delete credential set
- **X**: Export credentials to files
- **C**: Clear all data
- **Q**: Exit

## Credential Sets

Credential sets allow you to store and quickly switch between different user credentials. Each set can contain:

- Username
- Password (for password authentication)
- NT Hash (for pass-the-hash attacks)
- AES Key (for Kerberos authentication)
- Target (optional associated target)

## Export Functionality

The export feature creates two files in your specified `OUTDIR`:

- `users.txt` - List of usernames
- `passwords.txt` - List of passwords

This is useful for tools that require separate user and password files.

## Security Notes

- The configuration file is stored at `~/.config/.my_vars.env`
- Ensure proper file permissions on your config directory
- Be cautious when storing sensitive credentials
- Consider using the tool in isolated environments for testing

## Examples

### Setting up for a penetration test:

```bash
# Start the tool
source var.sh

# Set basic variables
1  # Enter OUTDIR: /home/user/output
2  # Enter C2: 192.168.1.100
3  # Enter TARGET: 192.168.1.50
7  # Enter DOMAIN: example.local

# Add credential set
A  # Add credential set
# Name: admin-creds
# Username: administrator
# Password: Password123!
```

### Loading saved environment:

```bash
# Source saved variables
source var.sh -s

# Or start interactive mode to switch credential sets
source var.sh
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This tool is intended for authorized penetration testing and educational purposes only. Users are responsible for complying with applicable laws and regulations.

## Support

If you encounter any issues or have questions, please open an issue on GitHub.

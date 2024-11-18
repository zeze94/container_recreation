# Recreate Docker Containers Script

This script provides a convenient way to recreate Docker Compose containers by stopping, removing, recreating, and starting a specified service without stopping the whole environment. It also includes tab completion for service names when using Zsh.

## Features

- Stops the specified Docker Compose service.
- Removes the stopped service container.
- Recreates the service container.
- Starts the new service container.
- Enables tab completion for service names in Zsh.

## Prerequisites

- **Docker**: Ensure Docker is installed and running on your system.
- **Docker Compose**: Required for managing multi-container Docker applications.
- **Zsh Shell**: The script is designed for users of the Zsh shell.
- **Bash**: Needed to run the installation script.

## Installation

### 1. Save the Recreate Script

Create a file named `recreate.sh` and add the following content:

```bash
#!/bin/bash
docker compose stop "$1"
docker compose rm "$1" -f
docker compose create "$1"
docker compose start "$1"
```

Make the script executable:

```bash
chmod +x recreate.sh
```

### 2. Add the Function and Completion to Zsh

Create a Bash script named `add_recreate_to_zshrc.sh` # container_recreation
Script to use with zsh that adds a docker compose single container recreation with autocomplete based on the folder where you are.
ith the following content:

```bash
#!/bin/bash

# Define the code to be added
read -r -d '' CODE << 'EOF'

# Added by recreate script
# Define the recreate function
recreate() {
    docker compose stop "$1"
    docker compose rm "$1" -f
    docker compose create "$1"
    docker compose start "$1"
}

# Define the completion function
_recreate() {
    local -a services
    # Fetch service names from docker-compose.yml
    services=($(docker compose config --services))
    # For running container names, use:
    # services=($(docker ps --format '{{.Names}}'))

    _arguments \
        "1:service name:(${services[*]})"
}

# Register the completion function
compdef _recreate recreate

EOF

# Backup the existing .zshrc file
cp ~/.zshrc ~/.zshrc.backup

# Append the code to the .zshrc file
echo "$CODE" >> ~/.zshrc

# Inform the user
echo "The recreate function and its completion have been added to your ~/.zshrc file."
echo "A backup of your original .zshrc has been created at ~/.zshrc.backup."
echo "Please run 'source ~/.zshrc' to reload your configuration."
```

Make the installation script executable:

```bash
chmod +x add_recreate_to_zshrc.sh
```

### 3. Run the Installation Script

Execute the script to add the `recreate` function and tab completion to your Zsh configuration:

```bash
./add_recreate_to_zshrc.sh
```

### 4. Reload Your Zsh Configuration

Apply the changes by sourcing your `.zshrc` file:

```zsh
source ~/.zshrc
```

## Usage

To recreate a Docker Compose service, use the `recreate` command followed by the service name in the folder where youre running your docker-compose from. Tab completion is enabled for the service names defined in your `docker-compose.yml`.

```zsh
recreate <service_name>
```

### Example

```zsh
recreate web
```

This command will stop, remove, recreate, and start the `web` service.

## Notes

- **Service Names Source**: By default, the tab completion fetches service names from your `docker-compose.yml` file. If you prefer to auto-complete based on running container names, edit the function in your `.zshrc` file:

  Replace:

  ```bash
  services=($(docker compose config --services))
  ```

  With:

  ```bash
  services=($(docker ps --format '{{.Names}}'))
  ```

- **Backup of `.zshrc`**: A backup of your original `.zshrc` file is created at `~/.zshrc.backup` before the script modifies it.

## Troubleshooting

- **Tab Completion Not Working**: Ensure that you've reloaded your Zsh configuration by running `source ~/.zshrc`. Check for any errors in your `.zshrc` file.
- **Permission Denied Errors**: Verify that both `recreate.sh` and `add_recreate_to_zshrc.sh` are executable and that you have the necessary permissions.

## License

This script is provided under the MIT License.

## Contributing

Contributions are welcome! If you have suggestions or improvements, feel free to submit a pull request or open an issue.

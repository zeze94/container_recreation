#!/bin/bash

# Define the code to be added
read -r -d '' CODE << 'EOF'
# Start of recreate script
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
# End of recreate script

EOF

# Backup the existing .zshrc file
cp ~/.zshrc ~/.zshrc.backup

# Append the code to the .zshrc file
echo "$CODE" >> ~/.zshrc

# Inform the user
echo "The recreate function and its completion have been added to your ~/.zshrc file."
echo "A backup of your original .zshrc has been created at ~/.zshrc.backup."
echo "Please run 'source ~/.zshrc' to reload your configuration."

#! /usr/bin/env sh

# Set default values for environment variables
VERSION="${VERSION:-LATEST}"
PACKAGES="${PACKAGES:-}"
EULA="${EULA:-FALSE}"

# Enforce EULA
if [ $(echo "$EULA" | tr '[:lower:]' '[:upper:]') != "TRUE" ]
then
    echo "You must accept the Minecraft EULA to run the server."
    echo "Set the environment variable EULA to TRUE to accept it."
    exit 1
fi

# Enable core dumps
export WINEDEBUG="${WINEDEBUG:--all}"

# Install dependencies on first run
# Test if bedrock_server_mod.exe exists
if [ ! -f "bedrock_server_mod.exe" ]; then
    # Install LeveLamina
    if [ "$VERSION" = "LATEST" ]
    then
        wine64 lip.exe install -y github.com/LiteLDev/LeviLamina
    else
        wine64 lip.exe install -y github.com/LiteLDev/LeviLamina@$VERSION
    fi

    # Install packages, line by line
    for package in $PACKAGES
    do
        wine64 lip.exe install -y $package
    done
fi

wine64 bedrock_server_mod.exe

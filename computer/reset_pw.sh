#!/bin/bash

# This shell script triggers reset of password for Ansys MBSE server. Contact your regional application engineer of MBSE server for further information.
# Load the .env file and get the APP_HOST and APP_PORT values
if [ -f .env ]; then
    # Read the APP_HOST and APP_PORT values from the .env file and remove non-printable characters
    APP_HOST=$(grep '^APP_HOST=' .env | cut -d '=' -f2- | tr -d '\r\n')
    APP_PORT=$(grep '^APP_PORT=' .env | cut -d '=' -f2- | cut -d ' ' -f1 | tr -d '\r\n')
    if [ -z "$APP_HOST" ]; then
        echo "APP_HOST not found in .env file!"
        exit 1
    fi
    if [ -z "$APP_PORT" ]; then
        echo "APP_PORT not found in .env file!"
        exit 1
    fi
else
    echo ".env file not found!"
    exit 1
fi

# Confirm whether the user has filled the form
while true; do
    read -p "Have you filled the web form https://${APP_HOST}:${APP_PORT}/api/forgottenPassword ? (y/N): " answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        echo "Great! Continuing the script..."
        break
    else
        echo "Please fill the form first."
    fi
done

# Function to prompt user for email address
read -p "Please enter the email address: " email

# Run the psql command to get the JSON result
# docker exec -it mbse25r2_postgres psql -U dbuser -d cloudmodeling -t -A -c "SELECT json_agg(t) FROM (SELECT userid, identkeyhash FROM webuser WHERE emailaddress = '$email') t;"
json_result=$(docker exec mbse25r2_postgres psql -U dbuser -d cloudmodeling -t -A -c "SELECT json_agg(t) FROM (SELECT userid, identkeyhash FROM webuser WHERE emailaddress = '$email') t;")

# Extract userid and identkeyhash from JSON result using jq
userid=$(echo $json_result | jq -r '.[0].userid')
identkeyhash=$(echo $json_result | jq -r '.[0].identkeyhash')

# Construct the URL with userid, identkeyhash, APP_HOST, and APP_PORT
url="https://${APP_HOST}:${APP_PORT}/api/changePassword?user=${userid}&token=${identkeyhash}"

# Print the URL
echo $url


#!/usr/bin/env bash

declare -i MMS_PORT=9080
declare -i MMS_SSL_PORT=9443

_replace_property_in_file() {
    # Parameter check
    if [[ "$#" -lt 3 ]]; then
        echo "Invalid call: '_replace_property_in_file $*'"
        echo "Usage: _replace_property_in_file FILENAME PROPERTY VALUE"
        echo
        exit 1
    fi

    # Set the new property
    temp_file=$(mktemp)
    grep -vE "^\\s*${2}\\s*=" "${1}" > "${temp_file}" # Export contents minus any lines containing the specified property
    echo "${2}=${3}" >> "${temp_file}"                # Set the new property value
    cat "${temp_file}" > "${1}"                       # Replace the contents of the original file, while preserving any permissions
    rm "${temp_file}"
    echo "Updated property in ${1}: ${2}=${3}"
}

main() {

    local conf_file="/root/mongodb-mms/conf/conf-mms.properties"

    # These get updated at runtime.
    _replace_property_in_file "$conf_file" "mongo.mongoUri" "mongodb://set.ip.at.runtime:SETPORTATRUNTIME"
    _replace_property_in_file "$conf_file" "mms.centralUrl" "http://set.ip.at.runtime:SETPORTATRUNTIME"  

    echo "Skipping Ops Manager Registration Wizard..."
    _replace_property_in_file "$conf_file" "mms.ignoreInitialUiSetup" "true"
    _replace_property_in_file "$conf_file" "mms.fromEmailAddr" "noreply@example.com"
    _replace_property_in_file "$conf_file" "mms.replyToEmailAddr" "noreply@example.com"
    _replace_property_in_file "$conf_file" "mms.adminEmailAddr" "noreply@example.com"
    _replace_property_in_file "$conf_file" "mms.mail.transport" "smtp"
    _replace_property_in_file "$conf_file" "mms.mail.hostname" "127.0.0.1"
    _replace_property_in_file "$conf_file" "mms.mail.port" "25"
    _replace_property_in_file "$conf_file" "mms.mail.ssl" "false"

    # Configure backup head
    local backup_dir="/data/headdb"
    mkdir -p "${backup_dir}" && echo "Created directory: ${backup_dir}..."
    chmod -R 0777 "${backup_dir}"
    _replace_property_in_file "$conf_file" "rootDirectory" "${backup_dir}/"

    # Define and create the release automation dir, if not defined
    local automation_release_dir="/root/mongodb-mms/mongodb-releases/"
    mkdir -p "${automation_release_dir}"
    chmod -R 0777 "${automation_release_dir}"
    _replace_property_in_file "$conf_file" "automation.versions.directory" "${automation_release_dir}"

    # Switch to hybrid mode if you want Ops Manager to download the file (vs. the agents),
    # and then persist those versions from one demo run to the next using -v in the Run command:
    #
    #   docker run ..ops-manager..  -v ./mongodb-releases:/root/mongodb-mms/mongodb-releases/
    #
    # But this didn't really improve the performance all that much, and Ops Manager will 
    # download the latest version of every release, all the way back to version 2.6! 
    # _replace_property_in_file "$conf_file" "automation.versions.source" "hybrid"

    echo "Generating an encryption key"
    echo "WARNING: this is highly insecure, DO NOT IN PRODUCTION!"
    echo
    /root/mongodb-mms/bin/mms-gen-key
    mkdir /root/.mongodb-mms
    mv /etc/mongodb-mms/gen.key /root/.mongodb-mms/gen.key

}

main "$@"

# secure_and_minimal:x-base
Baseimage based on Alpine, with sudo, argon2 and custom scripts for improved security.

## Environment variables
### pre-set runtime variables.
* VAR_LINUX_USER="root" (the user running VAR_FINAL_COMMAND)
* VAR_FINAL_COMMAND="pause" (the command to run)

## Capabilities
Can drop all but SETPCAP, SETGID and SETUID.

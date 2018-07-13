**Note! I use Docker latest tag for development, which means that it isn't allways working. Date tags are stable.**

# alpine
Based on the official Alpine Docker image, with sudo, argon2 and improved security.

## Environment variables
### pre-set runtime variables.
* VAR_LINUX_USER="root" (the user running VAR_FINAL_COMMAND)
* VAR_FINAL_COMMAND="/bin/sh" (the command to run)

**Note! I use Docker latest tag for development, which means that it isn't allways working. Date tags are stable.**

# alpine
Based on the official Alpine Docker image, with sudo, argon2 and improved security.

## Environment variables
### pre-set runtime variables.
* VAR_LINUX_USER="root"

### optional runtime variables.
* VAR_FINAL_COMMAND="PGPASSFILE=\$VAR_PGPASSFILE /usr/local/bin/pgagent -f hostaddr=\$VAR_HOSTADDR dbname=\$VAR_DBNAME user=\$VAR_USER"

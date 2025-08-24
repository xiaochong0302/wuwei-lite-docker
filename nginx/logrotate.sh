#!/usr/bin/env bash

KEEP_DAYS=15

LOG_DIR="/var/log/nginx"

DATE=$(date -d yesterday +%Y%m%d)

# Rotate current logs
mv "${LOG_DIR}/wuwei.access.log" "${LOG_DIR}/wuwei.access.${DATE}.log"
mv "${LOG_DIR}/wuwei.error.log" "${LOG_DIR}/wuwei.error.${DATE}.log"

# Compress rotated logs
gzip "${LOG_DIR}/wuwei.access.${DATE}.log"
gzip "${LOG_DIR}/wuwei.error.${DATE}.log"

# Delete old compressed logs older than KEEP_DAYS
find "${LOG_DIR}" -mtime +${KEEP_DAYS} -type f -name 'wuwei.access.*.log.gz' -print0 | xargs -0 rm -f
find "${LOG_DIR}" -mtime +${KEEP_DAYS} -type f -name 'wuwei.error.*.log.gz'  -print0 | xargs -0 rm -f

# Tell nginx to reopen log files (non-disruptively)
if [ -f /var/run/nginx.pid ]; then
  kill -USR1 "$(cat /var/run/nginx.pid)"
else
  echo "nginx PID file not found. Is nginx running?"
  exit 1
fi

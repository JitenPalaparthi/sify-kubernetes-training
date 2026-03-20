#!/usr/bin/env bash
set -Eeuo pipefail

# ============================================================
# Remote etcd backup script using local certificate files only
#
# Priority:
#   CLI args > env vars > defaults
#
# Example:
#   ./etcd-remote-backup.sh \
#     --endpoint https://192.168.2.32:2379 \
#     --cacert /home/ubuntu/etcd-certs/ca.crt \
#     --cert /home/ubuntu/etcd-certs/healthcheck-client.crt \
#     --key /home/ubuntu/etcd-certs/healthcheck-client.key
#
# Or:
#   export ENDPOINT=https://192.168.2.32:2379
#   export CACERT=/home/ubuntu/etcd-certs/ca.crt
#   export CERT=/home/ubuntu/etcd-certs/healthcheck-client.crt
#   export KEY=/home/ubuntu/etcd-certs/healthcheck-client.key
#   ./etcd-remote-backup.sh
# ============================================================

# -----------------------------
# DEFAULTS / ENV OVERRIDES
# -----------------------------
ENDPOINT="${ENDPOINT:-}"

CACERT="${CACERT:-$HOME/etcd-certs/ca.crt}"
CERT="${CERT:-$HOME/etcd-certs/healthcheck-client.crt}"
KEY="${KEY:-$HOME/etcd-certs/healthcheck-client.key}"

BACKUP_DIR="${BACKUP_DIR:-$HOME/etcd-backups}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"

DIAL_TIMEOUT="${DIAL_TIMEOUT:-5s}"
HEALTH_TIMEOUT="${HEALTH_TIMEOUT:-10s}"
STATUS_TIMEOUT="${STATUS_TIMEOUT:-15s}"
COMMAND_TIMEOUT="${COMMAND_TIMEOUT:-180s}"

TIMESTAMP="$(date +%F_%H-%M-%S)"
HOSTNAME_SHORT="$(hostname -s)"
SNAPSHOT_FILE=""

# -----------------------------
# HELP
# -----------------------------
usage() {
  cat <<EOF
Usage:
  $(basename "$0") [options]

Options:
  --endpoint URL              etcd endpoint, example: https://192.168.2.32:2379
  --cacert PATH               etcd CA certificate path
  --cert PATH                 etcd client certificate path
  --key PATH                  etcd client private key path
  --backup-dir PATH           backup directory
  --retention-days N          delete backups older than N days
  --dial-timeout VALUE        etcdctl dial timeout (default: ${DIAL_TIMEOUT})
  --health-timeout VALUE      health check timeout (default: ${HEALTH_TIMEOUT})
  --status-timeout VALUE      endpoint status timeout (default: ${STATUS_TIMEOUT})
  --command-timeout VALUE     snapshot command timeout (default: ${COMMAND_TIMEOUT})
  -h, --help                  show this help

Priority:
  CLI args > environment variables > defaults

Environment variables:
  ENDPOINT
  CACERT
  CERT
  KEY
  BACKUP_DIR
  RETENTION_DAYS
  DIAL_TIMEOUT
  HEALTH_TIMEOUT
  STATUS_TIMEOUT
  COMMAND_TIMEOUT

Examples:

  1) CLI args:
     $(basename "$0") \\
       --endpoint https://192.168.2.32:2379 \\
       --cacert /home/ubuntu/etcd-certs/ca.crt \\
       --cert /home/ubuntu/etcd-certs/healthcheck-client.crt \\
       --key /home/ubuntu/etcd-certs/healthcheck-client.key

  2) Environment variables:
     export ENDPOINT=https://192.168.2.32:2379
     export CACERT=/home/ubuntu/etcd-certs/ca.crt
     export CERT=/home/ubuntu/etcd-certs/healthcheck-client.crt
     export KEY=/home/ubuntu/etcd-certs/healthcheck-client.key
     $(basename "$0")
EOF
}

# -----------------------------
# LOGGING
# -----------------------------
log() {
  echo "[$(date '+%F %T')] $*"
}

fail() {
  echo "[$(date '+%F %T')] ERROR: $*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing command: $1"
}

# -----------------------------
# ARG PARSING
# -----------------------------
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --endpoint)
        ENDPOINT="$2"
        shift 2
        ;;
      --cacert)
        CACERT="$2"
        shift 2
        ;;
      --cert)
        CERT="$2"
        shift 2
        ;;
      --key)
        KEY="$2"
        shift 2
        ;;
      --backup-dir)
        BACKUP_DIR="$2"
        shift 2
        ;;
      --retention-days)
        RETENTION_DAYS="$2"
        shift 2
        ;;
      --dial-timeout)
        DIAL_TIMEOUT="$2"
        shift 2
        ;;
      --health-timeout)
        HEALTH_TIMEOUT="$2"
        shift 2
        ;;
      --status-timeout)
        STATUS_TIMEOUT="$2"
        shift 2
        ;;
      --command-timeout)
        COMMAND_TIMEOUT="$2"
        shift 2
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        fail "Unknown argument: $1"
        ;;
    esac
  done
}

# -----------------------------
# VALIDATION
# -----------------------------
validate_inputs() {
  [[ -n "$ENDPOINT" ]] || fail "ENDPOINT is required. Example: --endpoint https://192.168.2.32:2379"

  [[ -f "$CACERT" ]] || fail "CA cert not found: $CACERT"
  [[ -f "$CERT" ]]   || fail "Client cert not found: $CERT"
  [[ -f "$KEY" ]]    || fail "Client key not found: $KEY"

  mkdir -p "$BACKUP_DIR"
  SNAPSHOT_FILE="${BACKUP_DIR}/etcd-snapshot-${HOSTNAME_SHORT}-${TIMESTAMP}.db"
}

# -----------------------------
# ETCD OPERATIONS
# -----------------------------
etcd_health_check() {
  log "Checking etcd endpoint health..."
  ETCDCTL_API=3 etcdctl \
    --endpoints="$ENDPOINT" \
    --cacert="$CACERT" \
    --cert="$CERT" \
    --key="$KEY" \
    --dial-timeout="$DIAL_TIMEOUT" \
    --command-timeout="$HEALTH_TIMEOUT" \
    endpoint health -w table
}

etcd_endpoint_status() {
  log "Fetching etcd endpoint status..."
  ETCDCTL_API=3 etcdctl \
    --endpoints="$ENDPOINT" \
    --cacert="$CACERT" \
    --cert="$CERT" \
    --key="$KEY" \
    --dial-timeout="$DIAL_TIMEOUT" \
    --command-timeout="$STATUS_TIMEOUT" \
    endpoint status -w table
}

take_snapshot() {
  log "Starting remote etcd backup..."
  log "Endpoint      : $ENDPOINT"
  log "CA cert       : $CACERT"
  log "Client cert   : $CERT"
  log "Client key    : $KEY"
  log "Backup file   : $SNAPSHOT_FILE"
  log "Dial timeout  : $DIAL_TIMEOUT"
  log "Cmd timeout   : $COMMAND_TIMEOUT"

  ETCDCTL_API=3 etcdctl \
    --endpoints="$ENDPOINT" \
    --cacert="$CACERT" \
    --cert="$CERT" \
    --key="$KEY" \
    --dial-timeout="$DIAL_TIMEOUT" \
    --command-timeout="$COMMAND_TIMEOUT" \
    snapshot save "$SNAPSHOT_FILE"

  log "Backup successful: $SNAPSHOT_FILE"
}

validate_snapshot() {
  log "Validating snapshot..."
  if command -v etcdutl >/dev/null 2>&1; then
    etcdutl snapshot status "$SNAPSHOT_FILE" -w table
  else
    ETCDCTL_API=3 etcdctl snapshot status "$SNAPSHOT_FILE" -w table
  fi
}

cleanup_old_backups() {
  log "Cleaning backups older than ${RETENTION_DAYS} days..."
  find "$BACKUP_DIR" -type f \( -name "etcd-snapshot-*.db" -o -name "etcd-snapshot-*.db.sha256" \) -mtime +"$RETENTION_DAYS" -delete
}

write_checksum() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$SNAPSHOT_FILE" > "${SNAPSHOT_FILE}.sha256"
    log "Checksum written: ${SNAPSHOT_FILE}.sha256"
  fi
}

# -----------------------------
# MAIN
# -----------------------------
main() {
  parse_args "$@"

  require_cmd etcdctl
  require_cmd find

  validate_inputs
  etcd_health_check
  etcd_endpoint_status
  take_snapshot
  validate_snapshot
  write_checksum
  cleanup_old_backups

  log "Done."
}

main "$@"
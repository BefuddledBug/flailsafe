die() {
  echo "Errore: $*" >&2
  exit 1
}

log_global() {
  echo "$(date '+%F %T') | $*" >> "$LOG_FILE"
}

md5_of() {
  md5sum "$1" | awk '{print $1}'
}

require_root() {
  [[ $EUID -eq 0 ]] || die "Questo comando richiede privilegi di root"
}


# Wait (up to WAIT_TIMEOUT seconds, default 180) for MySQL and RustFS, then start the API.
# The API exits at once if either is unreachable, which on a fresh deploy only causes restarts.
bb=/busybox/busybox
wait_for() {
  host=${1%:*}; port=${1##*:}; i=0
  [ -z "$host" ] || [ -z "$port" ] && return 0
  until $bb nc -z -w 2 "$host" "$port" 2>/dev/null; do
    i=$((i + 2))
    if [ "$i" -ge "${WAIT_TIMEOUT:-180}" ]; then echo "start: $1 not reachable after ${i}s, starting anyway"; return 0; fi
    [ $((i % 20)) -eq 0 ] && echo "start: waiting for $1"
    $bb sleep 2
  done
  echo "start: $1 is up"
}
wait_for "${DATABASE_HOST}:${DATABASE_PORT:-3306}"
[ -n "$MINIO_ENDPOINT" ] && wait_for "$MINIO_ENDPOINT"
exec ./backend_app

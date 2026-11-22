# ZT Network Lab helper functions.  Usage (from the ztnet folder):  source lab-env.sh

# Run a command as a workload:  from <workstation|frontend|api|db> <command ...>
from() {
  local who="$1"
  shift
  if [ "$who" = "workstation" ]; then
    kubectl -n corp exec deploy/workstation -- "$@"
  else
    kubectl -n hr exec deploy/"$who" -c toolbox -- "$@"
  fi
}

# TCP reachability test:  probe <source> <host> <port>
probe() {
  local result=BLOCKED
  if from "$1" nc -z -w 3 "$2" "$3" >/dev/null 2>&1; then
    result=ALLOWED
  fi
  printf '%-12s -> %-26s %s\n' "$1" "$2:$3" "$result"
}

# Internet egress test:  egress <source> [url]   (default url: https://example.com)
egress() {
  local url="${2:-https://example.com}" code result=BLOCKED
  code=$(from "$1" curl -s -m 5 -o /dev/null -w '%{http_code}' "$url" 2>/dev/null)
  if [ -n "$code" ] && [ "$code" != "000" ]; then
    result="ALLOWED (HTTP $code)"
  fi
  printf '%-12s -> %-26s %s\n' "$1" "$url" "$result"
}

# Full reachability matrix between all workloads plus Internet egress
matrix() {
  local src
  printf '%-12s    %-26s %s\n' SOURCE DESTINATION RESULT
  for src in workstation frontend api db; do
    if [ "$src" != frontend ]; then probe "$src" frontend.hr 80; fi
    if [ "$src" != api ]; then probe "$src" api.hr 8080; fi
    if [ "$src" != db ]; then probe "$src" db.hr 6379; fi
    egress "$src"
  done
}

#!/usr/bin/env bash
# logmini.sh — Simple Log Analyzer
# chmod +x logmini.sh
#
# Purpose:
#   Analyze one or more log files to count error levels or extract specific events.
#   Supports regex filtering and can save results to a file.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: logmini.sh -f <logfile> [-f <logfile> ...] [options]

Options:
  -f FILE    Log file to read (can be used multiple times)
  -p REGEX   Only include lines matching this regex (POSIX ERE)
  -e         Event mode: print matching lines
  -c         Counts mode: summarize severities (DEFAULT)
  -o FILE    Write output to FILE instead of stdout
  -h         Show this help message
EOF
}

FILES=()
PATTERN=""
MODE="counts"
OUTFILE=""

while getopts ":f:p:eco:h" opt; do
  case "$opt" in
    f) FILES+=("$OPTARG") ;;
    p) PATTERN="$OPTARG" ;;
    e) MODE="events" ;;
    c) MODE="counts" ;;
    o) OUTFILE="$OPTARG" ;;
    h) usage; exit 0 ;;
    \?) echo "Error: invalid option -$OPTARG" >&2; usage; exit 2 ;;
    :)  echo "Error: option -$OPTARG requires an argument" >&2; usage; exit 2 ;;
  esac
done

if [ ${#FILES[@]} -eq 0 ]; then
  echo "Error: at least one -f <logfile> is required." >&2
  usage; exit 2
fi

for f in "${FILES[@]}"; do
  [ -r "$f" ] || { echo "Error: cannot read '$f'." >&2; exit 2; }
done

build_input() {
  cat "${FILES[@]}" | { [ -n "$PATTERN" ] && grep -E "$PATTERN" || cat; }
}

if [ "$MODE" = "events" ]; then
  result="$(build_input)"
else
  result="$(
    build_input \
    | grep -Eio 'CRITICAL|FATAL|ERROR|WARN|WARNING|NOTICE|INFO|DEBUG' \
    | awk '{ gsub(/^WARNING$/, "WARN"); c[toupper($0)]++ } END {
        order="CRITICAL FATAL ERROR WARN NOTICE INFO DEBUG";
        split(order,o," ");
        total=0;
        for(j=1;j<=7;j++){ s=o[j]; printf "%-8s %d\n", s, (s in c?c[s]:0); total+=c[s] }
        printf "%-8s %d\n", "TOTAL", total
      }'
  )"
fi

if [ -n "$OUTFILE" ]; then
  printf "%s\n" "${result:-"(no output)"}" > "$OUTFILE"
  echo "Wrote output to $OUTFILE"
else
  printf "%s\n" "${result:-"(no output)"}"
fi
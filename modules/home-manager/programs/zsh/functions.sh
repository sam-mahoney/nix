
jsongrep() {
  jq --arg val "$2" '
    .[] | select(.. | scalars | tostring | test($val))
  ' "$1"
}

cvegrep() {
  jq --arg val "$2" '
    recurse | objects | select(.id == $val)
  ' "$1"
}

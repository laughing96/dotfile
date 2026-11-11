

function lf() {
  local file="${1:?usage: lf <logfile>}"
  tail -n 10000 -f "$file" | \
    fzf --ansi --no-sort --tac --wrap \
        --preview 'echo {}' \
        --preview-window=right:60:wrap
}

function le() {
  local file="${1:?usage: lcp <logfile>}"
  tail -n 20000 "$file" \
  | sed 's/error/\x1b[31m&\x1b[0m/Ig' \
  | fzf -i --ansi --no-sort --tac --preview "sed -n \"\$(( {n}-5 )) , \$(( {n}+5 ))p\" $file"
}



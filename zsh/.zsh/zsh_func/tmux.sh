
# tmux
alias ta='tmux new-session -A -s main'
alias tm='tmux'
alias tks="tmux kill-session -t $TMUX_PANE"
alias tls="tmux ls"


rss_yaml="/Users/dl/Code/k8s/hackernews-reader/rss.yaml"
alias rsst="tmuxp load $rss_yaml" 
linux_yaml="~/obsidian/mynote/script/linux.yaml"
alias ldd3="tmuxp load $linux_yaml" 
note_yaml="~/obsidian/mynote/script/note.yaml"
alias note="tmuxp load $note_yaml"
code_yaml="~/obsidian/mynote/script/code.yaml"
alias code="tmuxp load $code_yaml"


function fix_tmux() {
  local dir="$HOME/.tmux/resurrect"
  local file="$dir/my.txt"
  local last="$dir/last"

  [[ -f "$file" ]] || {
    echo "错误：找不到 $file"
    return 1
  }

  if [ -f "$last" ];then
      rm -f "$last"
  fi

  ln -sfn $file $last

    tmux new-session -d -s main && tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh && tmux attach -t main
}


function ts() {
  local session
  session=$(tmux list-sessions -F '#S' 2>/dev/null | fzf --layout=reverse --prompt='select session> ') || return
  [[ -n "$session" ]] && tmux switch-client -t "$session" 2>/dev/null ||
    tmux attach-session -t "$session"
}


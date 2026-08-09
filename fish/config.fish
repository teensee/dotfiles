if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source
end

alias brew="/opt/homebrew/bin/brew"

source /Users/vladislav/.docker/init-fish.sh || true # Added by Docker Desktop

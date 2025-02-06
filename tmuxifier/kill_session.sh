#!/bin/bash

# Function to list jobs in a zsh shell within a tmux session
list_tmux_jobs() {
    local session_name="$1"

    # Get list of processes associated with the session
    processes=$(tmux list-panes -t "$session_name" -F "#{pane_pid}")

    # Print session name
    echo "Jobs in session $session_name:"

    # Iterate through each process to find zsh processes and list jobs
    for pid in $processes; do
        # Get the command associated with the process
        command=$(ps -o cmd= -p "$pid")

        # Check if the command is zsh
        if [[ "$command" == *"zsh"* ]]; then
            # List jobs in the zsh shell
            tmux send-keys -t "$session_name:.$(tmux display-message -p '#I')" "echo \"Jobs in pane $pid:\"; zsh -c 'jobs'" Enter
        fi
    done
}

# Get list of active tmux sessions
session_list=$(tmux list-sessions -F "#{session_name}")

# Iterate through each session and list jobs
for session_name in $session_list; do
    list_tmux_jobs "$session_name"
    echo
done

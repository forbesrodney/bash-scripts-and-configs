# |-------------|    |-------------|    |-------------|   |-------------|
# |      |      |    |             |    |             |   |             |
# |      -------|    |-------------|    |             |   |   minicom   |
# |      |      |    |             |    |             |   |             |
# |-------------|    |-------------|    |-------------|   |-------------|

# Configure some default panes for development
split-window -h
split-window -v
new-window
split-window -v

# Configure a window to run minicom
#source ~/.tmux/layouts/Minicom.inc

# Configure a window for accessing the laptop
#new-window
#rename-window laptop
#send-keys 'ssh laptop' Enter
#send-keys 'tmx Laptop' Enter

# Configure a window for accessing the build box
new-window
rename-window svbuilder
send-keys 'ssh svbuilder' Enter
send-keys 'tmx Builder' Enter

# Return to window 0, pane 0
select-window -t 0
select-pane -t 0


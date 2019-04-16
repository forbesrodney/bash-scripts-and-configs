# |-------------|    |-------------|    |-------------|
# |      |      |    |             |    |             |
# |      -------|    |-------------|    |             |
# |      |      |    |             |    |             |
# |-------------|    |-------------|    |-------------|

# Configure some default panes for development
split-window -h
split-window -v
new-window
split-window -v

# Configure a window for minicom
new-window
rename-window minicom
send-keys 'ssh svbuilder' Enter
send-keys 'minicom' Enter

# Configure a window for accessing the build box
new-window
rename-window svbuilder
send-keys 'ssh svbuilder' Enter
send-keys 'tmx Builder' Enter

# Return to window 0, pane 0
select-window -t 0
select-pane -t 0


# |-------------|    |-------------|    |-------------|
# |      |      |    |             |    |             |
# |      -------|    |-------------|    |             |
# |      |      |    |             |    |             |
# |-------------|    |-------------|    |-------------|

split-window -h
split-window -v
new-window
split-window -v
#new-window
#rename-window minicom
#send-keys 'ssh svbuilder' Enter
#send-keys 'minicom' Enter
new-window
rename-window svbuilder
send-keys 'ssh svbuilder' Enter
send-keys 'tmx Builder' Enter
select-window -t 0
select-pane -t 0


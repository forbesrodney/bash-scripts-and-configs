# |-------------|
# |      |      |
# |-------------|
# |      |      |
# |-------------|

# Configure a window for Linux Kernel Labs
new-window
rename-window "Linux Kernel Labs"
send-keys 'cd ~/Development/linux/tools/labs' Enter
#send-keys 'make boot' Enter
split-window -h
send-keys 'cd ~/Development/linux/tools/labs' Enter
#send-keys 'minicom -D serial.pts'
split-window -v
send-keys 'cd ~/Development/linux/tools/labs' Enter
select-pane -t 0
split-window -v
send-keys 'cd ~/Development/linux/tools/labs' Enter
#send-keys 'make gdb'

# Return to window 0, pane 0
select-window -t 0
select-pane -t 0

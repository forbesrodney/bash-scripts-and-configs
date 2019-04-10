# |-------------|
# |      |      |
# |-------------|
# |      |      |
# |-------------|

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
select-pane -t 0

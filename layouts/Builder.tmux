# |-------------| |-------------|
# |             | |             |
# |             | |             |
# |             | |             |
# |-------------| |-------------|

# Two large screens

#set -g status off

# How do we negate
#%if #{&&:#{DISPLAY},#{==:forbesr-svbuilder,#{host_short}}}

#
%if #{==:forbesr-svbuilder,#{host_short}}
  rename-window "svbuilder"
  new-window
  rename-window "docker"
  #send-keys "minicom" Enter
  select-window -t 0
%endif

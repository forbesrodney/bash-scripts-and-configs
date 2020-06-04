# |-------------|
# |             |
# |   docker    |
# |             |
# |-------------|

# One large screen

# How do we negate
#%if #{&&:#{DISPLAY},#{==:DASDevBldr,#{host_short}}}

# This layout should only be used on DASDevBldr
%if #{==:DASDevBldr,#{host_short}}
  # Configure windows inside the docker containers
  new-window
  rename-window "docker (master)"
  send-keys 'cd ~/Development/buildbot-scripts' Enter
  send-keys 'WORK_DIR=/data BRANCH=master make debug_svbuilder' Enter

  new-window
  rename-window "docker (3.1)"
  send-keys 'cd ~/Development/buildbot-scripts' Enter
  send-keys 'WORK_DIR=/data BRANCH=3.1 make debug_svbuilder' Enter

  # Return to window 0, pane 0
  select-window -t 0
  select-pane -t 0
%endif

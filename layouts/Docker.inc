# |-------------|
# |             |
# |   docker    |
# |             |
# |-------------|

# One large screen

# How do we negate
#%if #{&&:#{DISPLAY},#{==:forbesr-svbuilder,#{host_short}}}

# This layout should only be used on forbesr-svbuilder
%if #{==:forbesr-svbuilder,#{host_short}}
  # Configure a window inside the docker container
  new-window
  rename-window docker
  send-keys 'cd ~/Development/buildbot-scripts' Enter
  send-keys 'OS_VERSION=64 make debug_svbuilder' Enter
%endif

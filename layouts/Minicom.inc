# |-------------|
# |             |
# |   minicom   |
# |             |
# |-------------|

# One large screen

# How do we negate
#%if #{&&:#{DISPLAY},#{==:forbesr-svbuilder,#{host_short}}}

# This layout should only be used on forbesr-svbuilder
%if #{==:forbesr-svbuilder,#{host_short}}
  new-window
  rename-window minicom
  send-keys 'minicom' Enter
%endif

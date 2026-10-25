Problem Solving
================================================================================

Restore Dropped Stash
--------------------------------------------------------------------------------

In git bash:

gitk --all $( git fsck --no-reflog | awk '/dangling commit/ {print $3}' )
Dann 'commit' ohne Verbindung zum Head raussuchen, des Name dieses Pseudocommits 
enthält den Namen des letzten echten Commits vor Anlage des Stashes.
https://stackoverflow.com/a/65183733


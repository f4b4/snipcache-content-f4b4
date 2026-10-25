
Matches a complete line not containing 'event'.
----------------------------------------------------------------------
^((?!event).)*$

Matches a complete line not containing 'public event'. Replace with nothing deletes the line.
----------------------------------------------------------------------
^((?!public event).)*$\s

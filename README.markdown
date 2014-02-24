Vawk
====

Work with Awk-friendly columnar data in Vim. Provides a simple wrapper to Awk
as well as a few useful functions for chopping and changing columnar data.
Requires Awk to be installed, of course.

All commands accept a range which defaults to the entire file. For commands
which accept columns, these should be comma-separated; you can also use ranges
as a shorthand, e.g. `1,3-6,10,11`.

*   `:[range]Vawk <script>` -- Run an arbitrary Awk script.
*   `:[range]Vcut <columns>` -- Delete the columns specified.
*   `:[range]Vonly <columns>` -- Delete all columns except for the specified.
*   `g:vawksep` -- The record separator to use for the data. Defaults to Awk's
    usual whitespace delimiting.

License
-------

Copyright (c) [Tom Ryder][1]. Distributed under the same terms as Vim itself.
See `:help license`.

[1]: http://sanctum.geek.nz/


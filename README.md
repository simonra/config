config
======

Various general configurations I use

#### Extensive grep syntax

Useful if you are stuck in a limmited environment (such as git-bash [cygwin] on windows), or have to be very speciffic and not leave stuff up to the goodness of the magical parser:

>grep --include="*.extension" -nri "my query" ./relative/or/absolute/path/to/root/directory/of/search

Alternative example:

>grep --include="*.cs" -nri ToDo .

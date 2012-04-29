# PeekDB - Database Quick View

A command line utility that builds a simple ER diagram for a database. The output can be .png or .dot formats. Dot files are great for reuse within Omnigraffle.


Installation
-------
    gem install peek

Usage
-------
    peek [database-name] -o [png | dot]

Output
-------
Peek generates a force-directed diagram of the tables and relationships as a png or dot file. The output file is saved in the current directory with the database name as the filename with the filename extension matching the output file format.

Todo
-------
* Add support for SQLite and MySQL
* Add support for extraction of views

License
-------

MIT License. Copyright 2012 Ennova.

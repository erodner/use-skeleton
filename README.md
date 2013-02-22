use-skeleton
============

Simple script for using template files

author: Erik Rodner
e-mail: Erik.Rodner <at> gmail <dot> com

Description
(1) Create a "skels" directory in your home directory

(2) Add a directory for each skeleton

You can use the following macros in filenames and files
  (a) __FOOBAR__ substitute the variable with the value given on the command line

  (b) __PERLFUNC(...)__ use arbitrary (one-line) perl functions to generate output, for example
     __PERLFUNC(`date +%x`)__ substitutes with the current date (actually a shell command is executed)

  (c) __PERLMETHOD(...)__ use perl code
      __PERLMETHOD(for (`ls *.cpp`) { chomp; s/\.cpp$/.o/; print "$_ "; })__ 
      This lists cpp files in the current directory.

(3) use_skeleton.pl <name-of-the-skeleton> "key1=value1" ...



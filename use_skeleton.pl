#!/usr/bin/perl -w

# use_skeleton.pl 
#
# Simple script that allows you to use skeletons for coding or writing (latex)
#
# author: Erik Rodner
# e-mail: Erik.Rodner <at> gmail <dot> com

# Description
# (1) Create a "skels" directory in your home directory
# (2) Add a directory for each skeleton
# You can use the following macros in filenames and files
#   (a) __FOOBAR__ substitute the variable with the value given on the command line
#   (b) __PERLFUNC(...)__ use arbitrary (one-line) perl functions to generate output, for example
#      __PERLFUNC(`date +%x`)__ substitutes with the current date (actually a shell command is executed)
#   (c) __PERLMETHOD(...)__ use perl code
#       __PERLMETHOD(for (`ls *.cpp`) { chomp; s/\.cpp$/.o/; print "$_ "; })__ 
#       This lists cpp files in the current directory.
#
# (3) use_skeleton.pl <name-of-the-skeleton> "key1=value1" ...

use		strict;

my $skeletondir = $ENV {'HOME'}."/skels/";

####### exec_commands () // code date : 05.09.07 ######
sub		exec_commands
{
	my($text, @commands) = @_;

	for my $command(@commands) {
		if ($command =~ /^(\w+)=(.+?)$/) {
			my($key, $value) = ($1, $2);
			my $rkey = '__'.(uc $key).'__';

			$text =~ s/$rkey/$value/ig;
		} else {
			warn "unable to interpret command $command\n";
		}
	}
  


  #after all execute perl functions
	while ($text =~ /__PERLFUNC\((.+?)\)__/i) {
		my $cmd = $1;
		my $result = eval($cmd);

		$text =~ s/__PERLFUNC\(.+?\)__/$result/ig;
	}

	while ($text =~ /__PERLMETHOD\((.+?)\)__/i) {
		my $cmd = $1;
		my $tmpfile = `mktemp`;

		open(TMPFILE, ">$tmpfile") or die("mktemp: $!\n");
		select		TMPFILE;
		eval($cmd);
		close(TMPFILE);

		select		STDOUT;

		my $result = `cat $tmpfile `;
		`rm $tmpfile `;
		$text =~ s/__PERLMETHOD\(.+?\)__/$result/ig;
	}

  if ( $text =~ /__(\w+).*?__/ )
  {
    warn ( "The following macro was not substituted: $1\n" );
  }

	return $text;
}

my($type, @commands) = @ARGV;
my $dir = '';

if (defined($type))
{
  $dir = $skeletondir.'/'.$type;
}
if (!-d $dir) {
	if ( defined($type) ) 
  {
    warn "ERROR: type $dir not found\n";
  }
	warn "\nusage: $0 <type> [substitutions]\n\n";
	warn "available skeletons : \n";
	warn ` ls $skeletondir `;

	exit(-1);
}
for my $file (`ls $dir `)
{
  chomp $file;
  $file =~ /^\.*$/ && next;

  my $fn = $dir.'/'.$file;

  open(SKEL, "<$fn") or die("$fn: $!");
  my @skel = <SKEL>;
  close(SKEL);

  my $newfn = exec_commands($file, @commands);

  open(FILE, ">$newfn") or die("$newfn: $!\n");
  for my $line (@skel) {
    print FILE	exec_commands($line, @commands);
  }
  close(FILE);
}

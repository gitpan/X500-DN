#!/usr/gnu/bin/perl -w

use ExtUtils::MakeMaker;

WriteMakefile
(
'clean'				=>
	{
	'FILES'			=> 'blib/* Makefile MANIFEST X500-DN*'
	},
'dist'				=>
	{
	'COMPRESS'		=> 'gzip',
	'SUFFIX'		=> 'gz',
	},
'DISTNAME'			=> 'X500-DN',
'NAME'				=> 'X500::DN::Parser',
'PM'				=>
	{
	'Parser.pm' 	=> '$(INST_LIBDIR)/Parser.pm',
	},
'VERSION_FROM'		=> 'Parser.pm',
);

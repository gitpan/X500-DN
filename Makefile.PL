use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile
(
'clean'				=>
	{
	'FILES'			=> 'blib/* Makefile MANIFEST X500-DN-*'
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
'PREREQ_PM'			=> {},
'VERSION_FROM'		=> 'Parser.pm',
);

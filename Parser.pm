package X500::DN::Parser;

# File:
# -------------------------------------------------------------------
#	Parser.pm.
#
# Purpose:
#	Parse a X.500 Distinguished Name.
#
# Version:
#	1.00	10-Jan-97	Ron Savage	rpsavage@ozemail.com.au
#
# Notes:
#	The functions herein are listed in alphabetical order.
# -------------------------------------------------------------------

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

@EXPORT		= qw();

@EXPORT_OK	= qw();

$VERSION	= '1.13';

# Preloaded methods go here.
# -------------------------------------------------------------------

sub invalidDN
{
	my($self, $explanation, $dn, $genericDN) = @_;

	if (defined($self -> {'callBack'}) )
	{
		&{$self -> {'callBack'} }($explanation, $dn, $genericDN);
	}
	else
	{
		print "Invalid DN: $dn. \n$explanation. Expected format: " .
			"\n$genericDN\n";
	}

}	 # End of invalidDN.

#-------------------------------------------------------------------

sub new
{
	my($class)				= shift;
	$class					= ref($class) || $class;
	my($self)				= {};
	$self -> {'callBack'}	= shift;

	return bless $self, $class;

}	# End of new.

#-------------------------------------------------------------------
# Name:
#	parse.
#
# Purpose:
#	To parse DNs where the caller knows the number of RDNs.
#
# Parameters:
#	1. DN to be parsed.
#	2. A list of the expected components of the DN.
#		Any component can be put in [] to indicate that
#		that component is optional. See examples.
#
# Usage:
#	use X500::DN::Parser;
#
#	$parser = new X500::DN::Parser(\&errorInDN);
#
#	my($dn, $genericDN, %RDN) =
#		$parser -> parse('c=au;o=MagicWare;ou=Research', 'c', '[l]', 'o', 'ou');
#
# Result:
#	A list. Interpretation:
#
#	($dn, $genericDN, %component)
#
#	where:
#	$dn:		The DN passed in.
#	$genericDN:	A generic DN matching the given DN.
#	%component:	The components of the DN and their values. Eg:
#		If $dn = 'c=au;o=MagicWare', then these key/values appear:
#		'c' => 'au',
#		'o' => 'MagicWare' 
#-------------------------------------------------------------------

sub parse
{
	my($self, $dn, @RDN) = @_;

	my(%expandRDN, $i, %allowed, %optional, $genericDN);

	%expandRDN =
	(
		'c'		=> 'country',
		'l'		=> 'locality',
		'o'		=> 'organization',
		'ou'	=> 'organizationalUnit',
		'cn'	=> 'commonName'
	);

	$genericDN = '';

# Find out what's allowed and what's optional.
# Also, convert '[ou]', say, to 'ou'.

	for ($i = 0; $i <= $#RDN; $i++)
	{
		if ($RDN[$i] =~ /^\[(.+?)\]$/)
		{
			$RDN[$i]			= $1;
			$optional{$RDN[$i]}	= '?';
		}

		$allowed{$RDN[$i]}	= 1;
		$genericDN			.= '[' if ($optional{$RDN[$i]});
		$genericDN			.= ';' if ($i > 0);
		$genericDN			.= "$RDN[$i]=$expandRDN{$RDN[$i]}";
		$genericDN			.= ']' if ($optional{$RDN[$i]});
	}

# Find out what's actually present in the DN.
# Also, split 'c=au', say, into $key = 'c' and $value = 'au'.

	my(@component) = split(/;/, $dn);
	my($key, $value, %component);

	for ($i = 0; $i <= $#component; $i++)
	{

# Test # 1. Error if this component is not like 'abc=xyz',
#			where 'xyz' does not contain an '='.

		if ($component[$i] =~ /^(.+?)=([^=]+)$/)
		{
			$key	= $1;
			$value	= $2;
		}
		else
		{

# We initialize $key & $value here, even tho the call to invalidDN
#	would usually exit, so we can test all this code repeatedly.

			$key	= '';
			$value	= '';

			&invalidDN( ("Each RDN must look like 'abc=xyz'. See: " .
				"'$component[$i]'"), $dn, $genericDN);

			return;
		}

# Test # 2. Error if this key is not allowed.

		if (! defined($allowed{$key}) )
		{
			&invalidDN( ("'$key=' is not allowed here. See: " .
				"'$component[$i]'"), $dn, $genericDN);

			return;
		}

# Test # 3. Error if we've seen this $key before.

		if ($component{$key})
		{
			&invalidDN( ("'$key=' is not allowed twice. See: " .
				"'$key=$component{$key}' and '$component[$i]'"),
				$dn, $genericDN);

			return;
		}

		$component{$key} = $value;
	}

# Test # 4. Ensure we found all the components we expected.

	for $key (@RDN)
	{
		if (! defined($component{$key}) &&
			! defined($optional{$key}) )
		{
			&invalidDN("'$key=' must appear in this DN", $dn, $genericDN);

			return;
		}
	}

# Return the result.

	($dn, $genericDN, %component);

}	# End of parse.

#-------------------------------------------------------------------

# Autoload methods go after =cut, and are processed by the autosplit program.

1;

__END__

=head1 NAME

C<X500::DN::Parser> - Parse X500 Distinguished Names

=head1 SYNOPSIS

	use X500::DN::Parser;

	my($parser) = new X500::DN::Parser(\&errorInDN);

	my($dn, $genericDN, %RDN) =
		$parser -> parse('c=au;o=MagicWare;cn=Ron Savage',
				'c', '[l]', 'o', '[ou]', 'cn');

=head1 DESCRIPTION

Parse DNs where the caller knows the number of RDNs.

=head1 parse()

Input Parameters:

=over 4

=item *

DN to be parsed

=item *

A list of the expected components of the DN.
Any component can be put in [] to indicate that that component is optional

=back

Output List:

=over 4

=item *

$dn: The DN passed in

=item *

$genericDN:	A generic DN matching the given DN

=item *

%component:	The components of the DN and their values. Eg:

	If $dn = 'c=au;o=MagicWare', then these key/values appear:
	'c' => 'au',
	'o' => 'MagicWare'

=back

=head1 INSTALLATION

You install C<X500::DN::Parser>, as you would install any perl module library,
by running these commands:

	perl Makefile.PL
	make
	make test
	make install

If you want to install a private copy of C<X500::DN::Parser> in your home
directory, then you should try to produce the initial Makefile with
something like this command:

	perl Makefile.PL LIB=~/perl
		or
	perl Makefile.PL LIB=C:/Perl/Site/Lib

If, like me, you don't have permission to write man pages into unix system
directories, use:

	make pure_install

instead of make install. This option is secreted in the middle of p 414 of the
second edition of the dromedary book.

=head1 AUTHOR

C<X500::DN::Parser> was written by Ron Savage I<E<lt>rpsavage@ozemail.com.auE<gt>> in 1999.

=head1 LICENCE

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

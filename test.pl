#!/usr/gnu/bin/perl -w
#
# Name:
#	test.pl

use integer;
use strict;

use X500::DN::Parser;

# --------------------------------------------------------------------------

sub checkDN
{
	my($testDN, @RDN) = @_;

	my($parser) = new X500::DN::Parser(\&errorInDN);

	my($dn, $genericDN, %RDN) = $parser -> parse($testDN, @RDN);

	&printDN($testDN, $dn, $genericDN, %RDN);

}	# End of checkDN.

# --------------------------------------------------------------------------

sub errorInDN
{
	my($this, $explanation, $dn, $genericDN) = @_;

	$this = '';	# To stop a compiler warning.

	print "Invalid DN: <$dn>. \n<$explanation>. Expected format: " .
		"\n<$genericDN>\n";

}	 # End of errorInDN.

# --------------------------------------------------------------------------

sub printDN
{
	my($testDN, $dn, $genericDN, %RDN) = @_;

	print "Input:      $testDN \n";

	if (! defined($dn) )
	{
		print "Unknown error in DN: $dn \n";
	}
	else
	{
		print "DN:         $dn \n";
		print "Generic DN: $genericDN \n";

		my($rdn);

		for $rdn (sort(keys(%RDN) ) )
		{
			print "RDN:        $rdn=$RDN{$rdn} \n";
		}

		print "\n";
	}

}	# End of printDN.

# --------------------------------------------------------------------------

&checkDN('c=au', 'c');
&checkDN('c=au;o=MagicWare', 'c', 'o');
&checkDN('c=au;o=MagicWare;ou=Research', 'c', 'o', 'ou');
&checkDN('c=au;o=MagicWare;ou=Research;cn=Ron Savage', 'c', 'o', 'ou', 'cn');
&checkDN('c=au;o=MagicWare;cn=Ron Savage', 'c', 'o', 'cn');
&checkDN('c=au;l=Melbourne', 'c', 'l');
&checkDN('c=au;l=Melbourne;o=MagicWare', 'c', 'l', 'o');
&checkDN('c=au;l=Melbourne;o=MagicWare;ou=Research', 'c', 'l', 'o', 'ou');
&checkDN('c=au;o=MagicWare;cn=Ron Savage', 'c', '[l]', 'o', '[ou]', 'cn');
&checkDN('c=au;o=MagicWare;ou=Research;cn=Ron Savage', 'c', '[l]', 'o', '[ou]', 'cn');
&checkDN('c=au;l=Melbourne;o=MagicWare;cn=Ron Savage', 'c', '[l]', 'o', '[ou]', 'cn');
&checkDN('c=au;l=Melbourne;o=MagicWare;ou=Research;cn=Ron Savage', 'c', '[l]', 'o', '[ou]', 'cn');

my($parser) = new X500::DN::Parser(\&errorInDN);

my($fileName) = shift || 'X500DN.dat';

print "Reading $fileName \n\n";

open(INX, $fileName) || die("Can't open($fileName): $!");

while (defined($_ = <INX>) )
{
	next if (! /^c/);

	chomp;

	my($dn, $genericDN, %RDN) =
		$parser -> parse($_, 'c', '[o]', '[ou]', '[cn]');

	&printDN($_, $dn, $genericDN, %RDN);

}

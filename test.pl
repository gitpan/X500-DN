#!/usr/gnu/bin/perl -w
#
# Name:
#	test_DN.pl.
#
# Purpose:
#	Exercise the X500::DN::Parser module.
#
# Abbreviations:
#	DN:  X.500 Distinguished Name.
#	RDN: X.500 Relative Distinguished Name.
#
#-------------------------------------------------------------------

sub checkDN
{
	my($testDN, @RDN) = @_;

	my($dn, $genericDN, %RDN) = $parser -> parse($testDN, @RDN);

	if (! defined($dn) )
	{
		print "\tError. \n";
	}
	else
	{
		print "DN: $dn. \nGeneric DN: $genericDN. \nComponents of the RDN:\n";

		my($key);

		for $key (keys(%RDN) )
		{
			print "$key: $RDN{$key}. \n";
		}
	}

	print '-' x 65, "\n";

}	# End of checkDN.

#-------------------------------------------------------------------

sub errorInDN
{
	($this, $explanation, $dn, $genericDN) = @_;

	$this = '';	# To stop a compiler warning.

	print "Invalid DN: <$dn>. \n<$explanation>. Expected format: " .
		"\n<$genericDN>\n";

}	 # End of errorInDN.

#-------------------------------------------------------------------

# Initialize.

use X500::DN::Parser;

$parser = new X500::DN::Parser(\&errorInDN);

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


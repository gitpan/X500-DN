# -*- perl -*-

use integer;
use strict;

use vars qw($loaded);

#-------------------------------------------------------------------

BEGIN
{
	$| = 1;
	print "1..2\n";
}

#-------------------------------------------------------------------

END
{
	print "not ok 1\n" if (! $loaded);
}

#-------------------------------------------------------------------

sub errorInDN
{
	my($this, $explanation, $dn, $genericDN) = @_;

	$this = '';	# To stop a compiler warning.

	print "Invalid DN: <$dn>. \n<$explanation>. Expected format: " .
		"\n<$genericDN>\n";

}	 # End of errorInDN.

#-------------------------------------------------------------------

use X500::DN::Parser;

$loaded = 1;

print "ok 1\n";

my($testNum) = 1;

sub Test($)
{
	my($result) = shift;
	$testNum++;
	print ( ($result ? "" : "not "), "ok $testNum\n");
	$result;
}

my($parser) = X500::DN::Parser -> new(\&errorInDN);

Test($parser); # or print "Error...\n";

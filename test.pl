# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 45 };
use X500::DN;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

my $s;
my $rdn;
my $dn;

### Tests for X500::RDN follow

# Tests 2-5: check a single-valued RDN
$rdn = new X500::RDN ('c'=>'DE');
print ($rdn ? "ok 2\n" : "not ok 2\n");
print ($rdn && !$rdn->isMultivalued ? "ok 3\n" : "not ok 3\n");
print ($rdn && $rdn->getRFC2253String eq 'c=DE' ? "ok 4\n" : "not ok 4\n");
print ($rdn && $rdn->getX500String eq 'c=DE' ? "ok 5\n" : "not ok 5\n");

# Tests 6-10: multi-valued RDN example from RFC 2253
$rdn = new X500::RDN ('OU'=>'Sales', 'CN'=>'J. Smith');
print ($rdn ? "ok 6\n" : "not ok 6\n");
print ($rdn && $rdn->isMultivalued ? "ok 7\n" : "not ok 7\n");
print ($rdn
	&& $rdn->getAttributeValue ('OU') eq 'Sales'
	&& $rdn->getAttributeValue ('CN') eq 'J. Smith'
		? "ok 8\n" : "not ok 8\n");
$s = $rdn && $rdn->getRFC2253String;
print ($rdn
	&& ($s eq 'OU=Sales+CN=J. Smith' || $s eq 'CN=J. Smith+OU=Sales')
		? "ok 9\n" : "not ok 9\n");
$s = $rdn && $rdn->getX500String;
print ($rdn
	&& ($s eq '(OU=Sales, CN=J. Smith)' || $s eq '(CN=J. Smith, OU=Sales)')
		? "ok 10\n" : "not ok 10\n");

### Tests for X500::DN follow

# Tests 11-13: empty DN
$dn = X500::DN->ParseRFC2253 ('');
print ($dn && $dn->getRDNs() == 0 ? "ok 11\n" : "not ok 11\n");
print ($dn && $dn->getRFC2253String() eq '' ? "ok 12\n" : "not ok 12\n");
print ($dn && $dn->getX500String() eq '{}' ? "ok 13\n" : "not ok 13\n");

# Test 14-18: one RDN, RDN type is oid
$dn = X500::DN->ParseRFC2253 ('1.4.9=2001');
print ($dn && $dn->getRDNs() == 1 ? "ok 14\n" : "not ok 14\n");
$rdn = $dn && $dn->getRDN (0);
print ($rdn && $rdn->getAttributeTypes() == 1 ? "ok 15\n" : "not ok 15\n");
print ($rdn && ($rdn->getAttributeTypes())[0] eq '1.4.9' ? "ok 16\n" : "not ok 16\n");
print ($rdn && $rdn->getAttributeValue ('1.4.9') eq '2001' ? "ok 17\n" : "not ok 17\n");
print ($dn && $dn->getRFC2253String() eq '1.4.9=2001' ? "ok 18\n" : "not ok 18\n");

# Tests 19-21: two RDNs
$dn = X500::DN->ParseRFC2253 ('cn=Nemo,c=US');
print ($dn && $dn->getRDNs() == 2 ? "ok 19\n" : "not ok 19\n");
print ($dn && $dn->getRFC2253String() eq 'cn=Nemo, c=US' ? "ok 20\n" : "not ok 20\n");
print ($dn && !$dn->hasMultivaluedRDNs ? "ok 21\n" : "not ok 21\n");

# Tests 22-23: three RDNs
$dn = X500::DN->ParseRFC2253 ('cn=John Doe, o=Acme, c=US');
print ($dn && $dn->getRDNs() == 3 ? "ok 22\n" : "not ok 22\n");
print ($dn && $dn->getRFC2253String() eq 'cn=John Doe, o=Acme, c=US' ? "ok 23\n" : "not ok 23\n");

# Tests 24-25: escaped comma
$dn = X500::DN->ParseRFC2253 ('cn=John Doe, o=Acme\\, Inc., c=US');
print ($dn && $dn->getRDNs() == 3 ? "ok 24\n" : "not ok 24\n");
print ($dn && $dn->getRDN (1)->getAttributeValue ('o') eq 'Acme, Inc.' ? "ok 25\n" : "not ok 25\n");

# Tests 26-27: escaped space
$dn = X500::DN->ParseRFC2253 ('x=\\ ');
print ($dn && $dn->getRDNs() == 1 ? "ok 26\n" : "not ok 26\n");
$rdn = $dn && $dn->getRDN (0);
print ($rdn && $rdn->getAttributeValue ('x') eq ' ' ? "ok 27\n" : "not ok 27\n");

# Tests 28-29: quoted space
$dn = X500::DN->ParseRFC2253 ('x=" "');
print ($dn && $dn->getRDNs() == 1 ? "ok 28\n" : "not ok 28\n");
$rdn = $dn && $dn->getRDN (0);
print ($rdn && $rdn->getAttributeValue ('x') eq ' ' ? "ok 29\n" : "not ok 29\n");

# Tests 30-32: more quoted spaces
$dn = X500::DN->ParseRFC2253 ('x=\\ \\ ');
print ($dn && $dn->getRDN (0)->getAttributeValue ('x') eq '  ' ? "ok 30\n" : "not ok 30\n");
$dn = X500::DN->ParseRFC2253 ('x=\\ \\ \\ ');
print ($dn && $dn->getRDN (0)->getAttributeValue ('x') eq '   ' ? "ok 31\n" : "not ok 31\n");
$dn = X500::DN->ParseRFC2253 ('x=\\  \\ ');
print ($dn && $dn->getRDN (0)->getAttributeValue ('x') eq '   ' ? "ok 32\n" : "not ok 32\n");

# Tests 33-34: commas with values
$dn = X500::DN->ParseRFC2253 ('x="a,b,c"');
print ($dn && $dn->getRDN (0)->getAttributeValue ('x') eq 'a,b,c' ? "ok 33\n" : "not ok 33\n");
$dn = X500::DN->ParseRFC2253 ('x=d\\,e');
print ($dn && $dn->getRDN (0)->getAttributeValue ('x') eq 'd,e' ? "ok 34\n" : "not ok 34\n");

# Test 35: escaped #, quote and a char in hex notation
$dn = X500::DN->ParseRFC2253 ('x=\\#\"\\41');
print ($dn && $dn->getRDN (0)->getAttributeValue ('x') eq '#"A' ? "ok 35\n" : "not ok 35\n");

# Test 36-37: bytes in hex notation
$dn = X500::DN->ParseRFC2253 ('x=#616263');
print ($dn && $dn->getRDN (0)->getAttributeValue ('x') eq 'abc' ? "ok 36\n" : "not ok 36\n");
$dn = X500::DN->ParseRFC2253 ('x=#001AFF');
print ($dn && $dn->getRDN (0)->getAttributeValue ('x') eq "\0\x1a\xff" ? "ok 37\n" : "not ok 37\n");

# Test 38: more special characters
$dn = X500::DN->ParseRFC2253 ('x=",=+<>#;"');
print ($dn && $dn->getRDN (0)->getAttributeValue ('x') eq ',=+<>#;' ? "ok 38\n" : "not ok 38\n");

# Test 39: UTF-8 example from RFC 2253
$dn = X500::DN->ParseRFC2253 ('SN=Lu\C4\8Di\C4\87');
print ($dn && $dn->getRDN (0)->getAttributeValue ('SN') eq 'Lučić' ? "ok 39\n" : "not ok 39\n");

# Tests 40-44: multi-valued RDN
$dn = X500::DN->ParseRFC2253 ('foo=1 + bar=2, baz=3');
print ($dn && $dn->hasMultivaluedRDNs ? "ok 40\n" : "not ok 40\n");
print ($dn && $dn->getRDNs() == 2 ? "ok 41\n" : "not ok 41\n");
$rdn = $dn && $dn->getRDN (1);
print ($rdn && $rdn->getAttributeTypes() == 2 ? "ok 42\n" : "not ok 42\n");
print ($rdn && $rdn->getAttributeValue ('foo') eq '1' ? "ok 43\n" : "not ok 43\n");
print ($rdn && $rdn->getAttributeValue ('bar') eq '2' ? "ok 44\n" : "not ok 44\n");

# Tests 45-46: openssl formatted DN
$dn = X500::DN->ParseOpenSSL ('/C=DE/CN=Test');
print ($dn && $dn->getRFC2253String() eq 'CN=Test, C=DE' ? "ok 45\n" : "not ok 45\n");
print ($dn && $dn->getOpenSSLString() eq '/C=DE/CN=Test' ? "ok 46\n" : "not ok 46\n");
print ($dn && $dn->getX500String() eq '{C=DE,CN=Test}' ? "ok 47\n" : "not ok 47\n");

# Tests 48: no openssl output for multi-valued RDN
$dn = new X500::DN (new X500::RDN ('foo'=>1, 'bar'=>2));
$s = eval { $dn->getOpenSSLString() };
print ($dn && $s eq '' && $@ ? "ok 48\n" : "not ok 48\n");

# Test 49: illegal RFC 2253 syntax
$dn = X500::DN->ParseRFC2253 ('foo');
print (!$dn ? "ok 49\n" : "not ok 49\n");

# Test 50: illegal openssl syntax
$dn = eval { X500::DN->ParseOpenSSL ('foo') };
#print $@;
print (!$dn && $@ ? "ok 50\n" : "not ok 50\n");

# Test 51: illegal openssl syntax
$dn = eval { X500::DN->ParseOpenSSL ('/foo') };
#print $@;
print (!$dn && $@ ? "ok 51\n" : "not ok 51\n");

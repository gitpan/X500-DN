NAME
    `X500::DN::Parser' - Parse X500 Distinguished Names

SYNOPSIS
            use X500::DN::Parser;

            my($parser) = new X500::DN::Parser(\&errorInDN);

            my($dn, $genericDN, %RDN) =
                    $parser -> parse('c=au;o=MagicWare;cn=Ron Savage',
                                    'c', '[l]', 'o', '[ou]', 'cn');

DESCRIPTION
    Parse DNs where the caller knows the number of RDNs.

parse()
    Input Parameters:

    *   DN to be parsed

    *   A list of the expected components of the DN. Any component can
        be put in [] to indicate that that component is optional

    Output List:

    *   $dn: The DN passed in

    *   $genericDN: A generic DN matching the given DN

    *   %component: The components of the DN and their values. Eg:

                If $dn = 'c=au;o=MagicWare', then these key/values appear:
                'c' => 'au',
                'o' => 'MagicWare'

INSTALLATION
    You install `X500::DN::Parser', as you would install any perl
    module library, by running these commands:

            perl Makefile.PL
            make
            make test
            make install

    If you want to install a private copy of `X500::DN::Parser' in
    your home directory, then you should try to produce the initial
    Makefile with something like this command:

            perl Makefile.PL LIB=~/perl
                    or
            perl Makefile.PL LIB=C:/Perl/Site/Lib

    If, like me, you don't have permission to write man pages into
    unix system directories, use:

            make pure_install

    instead of make install. This option is secreted in the middle
    of p 414 of the second edition of the dromedary book.

AUTHOR
    `X500::DN::Parser' was written by Ron Savage
    *<rpsavage@ozemail.com.au>* in 1999.

LICENCE
    This program is free software; you can redistribute it and/or
    modify it under the same terms as Perl itself.


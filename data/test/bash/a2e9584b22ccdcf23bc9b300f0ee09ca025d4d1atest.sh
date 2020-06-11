#!/bin/sh

# utility function
die() {
    echo
    echo "*** $@" 1>&2;
    exit 1;
}

# set a fresh repo up
rm -rf repo
xrepo create repo

# install schemas and stylesheets packages
xrepo --repo repo install ../dist/docbook-schemas-*.xar
xrepo --repo repo install ../dist/docbook-xsl-*.xar

# test stylesheet using Saxon
saxon --repo repo -s:article.xml -xsl:docbook.xsl \
    || die "Error using the local docbook.xsl"

saxon --repo repo -s:article.xml -xsl:http://docbook.org/xsl/xhtml/docbook.xsl \
    || die "Error using the public URI for docbook.xsl"

# test schemas using Calabash
calabash ++repo repo -i source=article.xml validate-rng.xproc \
    || die "Error using docbook.rng"

calabash ++repo repo -i source=article.xml validate-xsd.xproc \
    || die "Error using docbook.xsd"

calabash ++repo repo -i source=article.xml validate-sch.xproc \
    || die "Error using docbook.sch"

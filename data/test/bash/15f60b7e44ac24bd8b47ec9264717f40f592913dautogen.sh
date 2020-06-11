#!/bin/bash -e

error()
{
	echo "error: $@"
	exit 1
}

invoke()
{
	echo "$@"
	$@
}

echo -n "checking for aclocal... "
for ACLOCAL in aclocal nope; do
  ($ACLOCAL --version) < /dev/null > /dev/null 2>&1 && break
done
echo $ACLOCAL
if test x$ACLOCAL = xnope; then
  error "aclocal must be installed"
fi

echo -n "checking for autoheader... "
for AUTOHEADER in autoheader nope; do
  ($AUTOHEADER --version) < /dev/null > /dev/null 2>&1 && break
done
echo $AUTOHEADER
if test x$AUTOHEADER = xnope; then
  error "autoheader must be installed"
fi

echo -n "checking for autoconf... "
for AUTOCONF in autoconf nope; do
  ($AUTOCONF --version) < /dev/null > /dev/null 2>&1 && break
done
echo $AUTOCONF
if test x$AUTOCONF = xnope; then
  error "autoconf must be installed"
fi

echo -n "checking for libtoolize... "
for LIBTOOLIZE in libtoolize glibtoolize nope; do
  ($LIBTOOLIZE --version) < /dev/null > /dev/null 2>&1 && break
done
echo $LIBTOOLIZE
if test x$LIBTOOLIZE = xnope; then
  error "libtoolize must be installed"
fi

echo -n "checking for automake... "
for AUTOMAKE in automake nope; do
  ($AUTOMAKE --version) < /dev/null > /dev/null 2>&1 && break
done
echo $AUTOMAKE
if test x$AUTOMAKE = xnope; then
  error "automake must be installed"
fi

invoke $ACLOCAL -I m4
invoke $AUTOHEADER
invoke $AUTOCONF --force
invoke $LIBTOOLIZE --automake --copy --force
invoke $AUTOMAKE --add-missing --copy 


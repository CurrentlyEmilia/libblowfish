#!/bin/sh

#
# Copyright 2024 Emilia Luminé <eqilia@national.shitposting.agency>
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

set -e; # exit on error

. ./config

case "$1" in
"build")
	if [ -z "$CC" ]; then
		CC="cc"
	fi

	if [ -z "$AR" ]; then
		AR="ar"
	fi

	mkdir -p build

	"$CC" $CFLAGS -c -o build/blf.o src/blf.c

	"$CC" $CFLAGS -shared -o "build/libblowfish.so.$PKGVER" build/blf.o
	"$AR" $ARFLAGS -rcs "build/libblowfish.a" "build/blf.o"
	;;
"install")
	if [ ! -e "build/libblowfish.so.$PKGVER" ]; then
		printf "Please build first."
		exit 1
	fi

	if [ ! -e "build/blf.o" ]; then
		printf "Please build first."
		exit 1
	fi

	if [ -z "$PREFIX" ]; then
		PREFIX="/usr/local"
	fi

	if [ -z "$DESTDIR" ]; then
		DESTDIR="/"
	fi

	FULLDIR="$DESTDIR$PREFIX"

	mkdir -p "$FULLDIR/include/libblowfish"
	mkdir -p "$FULLDIR/lib"

	cp "build/libblowfish.so.$PKGVER" "$FULLDIR/lib/libblowfish.so.$PKGVER"
	cp "build/libblowfish.a" "$FULLDIR/lib/libblowfish.a"
	cp "include/libblowfish/blowfish.h" "$FULLDIR/include/libblowfish/blowfish.h"
	;;
*)
	printf "$0 <build|install>\r\n"
	;;
esac

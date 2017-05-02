# Core source library for shell script tests
#
# Copyright (C) 2017 Colin Walters <walters@verbum.org>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.

fatal() {
    echo $@ 1>&2; exit 1
}
# fatal() is shorter to type, but retain this alias
assert_not_reached () {
    fatal "$@"
}

# Some tests look for specific English strings. Use a UTF-8 version
# of the C (POSIX) locale if we have one, or fall back to POSIX
# (https://sourceware.org/glibc/wiki/Proposals/C.UTF-8)
if locale -a | grep C.UTF-8 >/dev/null; then
    export LC_ALL=C.UTF-8
else
    export LC_ALL=C
fi

# This should really be the default IMO
export G_DEBUG=fatal-warnings
assert_streq () {
    test "$1" = "$2" || fatal "$1 != $2"
}

assert_str_match () {
    if ! echo "$1" | grep -E -q "$2"; then
	      fatal "$1 does not match regexp $2"
    fi
}

assert_not_streq () {
    (! test "$1" = "$2") || fatal "$1 == $2"
}

assert_has_file () {
    test -f "$1" || fatal "Couldn't find '$1'"
}

assert_has_dir () {
    test -d "$1" || fatal "Couldn't find '$1'"
}

assert_not_has_file () {
    if test -f "$1"; then
        sed -e 's/^/# /' < "$1" >&2
        fatal "File '$1' exists"
    fi
}

assert_not_file_has_content () {
    if grep -q -e "$2" "$1"; then
        sed -e 's/^/# /' < "$1" >&2
        fatal "File '$1' incorrectly matches regexp '$2'"
    fi
}

assert_not_has_dir () {
    if test -d "$1"; then
	      fatal "Directory '$1' exists"
    fi
}

assert_file_has_content () {
    if ! grep -q -e "$2" "$1"; then
        sed -e 's/^/# /' < "$1" >&2
        fatal "File '$1' doesn't match regexp '$2'"
    fi
}

assert_symlink_has_content () {
    if ! test -L "$1"; then
        echo 1>&2 "File '$1' is not a symbolic link"
        exit 1
    fi
    if ! readlink "$1" | grep -q -e "$2"; then
        sed -e 's/^/# /' < "$1" >&2
        echo 1>&2 "Symbolic link '$1' doesn't match regexp '$2'"
        exit 1
    fi
}

assert_file_empty() {
    if test -s "$1"; then
        sed -e 's/^/# /' < "$1" >&2
        fatal "File '$1' is not empty"
    fi
}

# Use to skip all of these tests
skip() {
    echo "1..0 # SKIP" "$@"
    exit 0
}
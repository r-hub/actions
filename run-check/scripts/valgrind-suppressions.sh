#! /bin/bash

# If a package has tools/valgrind.supp or inst/valgrind.supp,
# add them to the suppressions file

if [[ -f /usr/libexec/valgrind/default.supp ]]; then
    if [[ -f tools/valgrind.supp ]]; then
	cat tools/valgrind.supp >> /usr/libexec/valgrind/default.supp
    fi
    if [[ -f inst/valgrind.supp ]]; then
	cat inst/valgrind.supp >> /usr/libexec/valgrind/default.supp
    fi
fi

#! /usr/bin/env perl
# Turn the R-hub workflow into a test workflow for this repo.
# Usage: make-rhub-workflow.pl < rhub.yaml > test-rhub.yaml
#
# - uses the actions from the current checkout instead of `@v1`,
# - checks out this repo into `.actions` and copies the test package
#   from `tests/pkg` to the workspace root,
# - only runs manually, like the original workflow, because it can
#   start many jobs. Use the `config` input to select the platforms.

use strict;
use warnings;

local $/;
$_ = <STDIN>;

my $checkout = sub {
    my ($indent, $copy) = @_;
    my $steps = "${indent}- uses: actions/checkout\@v7\n"
              . "${indent}  with:\n"
              . "${indent}    path: .actions\n";
    $steps .= "${indent}- name: Copy test package\n"
            . "${indent}  run: cp -R .actions/tests/pkg/. .\n"
            . "${indent}  shell: bash\n" if $copy;
    return $steps;
};

# Drop the header comment, it is about updating the original file.
s{\A(?:#.*\n|\n)*}{};

s{^name: (.*)$}{name: test-rhub.yaml}m or die "No 'name:' found\n";

# The setup job does not check out the package, but it needs this
# repo for the local `setup` action.
s{^(\s*)# NO NEED TO CHECKOUT HERE\n}{$checkout->($1, 0)}me
    or die "No setup job found\n";

s{^(\s*)- uses: r-hub/actions/checkout\@v1\n}{$checkout->($1, 1)}mge
    or die "No checkout step found\n";

s{r-hub/actions/([\w-]+)\@v1}{./.actions/$1}g;

die "Some r-hub/actions references were not replaced\n" if m{r-hub/actions/};

print "# Generated from workflows/rhub.yaml by `make` in tests/. Do not edit by hand.\n\n";
print;

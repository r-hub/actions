#! /usr/bin/env perl
# Turn an example workflow into a test workflow for this repo.
# Usage: make-workflow.pl <action-dir> < example.yaml > test.yaml
#
# - uses the actions from the current checkout instead of `@v1`,
# - checks out this repo into `.actions` and copies the test package
#   from `tests/pkg` to the workspace root,
# - only runs when the action, `platform-info` or the tests change.

use strict;
use warnings;

my $action = shift or die "Usage: $0 <action-dir>\n";
local $/;
$_ = <STDIN>;

my $on = <<"EOF";
on:
  push:
    branches: [main, master]
    paths:
      - '$action/**'
      - 'platform-info/**'
      - 'tests/**'
      - '.github/workflows/test-$action.yaml'
  pull_request:
    paths:
      - '$action/**'
      - 'platform-info/**'
      - 'tests/**'
      - '.github/workflows/test-$action.yaml'
  workflow_dispatch:

EOF

s{^on:\n.*?\n\n}{$on}ms or die "No 'on:' block found\n";
s{^name: (.*)$}{name: test-$action.yaml}m or die "No 'name:' found\n";
s{r-hub/actions/([\w-]+)\@v1}{./.actions/$1}g;
s{^(\s*)- uses: (actions/checkout\@\S+)\n}{$1- uses: $2
$1  with:
$1    path: .actions
$1- name: Copy test package
$1  run: cp -R .actions/tests/pkg/. .
$1  shell: bash
}m or die "No checkout step found\n";

print "# Generated from $action/ by `make` in tests/. Do not edit by hand.\n\n";
print;

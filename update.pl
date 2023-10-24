#!/usr/bin/env perl

use v5.38;
use utf8;
use warnings;

sub slurp($file) {
    open my $fh, '<', $file or die "Can't open file: $!";
    my $content = do { local $/; <$fh> };
    close $fh;
    return $content;
}

# get the content of the file
my $content = slurp('.github/workflows/dummy.yml');

# read the version from the file
my $auth_version;
if ($content =~ m(uses:\s*google-github-actions/auth\@(.*))) {
    $auth_version = $1;
}

my $run_version;
if ($content =~ m(uses:\s*shogo82148/actions-post-run\@(.*))) {
    $run_version = $1;
}

# update the version
my $action = slurp('action.yml');

if ($auth_version) {
    $action =~ s(uses:\s*google-github-actions/auth\@(.*))("uses: google-github-actions/auth\@$auth_version")e;
}

if ($run_version) {
    $action =~ s(uses:\s*shogo82148/actions-post-run\@(.*))("uses: shogo82148/actions-post-run\@$run_version")e;
}

# write the content to the file
open my $fh, '>', 'action.yml' or die "Can't open file: $!";
print $fh $action;
close $fh;

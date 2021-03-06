# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# G-Summary: new test that installs configured packages
# G-Maintainer: Ludwig Nussel <ludwig.nussel@suse.de>

use base "consoletest";
use strict;
use testapi;

sub run() {
    select_console 'root-console';

    my $packages = get_var("INSTALL_PACKAGES");

    assert_script_run("zypper -n in -l perl-solv");
    my $ex = script_run("~$username/data/lsmfip --verbose $packages > \$XDG_RUNTIME_DIR/install_packages.txt 2> /tmp/lsmfip.log");
    upload_logs '/tmp/lsmfip.log';
    die "lsmfip failed" if $ex;
    # make sure we install at least one package - otherwise this test is pointless
    # better have it fail and let a reviewer check the reason
    assert_script_run("test -s \$XDG_RUNTIME_DIR/install_packages.txt");
    # might take longer for large patches (i.e. 12 kernel flavors)
    assert_script_run("xargs --no-run-if-empty zypper -n in -l < \$XDG_RUNTIME_DIR/install_packages.txt", 800);
    assert_script_run("rpm -q $packages | tee /dev/$serialdev");
}

sub test_flags() {
    return {fatal => 1};
}

1;
# vim: set sw=4 et:

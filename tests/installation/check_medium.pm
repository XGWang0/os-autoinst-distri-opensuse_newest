use base "opensusebasetest";
use strict;
use testapi;

sub run {
    my $self = shift;

    assert_screen "media-check", 8;
    send_key $cmd{"next"}, 1;
}

1;
# vim: set sw=4 et:
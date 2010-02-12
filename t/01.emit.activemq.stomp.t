#!perl
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
use warnings;

BEGIN {
    use FindBin;
    use lib "$FindBin::Bin/lib";
}

use Test::More 0.92;
use Sys::Hostname;

BEGIN {
    $ENV{ TESTAPP_CONFIG } = "$FindBin::Bin/lib/testapp.conf";
}

#plan tests => 13;
use Catalyst::Test 'TestApp';

{
    eval "require Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp";
    is( $@, q{}, "no require errors" );

    # make a request
#'    ok( my ($res,$c) = ctx_request('http://localhost/foo/ok'), 'request ok' );

    ok( my ($res,$c) = ctx_request('http://localhost/foo/crash_obj'), 'crash it' );




#    # check the config
#    is_deeply(
#        $c->_errorcatcher_c_cfg->{'Plugin::ErrorCatcher::ActiveMQ::Stomp'},
#        {
#            destination => 'test-message',
#            hostname    => 'localhost',
#         #   port        => '',
#        },
#        'email emitter config ok',
#    );
#
#    my $config = Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp::_check_config(
#        $c, q{Dummy Output},
#    );
#    is( ref($config), q{HASH}, q{returned config is a hashref} );
#
#    # check the prepared config
#    is_deeply(
#        $config,
#        {
#            destination => 'test-message',
#            hostname    => 'localhost',
#            port        => '',
#        },
#        'email emitter config ok',
#    );
}





done_testing;

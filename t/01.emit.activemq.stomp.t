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
    ok( my ($res,$c) = ctx_request('http://localhost/foo/ok'), 'request ok' );
    # check the config
    is_deeply(
        $c->_errorcatcher_c_cfg->{'Plugin::ErrorCatcher::ActiveMQ::Stomp'},
        {
            destination => 'test-message',
            hostname    => 'localhost',
            port        => '',
        },
        'email emitter config ok',
    );

    my $config = Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp::_check_config(
        $c, q{Dummy Output},
    );
    is( ref($config), q{HASH}, q{returned config is a hashref} );

    # check the prepared config
    is_deeply(
        $config,
        {
            destination => 'test-message',
            hostname    => 'localhost',
            port        => '',
        },
        'email emitter config ok',
    );
}

{
    eval "require Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp";
    is( $@, q{}, "no require errors" );

    # make a request
    ok( my ($res,$c) = ctx_request('http://localhost/foo/ok'), 'request ok' );
    # munge the config
    $c->_errorcatcher_c_cfg->{'Plugin::ErrorCatcher::ActiveMQ::Stomp'} =
    {
        to => 'address@example.com',
    };

    my $config = Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp::_check_config(
        $c, q{Dummy Output},
    );
    is( ref($config), q{HASH}, q{returned config is a hashref} );

    # check the prepared config
    my $host = Sys::Hostname::hostname();

    is_deeply(
        $config,
        {
            to => 'address@example.com',
            from => 'address@example.com',
            subject => qq{Error Report for TestApp on $host},
        },
        'munged email emitter config ok',
    );
}

# test subject lines with tags
{
    eval "require Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp";
    is( $@, q{}, "no require errors" );

    my $host = Sys::Hostname::hostname();

    my @subject_line_tests = (
        { sub => 'Host: %h',    res => qq{Host: $host} },
        { sub => 'Line: %l',    res => qq{Line: 30} },
        { sub => 'File: %F',    res => qq{File: TestApp/Controller/Foo.pm} },
        { sub => 'Package: %p', res => qq{Package: TestApp::Controller::Foo} },
        { sub => 'Version: %V', res => qq{Version: v0.0.2} },
        { sub => 'Name: %n',    res => qq{Name: TestApp} },
    );

    # make a request; we need an error to get the stacktrace
    open STDERR, '>/dev/null'; # hide errors
    ok( my ($res,$c) = ctx_request('http://localhost/foo/not_ok'), 'request ok' );

    # loop through each subject/result test-pair, set the config value(s) and
    # check the results
    foreach my $test (@subject_line_tests) {
        # munge the config
        $c->_errorcatcher_c_cfg->{'Plugin::ErrorCatcher::ActiveMQ::Stomp'} =
        {
            to          => 'address@example.com',
            subject     => $test->{sub},
            use_tags    => 1,
        };

        my $config = Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp::_check_config(
            $c, q{Dummy Output},
        );
        is( ref($config), q{HASH}, q{returned config is a hashref} );

        # check the prepared config

        is_deeply(
            $config,
            {
                to          => 'address@example.com',
                from        => 'address@example.com',
                subject     => $test->{res},
                use_tags    => 1,
            },
            "subject line ok: $test->{res}",
        );
    }
}




done_testing;

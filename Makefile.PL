use inc::Module::Install;

name     'Catalyst-Plugin-ErrorCatcher-ActiveMQ-Stomp';
all_from 'lib/Catalyst/Plugin/ErrorCatcher/ActiveMQ/Stomp.pm';
author   'Jason Tang <tang.jason.ch@gmail.com>';

build_requires 'Test::More';

requires(
    'Catalyst::Plugin::ErrorCatcher'    => '0.0.6.5',
);
auto_install;

WriteAll;


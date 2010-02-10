use inc::Module::Install;

name     'Catalyst-Plugin-ErrorCatcher-ActiveMQ-Stomp';
all_from 'lib/Catalyst/Plugin/ErrorCatcher/ActiveMQ/Stomp.pm';
author   'Jason Tang <tang.jason.ch@gmail.com>';

build_requires 'Test::More';

auto_install;

WriteAll;


package Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp;

use Moose;
use Net::Stomp;
use Data::Dump qw/pp/;
use Data::Serializer;
use MooseX::Types -declare => [qw/Serializer/];
use MooseX::Types::Moose qw/Str HashRef/;
use Moose::Util::TypeConstraints;

=head1 NAME

Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp - The great new Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp!

=head1 VERSION

Version 0.01

=cut

use version; our $VERSION = qv(0.1.0)->numify;


class_type 'Data::Serializer';
subtype Serializer, as 'Data::Serializer';
coerce Serializer, from 'Str',
    via { Data::Serializer->new( serializer => $_ ) };

has serializer => (
    is          => 'ro',
    isa         => Serializer,
    required    => 1,
    default     => 'JSON',
    coerce      => 1,
);

has destination => (
    is          => 'rw',
    isa         => 'Str',
);

has hostname => (
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
);

has port => (
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
);

has connection => (
    is          => 'ro',
    isa         => 'Net::Stomp',
    lazy        => 1,
    builder     => '_build_connection',
);

sub _build_connection {
    my ($self) = @_;

    return Net::Stomp->new({
        hostname    => $self->hostname,
        port        => $self->port,
    });
}


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp;

    my $foo = Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 emit

=cut

sub emit {
    my($self,$c,$content) = @_;

    my $send_data = {
        destination     => $self->destination,
        body            => $self->serializer->raw_serializer($content),
    };
    $self->connection->connect();

    $self->debug("Sending ". pp($send_data));

    $self->connection->send( $send_data );

    $self->connection->disconnect();

    return;
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Jason Tang, C<< <tang.jason.ch at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-catalyst-plugin-errorcatcher-activemq-stomp at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Catalyst-Plugin-ErrorCatcher-ActiveMQ-Stomp>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Catalyst-Plugin-ErrorCatcher-ActiveMQ-Stomp>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Catalyst-Plugin-ErrorCatcher-ActiveMQ-Stomp>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Catalyst-Plugin-ErrorCatcher-ActiveMQ-Stomp>

=item * Search CPAN

L<http://search.cpan.org/dist/Catalyst-Plugin-ErrorCatcher-ActiveMQ-Stomp>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2010 Jason Tang, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Catalyst::Plugin::ErrorCatcher::ActiveMQ::Stomp

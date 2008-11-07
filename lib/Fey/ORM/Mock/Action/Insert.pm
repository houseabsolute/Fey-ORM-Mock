package Fey::ORM::Mock::Action::Insert;

use strict;
use warnings;

use Moose;
use MooseX::StrictConstructor;

extends 'Fey::ORM::Mock::Action';

has 'values' =>
    ( is       => 'ro',
      isa      => 'HashRef[Item]',
      required => 1,
    );

no Moose;

__PACKAGE__->meta()->make_immutable();

1;

__END__

=pod

=head1 NAME

Fey::ORM::Mock::Action::Insert - A record of an insert

=head1 DESCRIPTION

This class represents a record of a call to C<insert()> for a
C<Fey::ORM::Table> based object.

=head1 METHODS

This class provides the following methods:

=head2 $action->values()

Returns the values of the row inserted as a hash reference, with the
attribute names as keys. These values are provided as-is, so they may
include objects passed to C<insert()>

=head1 AUTHOR

Dave Rolsky, C<< <autarch@urth.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2008 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

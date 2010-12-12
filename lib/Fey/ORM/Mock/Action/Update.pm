package Fey::ORM::Mock::Action::Update;

use strict;
use warnings;

use Moose;
use MooseX::StrictConstructor;

extends 'Fey::ORM::Mock::Action';

has 'pk' => (
    is       => 'ro',
    isa      => 'HashRef[Value]',
    required => 1,
);

has 'values' => (
    is       => 'ro',
    isa      => 'HashRef[Item]',
    required => 1,
);

no Moose;

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: A record of an update

__END__

=pod

=head1 DESCRIPTION

This class represents a record of a call to C<update()> for a
C<Fey::ORM::Table> based object.

=head1 METHODS

This class provides the following methods:

=head2 $action->pk()

Returns the primary key of the row update as a hash reference, with
the attribute names as keys.

=head2 $action->values()

Returns the values updated as a hash reference, with the attribute
names as keys. These values are provided as-is, so they may include
objects passed to C<update()>

=cut

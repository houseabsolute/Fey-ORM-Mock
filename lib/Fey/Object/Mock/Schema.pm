package Fey::Object::Mock::Schema;

use strict;
use warnings;

use DBD::Mock;

use Moose;

extends 'Fey::Object::Schema';

# It'd be nice to use MooseX::ClassAttribute, but then we end up with
# a metaclass incompatibility, and shit blows up.
{
    my %Recorders;

    sub Recorder {
        my $class = shift;

        return $Recorders{$class};
    }

    sub SetRecorder {
        my $class = shift;

        $Recorders{$class} = shift;
    }
}

no Moose;

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: Mock schema class subclass of Fey::Object::Schema

__END__

=pod

=head1 DESCRIPTION

When you use L<Fey::ORM::Mock> to mock a schema, this class will
become your schema class's immediate parent. It in turn inherits from
C<Fey::Object::Schema>.

You will probably never need to use any of this class's methods, however.

=head1 METHODS

This class provides the following methods:

=head2 $class->Recorder

Returns the L<Fey::ORM::Mock::Recorder> object associated with the
schema.

=head2 $class->SetRecorder($recorder)

Sets the L<Fey::ORM::Mock::Recorder> object associated with the
schema.

=cut

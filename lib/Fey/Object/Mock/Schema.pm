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

    sub Recorder
    {
        my $class = shift;

        return $Recorders{$class};
    }

    sub SetRecorder
    {
        my $class = shift;

        $Recorders{$class} = shift;
    }
}

no Moose;

__PACKAGE__->meta()->make_immutable();

1;

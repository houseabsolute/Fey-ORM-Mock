package Fey::Object::Mock::Action::Delete;

use strict;
use warnings;

use Moose;
use MooseX::StrictConstructor;

extends 'Fey::Object::Mock::Action';

has 'pk' =>
    ( is       => 'ro',
      isa      => 'HashRef[Value]',
      required => 1,
    );

no Moose;

__PACKAGE__->meta()->make_immutable();

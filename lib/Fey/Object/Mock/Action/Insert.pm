package Fey::Object::Mock::Action::Insert;

use strict;
use warnings;

use Moose;
use MooseX::StrictConstructor;

extends 'Fey::Object::Mock::Action';

has 'values' =>
    ( is       => 'ro',
      isa      => 'HashRef[Item]',
      required => 1,
    );

no Moose;

__PACKAGE__->meta()->make_immutable();

1;

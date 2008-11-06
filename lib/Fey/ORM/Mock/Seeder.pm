package Fey::ORM::Mock::Seeder;

use strict;
use warnings;

use Moose;

has '_data' =>
    ( metaclass => 'Collection::Array',
      is        => 'ro',
      isa       => 'ArrayRef[HashRef]',
      default   => sub { [] },
      provides  => { push  => 'push_values',
                     shift => 'next',
                   },
    );

1;

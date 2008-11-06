package Fey::ORM::Mock::Action;

use strict;
use warnings;

use Moose;
use MooseX::StrictConstructor;
use Moose::Util::TypeConstraints;
use MooseX::Params::Validate qw( validate );

has class =>
    ( is       => 'ro',
      isa      => 'ClassName',
      required => 1,
    );

subtype 'Fey.Mock.ORM.ActionType'
    => as 'Str'
    => where { $_[0] =~ /^(?:insert|update|delete)$/ };

has type =>
    ( is       => 'ro',
      isa      => 'Fey.Mock.ORM.ActionType',
      required => 1,
    );


sub new_action
{
    my $class = shift;
    my %p     = validate( \@_,
                          action => { isa => 'Fey.Mock.ORM.ActionType' },
                          class  => { isa => 'ClassName' },
                          values => { isa      => 'HashRef',
                                      optional => 1,
                                    },
                          pk     => { isa      => 'HashRef',
                                      optional => 1,
                                    },
                        );

    my $action = delete $p{action};

    my $real_class = $class . q{::} . ucfirst $action;

    return $real_class->new( %p, type => $action );
}

# needs to come after attributes are defined
require Fey::ORM::Mock::Action::Insert;
require Fey::ORM::Mock::Action::Update;
require Fey::ORM::Mock::Action::Delete;

no Moose;
no Moose::Util::TypeConstraints;

__PACKAGE__->meta()->make_immutable();

1;

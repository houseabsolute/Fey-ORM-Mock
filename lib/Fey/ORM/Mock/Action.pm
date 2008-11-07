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

__END__

=pod

=head1 NAME

Fey::ORM::Mock::Action - Factory and base class for recorded actions

=head1 DESCRIPTION

This class acts as a factory and base class for actions which are
recorded by the mocking layer.

=head1 METHODS

This class provides the following methods:

=head2 Fey::ORM::Mock::Action->new_action( ... )

This method accepts all the parameters that would be provided to an
action subclass, and uses the "type" parameter to determine which
subclass to instantiate.

You will probably not need to instantiate this class directly, instead
just use C<< Fey::ORM::Mock::Recorder->record_action() >>.

=head2 $action->class()

Returns the associated class for an action.

=head2 $action->type()

Returns the type for an action, one of "insert", "update", or
"delete".

=head1 AUTHOR

Dave Rolsky, C<< <autarch@urth.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2008 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

package Fey::ORM::Mock::Recorder;

use strict;
use warnings;

use Fey::ORM::Mock::Action;

use Moose;

has '_actions' =>
    ( is      => 'ro',
      isa     => 'HashRef[ArrayRef[Fey::ORM::Mock::Action]]',
      default => sub { {} },
    );


sub record_action
{
    my $self = shift;

    my $action = Fey::ORM::Mock::Action->new_action(@_);

    $self->_actions()->{ $action->class() } ||= [];
    push @{ $self->_actions()->{ $action->class() } }, $action;

    return;
}

sub actions_for_class
{
    my $self  = shift;
    my $class = shift;

    return @{ $self->_actions()->{$class} || [] };
}

sub clear_class
{
    my $self  = shift;
    my $class = shift;

    $self->_actions()->{$class} = [];
}

sub clear_all
{
    my $self = shift;

    for my $class ( keys %{ $self->_actions() } )
    {
        $self->clear_class($class);
    }
}

no Moose;

__PACKAGE__->meta()->make_immutable();

1;

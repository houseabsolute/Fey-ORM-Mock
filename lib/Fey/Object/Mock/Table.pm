package Fey::Object::Mock::Table;

use strict;
use warnings;

use Fey::Meta::Class::Schema;

use Moose;

extends 'Fey::Object::Table';


sub insert_many
{
    my $class = shift;
    my @rows  = @_;

    $class->__record_insert($_) for @rows;

    return $class->SUPER::insert_many(@rows);
}

sub __record_insert
{
    my $class = shift;
    my $vals  = shift;

    $class->__recorder->record_action( action => 'insert',
                                       class  => $class,
                                       values => $vals,
                                     );
}

sub update
{
    my $self = shift;
    my %p    = @_;

    $self->__record_update(\%p);

    $self->SUPER::update(%p);
}

sub __record_update
{
    my $self = shift;
    my $vals = shift;

    $self->__recorder->record_action( action => 'update',
                                      class  => ( ref $self ),
                                      values => $vals,
                                      pk     => { $self->pk_values_hash() },
                                    );
}

sub delete
{
    my $self = shift;

    $self->__record_delete();

    $self->SUPER::delete(@_);
}

sub __record_delete
{
    my $self = shift;

    $self->__recorder->record_action( action => 'delete',
                                      class  => ( ref $self ),
                                      pk     => { $self->pk_values_hash() },
                                    );
}

sub __recorder
{
    my $self = shift;

    return
        Fey::Meta::Class::Schema->ClassForSchema( $self->Table->schema )->Recorder();
}

sub _load_from_dbms
{
    my $self = shift;

    if ( my $values = $self->Seeder()->next() )
    {
        $self->_set_column_values_from_hashref($values);

        return;
    }

    return $self->SUPER::_load_from_dbms(@_);
}

{
    my %Seeder;

    sub Seeder
    {
        my $self = shift;

        return $Seeder{ ref $self || $self };
    }

    sub SetSeeder
    {
        my $self = shift;

        return $Seeder{ ref $self || $self } = shift;
    }
}

no Moose;

__PACKAGE__->meta()->make_immutable();

1;

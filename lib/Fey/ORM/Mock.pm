package Fey::ORM::Mock;

use strict;
use warnings;

our $VERSION = '0.01';

use Class::MOP;
use DBD::Mock;
use Fey::DBIManager;
use Fey::Object::Mock::Schema;
use Fey::Object::Mock::Table;
use Fey::ORM::Mock::Recorder;
use Fey::ORM::Mock::Seeder;
use Fey::Meta::Class::Table;

use Moose;

has 'schema_class' =>
    ( is       => 'ro',
      isa      => 'ClassName',
      required => 1,
    );

has 'dbh' =>
    ( is       => 'rw',
      isa      => 'DBI::db',
      writer   => '_set_dbh',
      init_arg => undef,
    );

has 'recorder' =>
    ( is       => 'rw',
      isa      => 'Fey::ORM::Mock::Recorder',
      writer   => '_set_recorder',
      init_arg => undef,
    );


sub BUILD
{
    my $self = shift;

    $self->_mock_schema();

    $self->_mock_dbi();
}

sub _mock_schema
{
    my $self = shift;

    $self->_replace_superclass( $self->schema_class(), 'Fey::Object::Mock::Schema' );

    my $recorder = Fey::ORM::Mock::Recorder->new();
    $self->schema_class()->SetRecorder($recorder);
    $self->_set_recorder($recorder);

    $self->_mock_table($_) for $self->schema_class()->Schema()->tables();
}

sub _replace_superclass
{
    my $self       = shift;
    my $class      = shift;
    my $superclass = shift;

    Class::MOP::load_class($class);

    my $meta = $class->meta();

    my $was_immutable = 0;

    if ( $meta->is_immutable() )
    {
        $was_immutable = 1;
        $meta->make_mutable();
    }

    $meta->superclasses($superclass);

    $meta->make_immutable()
        if $was_immutable;
}

sub _mock_table
{
    my $self  = shift;
    my $table = shift;

    my $class = Fey::Meta::Class::Table->ClassForTable($table)
        or die "Cannot find a class for " . $table->name() . "\n";

    $self->_replace_superclass( $class, 'Fey::Object::Mock::Table' );

    my $seed = Fey::ORM::Mock::Seeder->new();
    $class->SetSeeder($seed);
}

sub seed_class
{
    my $self  = shift;
    my $class = shift;

    my $seed = $class->Seeder();

    $seed->push_values(@_);
}

sub _mock_dbi
{
    my $self = shift;

    my $dsn = 'dbi:Mock:';

    my $dbh = DBI->connect( $dsn, q{}, q{} );
    $self->_set_dbh($dbh);

    my $manager = Fey::DBIManager->new();
    $manager->add_source( dsn => $dsn, dbh => $dbh );

    $self->schema_class()->SetDBIManager($manager);
}

1;

__END__

=pod

=head1 NAME

Fey::ORM::Mock - Mock Fey::ORM based classes so you can test without a database

=head1 SYNOPSIS

    use Fey::ORM::Mock;
    use MyApp::Schema;

    my $mock = Fey::ORM::Mock->new( schema_class => 'MyApp::Schema' );

    ...

=head1 DESCRIPTION

=head1 METHODS

This class provides the following methods

=head1 AUTHOR

Dave Rolsky, C<< <autarch@urth.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-fey-mock@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2008 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

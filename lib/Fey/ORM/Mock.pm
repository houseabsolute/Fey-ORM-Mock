package Fey::ORM::Mock;

use strict;
use warnings;

our $VERSION = '0.01';

use Class::MOP;
use DBD::Mock;
use Fey::DBIManager;
use Fey::Object::Mock::Schema;
use Fey::Object::Mock::Table;
use Fey::Meta::Class::Table;
use Params::Validate qw( validate_pos );

use Exporter qw( import );

our @EXPORT = qw( mock_schema );


sub mock_schema
{
    my ($schema) = validate_pos( @_, { isa => 'Fey::Object::Schema' } );

    _replace_superclass( $schema, 'Fey::Object::Mock::Schema' );

    _mock_table($_) for $schema->Schema()->tables();

    _mock_dbi($schema);
}

sub _replace_superclass
{
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
    my $table = shift;

    my $class = Fey::Meta::Class::Table->ClassForTable($table)
        or die "Cannot find a class for " . $table->name() . "\n";

    _replace_superclass( $class, 'Fey::Object::Mock::Table' );
}

sub _mock_dbi
{
    my $schema = shift;

    my $manager = Fey::DBIManager->new();
    $manager->add_source( dsn => 'dbi:Mock:' );

    $schema->SetDBIManager($manager);
}

1;

__END__

=pod

=head1 NAME

Fey::ORM::Mock - Mock Fey::ORM based classes so you can test without a database

=head1 SYNOPSIS

    use Fey::ORM::Mock;
    use MyApp::Schema;

    mock_schema('MyApp::Schema')

    ...

=head1 DESCRIPTION

=head1 METHODS

This class provides the following methods

=head1 AUTHOR

Dave Rolsky, C<< <autarch@urth.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-fey-mock@rt.cpan.org>,
or through the web interface at L<http://rt.cpan.org>.  I will be
notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2008 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

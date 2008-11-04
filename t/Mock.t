use strict;
use warnings;

use Test::More tests => 25;

use Fey::ORM::Mock;
use Fey::Test;


{
    my $Schema = Fey::Test->mock_test_schema_with_fks();

    package Test::Schema;

    use Fey::ORM::Schema;

    has_schema $Schema;

    my $source = Fey::DBIManager::Source->new( dsn => 'dbi:SQLite:' );

    __PACKAGE__->DBIManager()->add_source($source);


    package User;

    use Fey::ORM::Table;

    has_table( $Schema->table('User') );


    package Message;

    use Fey::ORM::Table;

    has_table( $Schema->table('Message') );


    package Group;

    use Fey::ORM::Table;

    has_table( $Schema->table('Group') );


    package UserGroup;

    use Fey::ORM::Table;

    has_table( $Schema->table('UserGroup') );
}

mock_schema('Test::Schema');

ok( Test::Schema->isa('Fey::Object::Mock::Schema'),
    'after mock_schema() Test::Schema inherits from Fey::Object::Mock::Schema' );

for my $class ( qw( User Message Group UserGroup ) )
{
    ok( $class->isa('Fey::Object::Mock::Table'),
        "after mock_schema() $class inherits from Fey::Object::Mock::Table" );
}

isa_ok( Test::Schema->Recorder(), 'Fey::Object::Mock::Recorder',
        'Test::Schema->Recorder() returns a new recorder object' );

is( User->_dbh()->{Driver}{Name}, 'Mock',
    'DBI handle is for DBD::Mock' );

{
    my $user = User->insert( username => 'Bob' );

    isa_ok( $user, 'User',
            'mocked insert() return an object' );

    is( scalar Test::Schema->Recorder()->actions_for_class('Message'), 0,
        'no actions for the Message class' );

    my @actions = Test::Schema->Recorder()->actions_for_class('User');
    is( scalar @actions, 1,
        'one action for the User class' );

    is( $actions[0]->type(), 'insert',
        'action type is insert' );
    is( $actions[0]->class(), 'User',
        'action class is User' );
    is_deeply( $actions[0]->values(),
               { username => 'Bob' },
               'action values contains expected data' );

    Test::Schema->Recorder()->clear_class('User');
    is( scalar Test::Schema->Recorder()->actions_for_class('User'), 0,
        'no actions for the User class after clearing' );
}

{
    my $user = User->insert( user_id  => 33,
                             username => 'Bob' );

    $user->update( username => 'John',
                   email    => 'john@example.com',
                 );

    my $message = Message->insert( message => 'blah blah' );

    is( scalar Test::Schema->Recorder()->actions_for_class('Message'), 1,
        'one action for the Message class' );

    my @actions = Test::Schema->Recorder()->actions_for_class('User');
    is( scalar @actions, 2,
        'two actions for the User class' );

    is( $actions[0]->type(), 'insert',
        'first action type is insert' );
    is( $actions[1]->type(), 'update',
        'second action type is update' );
    is_deeply( $actions[1]->values(),
               { username => 'John',
                 email    => 'john@example.com',
               },
               'update values contains expected data' );
    is_deeply( $actions[1]->pk(),
               { user_id => 33 },
               'update pk contains expected data' );

    $user->delete();

    @actions = Test::Schema->Recorder()->actions_for_class('User');
    is( scalar @actions, 3,
        'three actions for the User class after deleting user' );
    is( $actions[2]->type(), 'delete',
        'third action type is delete' );
    is_deeply( $actions[2]->pk(),
               { user_id => 33 },
               'delete pk contains expected data' );

    Test::Schema->Recorder()->clear_all();

    is( scalar Test::Schema->Recorder()->actions_for_class('Message'), 0,
        'no actions for the Message class after clear_all' );
    is( scalar Test::Schema->Recorder()->actions_for_class('User'), 0,
        'no actions for the User class after clear_all' );
}

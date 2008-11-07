use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new
    ( module_name        => 'Fey::ORM::Mock',
      license            => 'perl',
      requires           => { 'Class::MOP'                => 0,
                              'DBD::Mock'                 => '0',
                              'Fey::DBIManager'           => '0.08',
                              'Fey::ORM'                  => '0.12',
                              'Moose'                     => '0',
                              'MooseX::Params::Validate'  => '0',
                              'MooseX::StrictConstructor' => '0',
                            },
      build_requires     => { 'Fey::Test' => '0.05',
                              'Test::More' => '0',
                            },
      create_makefile_pl => 'passthrough',
      create_readme      => 1,
      sign               => 1,
    );

$builder->create_build_script();

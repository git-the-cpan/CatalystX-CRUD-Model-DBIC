use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'CatalystX::CRUD::Model::DBIC',
    AUTHOR              => 'Peter Karman <karman@cpan.org>',
    VERSION_FROM        => 'lib/CatalystX/CRUD/Model/DBIC.pm',
    ABSTRACT_FROM       => 'lib/CatalystX/CRUD/Model/DBIC.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'CatalystX::CRUD' => '0.22',
        'DBIx::Class' => 0,
        'Catalyst::Model::DBIC::Schema' => 0,


    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'CatalystX-CRUD-Model-DBIC-*' },
);

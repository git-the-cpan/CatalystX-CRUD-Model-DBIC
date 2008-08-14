#!perl -T

use Test::More tests => 1;
use lib qw( ../../CatalystX-CRUD/trunk/lib t );

BEGIN {
	use_ok( 'CatalystX::CRUD::Model::DBIC' );
}

diag( "Testing CatalystX::CRUD::Model::DBIC $CatalystX::CRUD::Model::DBIC::VERSION, Perl $], $^X" );

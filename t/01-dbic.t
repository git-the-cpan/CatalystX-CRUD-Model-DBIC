use Test::More tests => 10;

BEGIN {
    use lib qw( ../CatalystX-CRUD/lib t );
    use_ok('CatalystX::CRUD::Model::DBIC');
    use_ok('CatalystX::CRUD::Object::DBIC');

    system("cd t/ && $^X insertdb.pl") and die "can't create db: $!";
}

END { unlink('t/example.db'); }

use lib qw( t/lib );
use Catalyst::Test 'MyApp';
use Data::Dump qw( dump );

ok( my $res = request('/test1'), "get /test1" );
is( $res->content, 13, "right number of results" );
ok( $res = request('/test2?cd.title=Bad'), "get /test2" );
is( $res->content, 3, "iterator for cd.title=Bad" );
ok( $res = request('/test3?cd.title=Bad'), "get /test3" );
is( $res->content, 3, "search for cd.title=Bad" );
ok( $res = request('/test4?cd.title=Bad'), "get /test4" );
is( $res->content, 3, "count for cd.title=Bad" );

# TODO need some actual CRUD. so far all we've done is search/retrieve.
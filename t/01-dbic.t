use Test::More tests => 14;

BEGIN {
    use lib qw( ../../CatalystX-CRUD/trunk/lib t );
    use_ok('CatalystX::CRUD::Model::DBIC');
    use_ok('CatalystX::CRUD::Object::DBIC');

    system("cd t/ && $^X insertdb.pl") and die "can't create db: $!";
}

END { unlink('t/example.db') unless $ENV{PERL_DEBUG}; }

use lib qw( t/lib );
use Catalyst::Test 'MyApp';
use Data::Dump qw( dump );
use HTTP::Request::Common;

ok( my $res = request('/test1'), "get /test1" );
is( $res->content, 13, "right number of results" );
ok( $res = request('/test2?cd.title=Bad'), "get /test2" );
is( $res->content, 3, "iterator for cd.title=Bad" );
ok( $res = request('/test3?cd.title=Bad'), "get /test3" );
is( $res->content, 3, "search for cd.title=Bad" );
ok( $res = request('/test4?cd.title=Bad'), "get /test4" );
is( $res->content, 3, "count for cd.title=Bad" );

# read
ok( $res = request( HTTP::Request->new( GET => '/crud/1/view' ) ),
    "GET view" );

#diag( $res->content );
is( $res->content, '{ cd => 3, title => "Beat It", trackid => 1 }',
    "GET track 1" );

# create
ok( $res = request(
        POST(
            '/crud/0/save',
            [   cd      => 3,
                title   => 'Something New, Something Blue',
                trackid => 0
            ]
        )
    ),
    "POST new track"
);

#diag( $res->content );
is( $res->content,
    '{ cd => 3, title => "Something New, Something Blue", trackid => 8 }',
    "POST new track"
);

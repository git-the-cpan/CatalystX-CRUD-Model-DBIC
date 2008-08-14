package MyApp::Model::Main;
use base qw( CatalystX::CRUD::Model::DBIC );

__PACKAGE__->config(
    schema_class => 'MyDB::Main',
    connect_info =>
        [ 'dbi:SQLite:' . MyApp->path_to() . '/../../example.db' ],
    moniker        => 'Track',
    resultset_opts => {
        join     => [qw/ cd /],
        prefetch => [qw/ cd /]
        }

);

1;

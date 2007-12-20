package CatalystX::CRUD::Model::DBIC;
use strict;
use warnings;

use CatalystX::CRUD::Iterator;

# @INC order important!
use base qw(
    Catalyst::Model::DBIC::Schema
    CatalystX::CRUD::Model
    CatalystX::CRUD::Model::Utils
);

our $VERSION = '0.01';

__PACKAGE__->mk_ro_accessors(qw( resultset_opts moniker ));
__PACKAGE__->config->{object_class} = 'CatalystX::CRUD::Object::DBIC';

=head1 NAME

CatalystX::CRUD::Model::DBIC - DBIx::Class CRUD

=head1 SYNOPSIS

 package MyApp::Model::Foo;
 use base qw( CatalystX::CRUD::Model::DBIC );
 __PACKAGE__->config(
        resultset_opts  => {
            join     => [ 'bar' ],
            prefetch => [ 'bar' ]
        },
        moniker         => 'Foo',
        schema_class    => 'MyDB::Main',
        connect_info    =>
            [ 'dbi:SQLite:' . MyApp->path_to('my_foo.db') ],
        );
        
 1;

=head1 DESCRIPTION

CatalystX::CRUD::Model::DBIC is a CatalystX::CRUD implementation for DBIx::Class.
See the CatalystX::CRUD documentation.

=head1 METHODS

Only new or overridden methods are documented here.

=cut

=head2 new

Initialize the class at application start-up.

We implement new() instead of Xsetup() because of idiosyncracies of NEXT.

=cut

sub new {
    my ( $class, $c, $arg ) = @_;

    my $self = $class->NEXT::new( $c, $arg );
    $self->Xsetup( $c, $arg );

    # SQL for not equal
    $self->ne_sign('!=');

    $self->{moniker} = $self->config->{moniker};
    if ( !$self->moniker ) {
        return if $self->throw_error("need to configure a moniker value");
    }
    return $self;
}

sub _get_field_names {
    my $self = shift;
    return $self->{_field_names} if $self->{_field_names};

    my $obj  = $self->composed_schema->source( $self->moniker );
    my @cols = $obj->columns;
    my @rels = $obj->relationships;

    my @fields;
    for my $rel (@rels) {
        my $info      = $obj->relationship_info($rel);
        my $rel_class = $info->{source};
        my @rel_cols  = $rel_class->columns;
        push( @fields, map { $rel . '.' . $_ } @rel_cols );
    }
    for my $col (@cols) {
        push( @fields, 'me.' . $col );
    }

    $self->{_field_names} = \@fields;

    return \@fields;
}

=head2 new_object( @params )

Returns a new moniker() class object. @params are passed directly
to the schema()'s new() method.

=cut

sub new_object {
    my $self = shift;
    return $self->schema->resultset( $self->moniker )->new(@_);
}

=head2 fetch( @params )

@params are passed directly to the find() method of schema().

=cut

sub fetch {
    my $self = shift;
    return $self->schema->resultset( $self->moniker )->find(@_);
}

=head2 make_query( I<\@field_names> )

Create a query from the current request suitable for search(),
count() or iterator().

=cut

sub make_query {
    my $self        = shift;
    my $c           = $self->context;
    my $field_names = shift || $self->_get_field_names;

    # TODO sort order and limit/offset support
    # it's already in $q but need DBIC syntax

    my @query;
    my $q = $self->make_sql_query($field_names);

    push( @query, { @{ $q->{query} } }, $self->resultset_opts )
        if $self->resultset_opts;

    return \@query;
}

=head2 search( I<query> )

If not present, I<query> will default to the return value of make_query().

Returns an array or arrayref of CatalystX::CRUD::Object::DBIC objects depending
on context.

=cut

sub search {
    my $self    = shift;
    my $query   = shift || $self->make_query;
    my $class   = $self->object_class;
    my @results = map { $class->new( delegate => $_ ) }
        $self->schema->resultset( $self->moniker )->search(@$query);
    return wantarray ? @results : \@results;
}

=head2 iterator( I<query> )

If not present, I<query> will default to the return value of make_query().

=cut

sub iterator {
    my $self  = shift;
    my $query = shift || $self->make_query;
    my $rs    = $self->schema->resultset( $self->moniker )->search(@$query);
    return CatalystX::CRUD::Iterator->new( $rs, $self->object_class );
}

=head2 count( I<query> )

If not present, I<query> will default to the return value of make_query().

=cut

sub count {
    my $self = shift;
    my $query = shift || $self->make_query;
    return $self->schema->resultset( $self->moniker )->count(@$query);
}

=head1 AUTHOR

Peter Karman, C<< <karman at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-catalystx-crud-model-dbic at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CatalystX-CRUD-Model-DBIC>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CatalystX::CRUD::Model::DBIC

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CatalystX-CRUD-Model-DBIC>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CatalystX-CRUD-Model-DBIC>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CatalystX-CRUD-Model-DBIC>

=item * Search CPAN

L<http://search.cpan.org/dist/CatalystX-CRUD-Model-DBIC>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2007 Peter Karman, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;    # End of CatalystX::CRUD::Model::DBIC

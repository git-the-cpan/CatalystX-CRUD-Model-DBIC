package CatalystX::CRUD::Object::DBIC;
use strict;
use warnings;
use base qw( CatalystX::CRUD::Object );

our $VERSION = '0.03';

=head1 NAME

CatalystX::CRUD::Object::DBIC - DBIx::Class implementation of CatalystX::CRUD::Object **DEPRECATED**

=head1 SYNOPSIS

 # fetch a row from MyApp::Model::Foo (which isa CatalystX::CRUD::Model)
 my $foo = $c->model('Foo')->fetch( id => 1234 );
 $foo->create;
 $foo->read;
 $foo->update;
 $foo->delete;

=head1 DESCRIPTION

B<** THIS PACKAGE IS DEPRECATED. See Catalystx::CRUD::ModelAdapter::DBIC instead. **>

CatalystX::CRUD::Object::DBIC implements the required CRUD methods
of a CatalystX::CRUD::Object subclass. It is intended for use
with CatalystX::CRUD::Model::DBIC.

=head1 METHODS

Only new or overridden methods are documented here.

=head2 create

Calls delegate->insert().

=cut

# required methods
sub create {
    shift->delegate->insert(@_);
}

=head2 read

Calls delegate->find(@_).

=cut

sub read {
    shift->delegate->find(@_);
}

=head2 update

Calls delegate->update().

=cut

sub update {
    shift->delegate->update(@_);
}

=head2 delete

Calls delegate->delete(@_).

=cut

sub delete {
    shift->delegate->delete(@_);
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

1;    # End of CatalystX::CRUD::Object::DBIC

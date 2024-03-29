package Lingua::FreeLing2::Document;

use Lingua::FreeLing2::Bindings;
use parent -norequire, 'Lingua::FreeLing2::Bindings::document';

use warnings;
use strict;

our $VERSION = "0.01";

=encoding UTF-8

=head1 NAME

Lingua::FreeLing2::Document - Interface to FreeLing2 Documento objectt

=head1 SYNOPSIS

   use Lingua::FreeLing2::Document;

=head1 DESCRIPTION

This module is a wrapper to the FreeLing2 Document object.

=head2 CONSTRUCTOR

=over 4

=item C<new>

The constructor returns a new Document object.

=cut

sub new {
    my $class = shift;
    my $self = $class->SUPER::new();
    return bless $self => $class #amen
}


=pod

=back

=cut

1;

__END__

=head1 SEE ALSO

Lingua::FreeLing2(3) for the documentation table of contents. The
freeling library for extra information, or perl(1) itself.

=head1 AUTHOR

Alberto Manuel Brandão Simões, E<lt>ambs@cpan.orgE<gt>

Jorge Cunha Mendes E<lt>jorgecunhamendes@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011-2012 by Projecto Natura

=cut



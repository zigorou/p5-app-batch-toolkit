package App::Batch::ToolKit::Extractor::JSONHash;

use strict;
use warnings;
use parent qw(App::Batch::ToolKit::Extractor);
use JSON ();

our $VERSION = '0.01';

sub name() { 'jsonhash' }

sub setup {
    my $self = shift;
    unless ( @{ $self->rows } > 0 ) {
        my $fh = $self->fh;
        my $json    = do { local $|; <$fh>; };
        my $rows    = JSON::decode_json($json);
        if ( ref $rows eq 'HASH' ) {
            $rows = [$rows];
        }
        $self->rows($rows);
    }

    if ( @{ $self->fields } == 0 ) {
        $self->fields( [ keys %{ $self->rows->[0] } ] );
    }
}

sub fetchrow_arrayref {
    my $self = shift;
    my $row = $self->SUPER::fetchrow_arrayref;
    return defined $row ? [ @$row{@{$self->fields}} ] : undef;
}

sub fetchrow_hashref {
    shift->SUPER::fetchrow_arrayref;
}

1;

__END__

=head1 NAME

App::Batch::ToolKit::Extractor::JSONHash - write short description for App::Batch::ToolKit::Extractor::JSONHash

=head1 SYNOPSIS

  use App::Batch::ToolKit::Extractor::JSONHash;

=head1 DESCRIPTION

=head1 METHODS

=head1 AUTHOR

Toru Yamaguchi E<lt>zigorou@dena.jp<gt>

=head1 LICENSE

This module is licensed under the same terms as Perl itself.

=head1 SEE ALSO

=cut

# Local Variables:
# mode: perl
# perl-indent-level: 4
# indent-tabs-mode: nil
# coding: utf-8-unix
# End:
#
# vim: expandtab shiftwidth=4:

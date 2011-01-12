package App::Batch::ToolKit::Extractor::JSONArray;

use strict;
use warnings;
use parent qw(App::Batch::ToolKit::Formatter::Base);
use JSON ();

our $VERSION = '0.01';

sub name() { 'jsonarray' }

sub setup {
    my $self = shift;
    unless ( @{ $self->rows } > 0 ) {
        my $read_fh = $self->read_fh;
        my $json    = do { local $|; <$read_fh>; };
        my $rows    = JSON::decode_json($json);
        $self->rows( $rows );
    }

    if ( @{ $self->fields } == 0 && !$self->skip_column_names ) {
        $self->fields( $self->fetchrow_arrayref );
    }
}

1;

__END__

=head1 NAME

App::Batch::ToolKit::Extractor::JSONArray - write short description for App::Batch::ToolKit::Extractor::JSONArray

=head1 SYNOPSIS

  use App::Batch::ToolKit::Extractor::JSONArray;

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

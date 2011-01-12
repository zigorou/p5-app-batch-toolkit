package App::Batch::ToolKit::Formatter::JSONArray;

use strict;
use warnings;
use parent qw(App::Batch::ToolKit::Formatter);
use Class::Accessor::Lite (
    new => 0,
    rw => [ qw/rows/ ],
);
use JSON ();

our $VERSION = '0.01';

sub name() { 'jsonarray' }

sub prepare {
    my $self = shift;
    $self->rows([]);
}

sub process_row {
    my ( $self, $row ) = @_;
    push(@{$self->rows}, $row);
}

sub finalize {
    my $self = shift;
    my $json = JSON::encode_json( $self->rows );
    syswrite( $self->fh, $json, length $json );
    close($self->fh);
}

1;

__END__

=head1 NAME

App::Batch::ToolKit::Formatter::JSONArray - 

=head1 SYNOPSIS

  use App::Batch::ToolKit::Formatter::JSONArray;

=head1 DESCRIPTION

App::Batch::ToolKit::Formatter::JSONArray is 

=head1 METHODS

=head1 AUTHOR

Toru Yamaguchi E<lt>zigorou@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

# Local Variables:
# mode: perl
# perl-indent-level: 4
# indent-tabs-mode: nil
# coding: utf-8-unix
# End:
#
# vim: expandtab shiftwidth=4:

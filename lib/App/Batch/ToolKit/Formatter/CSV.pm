package App::Batch::ToolKit::Formatter::CSV;

use strict;
use warnings;
use parent qw(App::Batch::ToolKit::Formatter);
use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/csv/],
);
use Text::CSV;

our $VERSION = '0.01';

sub new {
    my ( $class, $extractor, %args ) = @_;

    $args{plugin_args} = +{}
      unless ( defined $args{plugin_args} && ref $args{plugin_args} eq 'HASH' );
    $args{plugin_args} = +{
        binary   => 1,
        eol      => "\r\n",
        sep_char => ',',
        %{ $args{plugin_args} },
    };
    $args{csv} = Text::CSV->new( $args{plugin_args} );

    $class->SUPER::new( $extractor, %args );
}

sub name() { 'csv' }

sub prepare {
    my $self = shift;
    $self->csv->print( $self->fh, $self->extractor->fields );
}

sub process_row {
    my ( $self, $row ) = @_;
    $self->csv->print( $self->fh, $row );
}

sub finalize {
    my $self = shift;
    $self->fh->close;
}

1;

__END__

=head1 NAME

App::Batch::ToolKit::Formatter::CSV - 

=head1 SYNOPSIS

  use App::Batch::ToolKit::Formatter::CSV;

=head1 DESCRIPTION

App::Batch::ToolKit::Formatter::CSV is 

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

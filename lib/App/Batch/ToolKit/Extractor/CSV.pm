package App::Batch::ToolKit::Extractor::CSV;

use strict;
use warnings;
use parent qw(App::Batch::ToolKit::Formatter::Base);
use Class::Accessor::Lite (
    new => 0,
    rw => [qw/csv is_streaming/]
);
use Text::CSV;

our $VERSION = '0.01';

sub name() { 'csv' }

sub new {
    my ( $class, %args ) = @_;
    
    $args{plugin_args} = +{}
      unless ( defined $args{plugin_args} && ref $args{plugin_args} eq 'HASH' );
    $args{plugin_args} = +{
        binary   => 1,
        eol      => "\r\n",
        sep_char => ',',
        %{ $args{plugin_args} },
    };
    $args{csv} = Text::CSV->new( $args{plugin_args} );

    $class->SUPER::new(%args);
}

sub setup {
    my $self = shift;

    $self->is_streaming(@{$self->data} > 0 ? 0 : 1);
    
    if ( @{ $self->fields } == 0 && !$self->skip_column_names ) {
        $self->fields( $self->csv->getline( $self->read_fh ) );
    }
}

sub fetchrow_arrayref {
    my $self = shift;
    if ( $self->is_streaming ) {
        return $self->csv->getline( $self->read_fh );
    }
    else {
        return $self->SUPER::fetchrow_arrayref;
    }
}

1;

__END__

=head1 NAME

App::Batch::ToolKit::Extractor::CSV - write short description for App::Batch::ToolKit::Extractor::CSV

=head1 SYNOPSIS

  use App::Batch::ToolKit::Extractor::CSV;

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

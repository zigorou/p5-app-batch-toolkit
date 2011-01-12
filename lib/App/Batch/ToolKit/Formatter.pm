package App::Batch::ToolKit::Formatter;

use strict;
use warnings;

use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/extractor fh skip_column_names is_streaming plugin_args/],
);

our $VERSION = '0.01';

sub new {
    my ( $class, $extractor, %args ) = @_;

    $args{extractor} = $extractor;
    $args{fh} ||= *STDOUT;
    $args{skip_column_names} = 0 unless defined $args{skip_column_names};
    $args{is_streaming}      = 0 unless defined $args{is_streaming};

    my $self = bless +{%args} => $class;
    $self->setup;
    return $self;
}

sub name()         { 'base' }
sub fetch_method() { 'fetchrow_arrayref' }

sub setup { my $self = shift; }

sub write {
    my $self = shift;
    $self->prepare;
    $self->process;
    $self->finalize;
}

sub prepare { my $self = shift; }

sub process {
    my $self = shift;
    my $iter = $self->extractor->iterator( $self->fetch_method, 1 );
    while ( my $entry = $iter->next ) {
        $self->process_row($entry);
    }
}

sub process_row {
    my ( $self, $row ) = @_;
}

sub finalize { my $self = shift; }

1;

__END__

=head1 NAME

App::Batch::ToolKit::Formatter - 

=head1 SYNOPSIS

  use App::Batch::ToolKit::Formatter;

=head1 DESCRIPTION

App::Batch::ToolKit::Formatter is 

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

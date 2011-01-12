package App::Batch::ToolKit::Extractor;

use strict;
use warnings;

use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/fields rows fh skip_column_names is_streaming plugin_args/],
);
use Iterator::Simple ();
use Data::Dump qw(dump);

our $VERSION = '0.01';

sub new {
    my ( $class, %args ) = @_;

    $args{fh}     ||= *STDIN;
    $args{fields} ||= [];
    $args{rows}   ||= [];
    $args{skip_column_names} = 0 unless defined $args{skip_column_names};
    $args{is_streaming}      = 0 unless defined $args{is_streaming};

    my $self = bless +{%args} => $class;
    $self->setup;
    return $self;
}

sub name() { 'base' }
sub setup { my $self = shift; }

sub fetchrow_arrayref {
    my $self = shift;
    return shift @{ $self->rows };
}

sub fetchrow_hashref {
    my $self = shift;
    my $row  = $self->fetchrow_arrayref;
    return unless defined $row;
    my %h;
    @h{ @{ $self->fields } } = @$row;
    return \%h;
}

sub arrayref_iterator {
    my ( $self, $size ) = @_;
    $self->iterator( 'fetchrow_arrayref', $size );
}

sub hashref_iterator {
    my ( $self, $size ) = @_;
    $self->iterator( 'fetchrow_hashref', $size );
}

sub iterator {
    my ( $self, $fetchrow_method, $size ) = @_;
    $size ||= 1;
    Iterator::Simple::iterator {
        my @next;
        my $i = 0;
        while ( $i++ < $size ) {
            my $row = $self->$fetchrow_method;
            last unless defined $row;
            push( @next, $row );
        }

        return $size > 1 ? ( @next > 0 ? \@next : undef ) : $next[0];
    };
}

1;

__END__

=head1 NAME

App::Batch::ToolKit::Extractor - write short description for App::Batch::ToolKit::Extractor

=head1 SYNOPSIS

  use App::Batch::ToolKit::Extractor;

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

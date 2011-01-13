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
    my ( $self, $columns ) = @_;
    $columns ||= [ 0 .. scalar( @{ $self->fields } ) - 1 ];
    my $row = shift @{ $self->rows };
    return $row unless defined $row;
    return [ @$row[@$columns] ];
}

sub fetchrow_hashref {
    my ( $self, $slices ) = @_;
    my $columns = $self->slices_to_columns($slices);
    my $row     = $self->fetchrow_arrayref($columns);
    return unless defined $row;
    my %h;
    @h{ @{ $self->fields }[@$columns] } = @$row;
    return \%h;
}

sub slices_to_columns {
    my ( $self, $slices ) = @_;
    return [ 0 .. scalar( @{ $self->fields } ) - 1 ] unless defined $slices;

    my $columns = [];
    for ( my $i = 0 ; $i < @{ $self->fields } ; $i++ ) {
        my $field = $self->fields->[$i];
        push( @$columns, $i ) if ( $slices->{$field} );
    }

    return $columns;
}

sub columns_to_slices {
    my ( $self, $columns ) = @_;
    $columns ||= [ 0 .. scalar( @{ $self->fields } ) - 1 ];
    return +{ map { $_ => 1 } @{ $self->fields }[@$columns] };
}

sub arrayref_iterator {
    my ( $self, $attrs, $size ) = @_;
    $attrs ||= [];
    $self->iterator( 'fetchrow_arrayref', $attrs, $size );
}

sub hashref_iterator {
    my ( $self, $attrs, $size ) = @_;
    $attrs ||= +{};
    $self->iterator( 'fetchrow_hashref', $attrs, $size );
}

sub iterator {
    my ( $self, $fetchrow_method, $attrs, $size ) = @_;
    $size ||= 1;
    Iterator::Simple::iterator {
        my @next;
        my $i = 0;
        while ( $i++ < $size ) {
            my $row = $self->$fetchrow_method($attrs);
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

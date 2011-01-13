package App::Batch::ToolKit;

use strict;
use warnings;

use Carp;
use Class::Accessor::Lite (
    new => 0,
    rw => [ qw/extractor_map formatter_map/ ],
);
use Module::Pluggable::Object;
use Data::Dump qw(dump);

our $VERSION = '0.01';

sub new {
    my $class = shift;

    my $extractor_plugins = Module::Pluggable::Object->new(
	require => 1,
	search_path => [ qw/App::Batch::ToolKit::Extractor/ ],
    );
    my $formatter_plugins = Module::Pluggable::Object->new(
        require => 1,
        search_path => [ qw/App::Batch::ToolKit::Formatter/ ],
    );

    bless +{
	extractor_map => +{
	    map { $_->name => $_ }
	    $extractor_plugins->plugins
	},
	formatter_map => +{
	    map { $_->name => $_ }
	    $formatter_plugins->plugins
	},
    } => $class;
}

sub new_extractor {
    my ( $self, $name, %args ) = @_;
    unless ( exists $self->extractor_map->{$name} ) {
	croak( sprintf('Not supported extractor (name: %s)', $name) );
    }
    return $self->extractor_map->{$name}->new( %args );
}

sub new_formatter {
    my ( $self, $name, $extractor, %args ) = @_;
    unless ( exists $self->formatter_map->{$name} ) {
	croak( sprintf('Not supported formatter (name: %s)', $name) );
    }
    return $self->formatter_map->{$name}->new( $extractor, %args );
}

1;
__END__

=head1 NAME

App::Batch::ToolKit -

=head1 SYNOPSIS

  use App::Batch::ToolKit;

=head1 DESCRIPTION

App::Batch::ToolKit is

=head1 AUTHOR

Toru Yamaguchi E<lt>zigorou@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

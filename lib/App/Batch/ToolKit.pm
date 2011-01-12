package App::Batch::ToolKit;

use strict;
use warnings;

use Class::Accessor::Lite (
    new => 0,
    rw => [ qw/formatter_map formatters/ ],
);
use Module::Pluggable::Object;
use Data::Dump qw(dump);

our $VERSION = '0.01';

sub new {
    my $class = shift;

    my $mp = Module::Pluggable::Object->new(
        require => 1,
        search_path => [ qw/App::Batch::ToolKit::Formatter::Plugin/ ],
    );

    
    
    bless {
        formatters => [ $mp->plugins ],
        formatter_map => +{},
    } => $class;
}

sub read {
    my ( $self, $format, $fh ) = @_;
}

sub write {
    my ( $self, $format, $fh, $data ) = @_;
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

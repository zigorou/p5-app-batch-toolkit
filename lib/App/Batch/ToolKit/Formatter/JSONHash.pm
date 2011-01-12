package App::Batch::ToolKit::Formatter::JSONHash;

use strict;
use warnings;
use parent qw(App::Batch::ToolKit::Formatter::JSONArray);

our $VERSION = '0.01';

sub name() { 'jsonhash' }
sub fetch_method { 'fetchrow_hashref' }

1;

__END__

=head1 NAME

App::Batch::ToolKit::Formatter::JSONHash - 

=head1 SYNOPSIS

  use App::Batch::ToolKit::Formatter::JSONHash;

=head1 DESCRIPTION

App::Batch::ToolKit::Formatter::JSONHash is 

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

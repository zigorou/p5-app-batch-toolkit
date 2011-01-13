use strict;
use warnings;

use Test::More;
use App::Batch::ToolKit::Extractor;

my $e = App::Batch::ToolKit::Extractor->new(
    fields => [qw/foo bar baz/],
);

is_deeply( $e->columns_to_slices(), +{ foo => 1, bar => 1, baz => 1 }, 'No appears columns args' );
is_deeply( $e->columns_to_slices([ 0 ]), +{ foo => 1, }, '0' );
is_deeply( $e->columns_to_slices([ 0, 2 ]), +{ foo => 1, baz => 1, }, '0, 2' );
is_deeply( $e->columns_to_slices([ 0, 1, 2 ]), +{ foo => 1, bar => 1, baz => 1, }, '0, 1, 2' );

done_testing;

# Local Variables:
# mode: perl
# perl-indent-level: 4
# indent-tabs-mode: nil
# coding: utf-8-unix
# End:
#
# vim: expandtab shiftwidth=4:

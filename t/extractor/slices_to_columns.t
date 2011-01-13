use strict;
use warnings;

use Test::More;
use App::Batch::ToolKit::Extractor;

my $e = App::Batch::ToolKit::Extractor->new( fields => [qw/foo bar baz/], );

is_deeply( $e->slices_to_columns(), [ 0, 1, 2 ], 'No appears slices args' );
is_deeply( $e->slices_to_columns( +{ foo => 1 } ), [ 0, ], 'foo => 1' );
is_deeply( $e->slices_to_columns( +{ foo => 1, bar => 0, } ),
    [ 0, ], 'foo => 1, bar => 0' );
is_deeply(
    $e->slices_to_columns( +{ foo => 0, bar => 1, baz => 1 } ),
    [ 1, 2, ],
    'foo => 0, bar => 1, baz => 1'
);
is_deeply(
    $e->slices_to_columns( +{ foo => 1, bar => 1, baz => 1 } ),
    [ 0, 1, 2, ],
    'foo => 1, bar => 1, baz => 1'
);

done_testing;

# Local Variables:
# mode: perl
# perl-indent-level: 4
# indent-tabs-mode: nil
# coding: utf-8-unix
# End:
#
# vim: expandtab shiftwidth=4:

use strict;
use warnings;

use Test::More;
use App::Batch::ToolKit::Extractor;

sub test_fetchrow_hashref {
    my %specs = @_;
    my ( $input, $expects, $desc ) = @specs{qw/input expects desc/};
    my ($slices) = @$input{qw/slices/};
    subtest $desc => sub {
        my $e = App::Batch::ToolKit::Extractor->new(
            fields => [qw/foo bar baz/],
            rows =>
              [ [ 1, 2, 3, ], [ 4, 5, 6, ], [ 7, 8, 9, ], [ 10, 11, 12, ], ],
        );

        my $i = 0;
        while ( my $row = $e->fetchrow_hashref($slices) ) {
            my $expected_row = shift @$expects;
            is_deeply( $row, $expected_row, sprintf( 'row: %d', ++$i ) );
        }

        done_testing;
    };
}

test_fetchrow_hashref(
    desc    => 'No appears slices args',
    input   => +{},
    expects => [
        +{ foo => 1,  bar => 2,  baz => 3, },
        +{ foo => 4,  bar => 5,  baz => 6, },
        +{ foo => 7,  bar => 8,  baz => 9, },
        +{ foo => 10, bar => 11, baz => 12, },
    ],
);

test_fetchrow_hashref(
    desc  => 'foo => 1',
    input => +{ slices => +{ foo => 1, } },
    expects =>
      [ +{ foo => 1, }, +{ foo => 4, }, +{ foo => 7, }, +{ foo => 10, }, ],
);

test_fetchrow_hashref(
    desc  => 'foo => 1, bar => 0',
    input => +{ slices => +{ foo => 1, bar => 0 } },
    expects =>
      [ +{ foo => 1, }, +{ foo => 4, }, +{ foo => 7, }, +{ foo => 10, }, ],
);

test_fetchrow_hashref(
    desc    => 'foo => 1, baz => 1',
    input   => +{ slices => +{ foo => 1, baz => 1 } },
    expects => [
        +{ foo => 1,  baz => 3, },
        +{ foo => 4,  baz => 6, },
        +{ foo => 7,  baz => 9, },
        +{ foo => 10, baz => 12, },
    ],
);

test_fetchrow_hashref(
    desc    => 'foo => 1, bar => 1, baz => 1',
    input   => +{ slices => +{ foo => 1, bar => 1, baz => 1, } },
    expects => [
        +{ foo => 1,  bar => 2,  baz => 3, },
        +{ foo => 4,  bar => 5,  baz => 6, },
        +{ foo => 7,  bar => 8,  baz => 9, },
        +{ foo => 10, bar => 11, baz => 12, },
    ],
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

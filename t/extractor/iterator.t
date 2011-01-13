use strict;
use warnings;

use Test::More;
use App::Batch::ToolKit::Extractor;

sub test_iterator {
    my %specs = @_;
    my ( $input, $expects, $desc ) = @specs{qw/input expects desc/};
    my ( $fetchrow_method, $size, $attrs ) =
      @$input{qw/fetchrow_method size attrs/};

    subtest $desc => sub {
        my $e = App::Batch::ToolKit::Extractor->new(
            fields => [qw/foo bar baz/],
            rows   => [
                [ 1,  2,  3, ],
                [ 4,  5,  6, ],
                [ 7,  8,  9, ],
                [ 10, 11, 12, ],
                [ 13, 14, 15, ],
                [ 16, 17, 18, ],
                [ 19, 20, 21, ],
                [ 22, 23, 24, ],
            ],
        );

        my $iter = $e->iterator( $fetchrow_method, $attrs, $size );
        my $i = 0;
        while ( my $entry = $iter->next ) {
            my $expected_entry = shift @$expects;
            is_deeply( $entry, $expected_entry, sprintf( 'entry:%d', ++$i ) );
        }

        done_testing;
    };
}

test_iterator(
    desc    => 'arrayref_iterator, size: not defined, columns: not defined',
    input   => +{ fetchrow_method => 'fetchrow_arrayref', },
    expects => [
        [ 1,  2,  3, ],
        [ 4,  5,  6, ],
        [ 7,  8,  9, ],
        [ 10, 11, 12, ],
        [ 13, 14, 15, ],
        [ 16, 17, 18, ],
        [ 19, 20, 21, ],
        [ 22, 23, 24, ],
    ],
);

test_iterator(
    desc    => 'arrayref_iterator, size: 3, columns: not defined',
    input   => +{ fetchrow_method => 'fetchrow_arrayref', size => 3 },
    expects => [
        [ [ 1,  2,  3, ],  [ 4,  5,  6, ],  [ 7,  8,  9, ] ],
        [ [ 10, 11, 12, ], [ 13, 14, 15, ], [ 16, 17, 18, ] ],
        [ [ 19, 20, 21, ], [ 22, 23, 24, ] ],
    ],
);

test_iterator(
    desc => 'arrayref_iterator, size: 3, columns: [1]',
    input =>
      +{ fetchrow_method => 'fetchrow_arrayref', size => 3, attrs => [ 1, ], },
    expects => [
        [ [ 2, ],  [ 5, ],  [ 8, ] ],
        [ [ 11, ], [ 14, ], [ 17, ] ],
        [ [ 20, ], [ 23, ] ],
    ],
);

test_iterator(
    desc    => 'hashref_iterator, size: not defined, slices: not defined',
    input   => +{ fetchrow_method => 'fetchrow_hashref', },
    expects => [
        +{ foo => 1,  bar => 2,  baz => 3, },
        +{ foo => 4,  bar => 5,  baz => 6, },
        +{ foo => 7,  bar => 8,  baz => 9, },
        +{ foo => 10, bar => 11, baz => 12, },
        +{ foo => 13, bar => 14, baz => 15, },
        +{ foo => 16, bar => 17, baz => 18, },
        +{ foo => 19, bar => 20, baz => 21, },
        +{ foo => 22, bar => 23, baz => 24, },
    ],
);

test_iterator(
    desc    => 'hashref_iterator, size: 3, slices: not defined',
    input   => +{ fetchrow_method => 'fetchrow_hashref', size => 3, },
    expects => [
        [
            +{ foo => 1, bar => 2, baz => 3, },
            +{ foo => 4, bar => 5, baz => 6, },
            +{ foo => 7, bar => 8, baz => 9, }
        ],
        [
            +{ foo => 10, bar => 11, baz => 12, },
            +{ foo => 13, bar => 14, baz => 15, },
            +{ foo => 16, bar => 17, baz => 18, }
        ],
        [
            +{ foo => 19, bar => 20, baz => 21, },
            +{ foo => 22, bar => 23, baz => 24, }
        ],
    ],
);

test_iterator(
    desc  => 'hashref_iterator, size: 3, slices: baz',
    input => +{
        fetchrow_method => 'fetchrow_hashref',
        size            => 3,
        attrs           => +{ baz => 1 }
    },
    expects => [
        [ +{ baz => 3, },  +{ baz => 6, },  +{ baz => 9, } ],
        [ +{ baz => 12, }, +{ baz => 15, }, +{ baz => 18, } ],
        [ +{ baz => 21, }, +{ baz => 24, } ],
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

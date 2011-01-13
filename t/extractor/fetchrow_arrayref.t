use strict;
use warnings;

use Test::More;
use App::Batch::ToolKit::Extractor;

sub test_fetchrow_arrayref {
    my %specs = @_;
    my ( $input, $expects, $desc ) = @specs{qw/input expects desc/};
    my ($columns) = @$input{qw/columns/};

    subtest $desc => sub {
        my $e = App::Batch::ToolKit::Extractor->new(
            fields => [qw/foo bar baz/],
            rows =>
              [ [ 1, 2, 3, ], [ 4, 5, 6, ], [ 7, 8, 9, ], [ 10, 11, 12, ], ],
        );

        my $i = 0;
        while ( my $row = $e->fetchrow_arrayref($columns) ) {
            my $expected_row = shift @$expects;
            is_deeply( $row, $expected_row, sprintf( 'row: %d', ++$i ) );
        }

        done_testing;
    };
}

test_fetchrow_arrayref(
    desc => 'No appears columns args',
    input => +{},
    expects => [
        [ 1, 2, 3, ], [ 4, 5, 6, ], [ 7, 8, 9, ], [ 10, 11, 12, ],
    ],
);

test_fetchrow_arrayref(
    desc => 'columns: [ 1 ]',
    input => +{ columns => [ 1, ] },
    expects => [
        [ 2, ], [ 5, ], [ 8, ], [ 11, ],
    ],
);

test_fetchrow_arrayref(
    desc => 'columns: [ 0, 2 ]',
    input => +{ columns => [ 0, 2, ], },
    expects => [
        [ 1, 3, ], [ 4, 6, ], [ 7, 9, ], [ 10, 12, ],
    ],
);

test_fetchrow_arrayref(
    desc => 'columns: [ 0, 1, 2, ]',
    input => +{ columns => [ 0, 1, 2, ], },
    expects => [
        [ 1, 2, 3, ], [ 4, 5, 6, ], [ 7, 8, 9, ], [ 10, 11, 12, ],
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

#! /usr/bin/env perl
# SPDX-License-Identifier: MIT

########################################################################
#                                                                      #
#  This file is part of the solution set for the programming puzzles   #
#  presented by the 2020 Advent of Code challenge.                     #
#  See: https://adventofcode.com/2020                                  #
#                                                                      #
#  Copyright © 2020  Chindraba (Ronald Lamoreaux)                      #
#                    <aoc@chindraba.work>                              #
#  - All Rights Reserved                                               #
#                                                                      #
#  Permission is hereby granted, free of charge, to any person         #
#  obtaining a copy of this software and associated documentation      #
#  files (the "Software"), to deal in the Software without             #
#  restriction, including without limitation the rights to use, copy,  #
#  modify, merge, publish, distribute, sublicense, and/or sell copies  #
#  of the Software, and to permit persons to whom the Software is      #
#  furnished to do so, subject to the following conditions:            #
#                                                                      #
#  The above copyright notice and this permission notice shall be      #
#  included in all copies or substantial portions of the Software.     #
#                                                                      #
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,     #
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF  #
#  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND               #
#  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS #
#  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN  #
#  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN   #
#  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE    #
#  SOFTWARE.                                                           #
#                                                                      #
########################################################################

use 5.030000;
use strict;
use warnings;
use Elves::GetData qw( :all );
use Elves::Reports qw( :all );

my $VERSION = '0.20.24';

my @puzzle_data;
@puzzle_data = read_lines $main::puzzle_data_file;

my $result;
my $part;


my $tile_grid = {};

sub find_tile {
    my @pattern = (split //, $_[0]);
    my ($x,$y,$z) = (0,0,0);
    my $hop;
    while (@pattern) {
        $hop = shift @pattern;
        if ('e' eq $hop) {
            $x++; $y--;
        } elsif ('w' eq $hop) {
            $x--; $y++;
        } else {
            $hop .= shift @pattern;
            if ('ne' eq $hop) {
                $x++; $z--;
            } elsif ('nw' eq $hop) {
                $y++; $z--;
            } elsif ('se' eq $hop) {
                $y--; $z++;
            } elsif ('sw' eq $hop) {
                $x--; $z++;
            } else {
                die "Bad hop found";
            }
        }
    }
    return join(':', ($x,$y,$z));
}


sub do_hop {
    my $grid = shift;
    my $tile = find_tile(shift);
    if (exists $grid->{$tile}) {
        delete $grid->{$tile};
    } else {
        $grid->{$tile} = undef;
    }
}

sub find_neighbors {
    my ($x, $y, $z) = split ':', $_[0];
    my @touching;
    $x++; $y--; push(@touching, join(':',($x,$y,$z))); # 1:-1:0
    $x--; $z++; push(@touching, join(':',($x,$y,$z))); # 0:-1:1
    $x--; $y++; push(@touching, join(':',($x,$y,$z))); # -1:0:1
    $y++; $z--; push(@touching, join(':',($x,$y,$z))); # -1:1:0
    $x++; $z--; push(@touching, join(':',($x,$y,$z))); # 0:1:-1
    $x++; $y--; push(@touching, join(':',($x,$y,$z))); # 1:0:-1
    return @touching;
}

sub check_white {
    my ($grid, $tile, $black_count) = @_;
    my @close = find_neighbors($tile);
    foreach (@close) {
        $black_count ++ if (exists $grid->{$_});
    }
    return (2 == $black_count)? 1 : 0;
}

sub check_black {
    my ($grid, $tile, $black_count) = (@_, 0);
    my @close = find_neighbors($tile);
    foreach my $to_check (@close) {
        if (exists $grid->{$to_check}) {
            $black_count ++;
        }
    }
    return (1 == $black_count || 2 == $black_count)? 1 : 0;
}

sub flip_grid {
    my $grid = shift;
    my $new_grid = {};
    my @check = (keys %{$grid});
    foreach my $tile (@check) {
        if (check_black($grid, $tile)) {
            $new_grid->{$tile} = undef;
        }
        my @close = find_neighbors($tile);
        foreach my $neighbor (@close) {
            if (check_white($grid, $neighbor)) {
                $new_grid->{$neighbor} = undef;
            }
        }
    }
    return $new_grid;
}

# Part 1
$part = 1;
foreach (@puzzle_data) {
    do_hop($tile_grid, $_);
}
$result = scalar(keys %{$tile_grid});
report_number($part, $result);

exit unless $main::do_part_2;

# Part 2
$part = 2;
foreach (1..100) {
    $tile_grid = flip_grid($tile_grid);
}
$result = scalar(keys %{$tile_grid});
report_number($part, $result);

1;

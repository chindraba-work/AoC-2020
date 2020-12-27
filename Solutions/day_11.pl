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
use List::Util qw(sum min max);

my $VERSION = '0.20.11';

my @puzzle_data = read_lines $main::puzzle_data_file;
my @seat_map;
my ($tolerance, $in_motion, $filled, $ranged);

sub neighbors {
    my ($row, $col) = @_;
    my $neighbors = 0;
    my $delta = 1;
    my ($ne, $nc, $nw, $ce, $cw, $se, $sc, $sw) = (0) x 8;
    while (sum($ne, $nc, $nw, $ce, $cw, $se, $sc, $sw) < 8 ) {
        if (!$nw && 0 <= $col - $delta && 0 <= $row - $delta) {
            $nw = (!$ranged || $seat_map[$row - $delta][$col - $delta] =~ /L|\#/);
            $neighbors++ if ('#' eq $seat_map[$row - $delta][$col - $delta]);
        } else { $nw = 1; }
        if (!$nc && 0 <= $row - $delta) {
            $nc = (!$ranged || $seat_map[$row - $delta][$col] =~ /L|\#/);
            $neighbors++ if ('#' eq $seat_map[$row - $delta][$col]);
        } else { $nc = 1; }
        if (!$ne && $col + $delta <= $#{$seat_map[$row]} && 0 <= $row - $delta) {
            $ne = (!$ranged || $seat_map[$row - $delta][$col + $delta] =~ /L|\#/);
            $neighbors++ if ('#' eq $seat_map[$row - $delta][$col + $delta]);
        } else { $ne = 1; }
        
        if (!$cw && 0 <= $col - $delta) {
            $cw = (!$ranged || $seat_map[$row][$col - $delta] =~ /L|\#/);
            $neighbors++ if ('#' eq $seat_map[$row][$col - $delta]);
        } else { $cw = 1; }
        if (!$ce && $col + $delta <= $#{$seat_map[$row]}) {
            $ce = (!$ranged || $seat_map[$row][$col + $delta] =~ /L|\#/);
            $neighbors++ if ('#' eq $seat_map[$row][$col + $delta]);
        } else { $ce = 1; }
        
        if (!$sw && 0 <= $col - $delta && $row + $delta <= $#seat_map) {
            $sw = (!$ranged || $seat_map[$row + $delta][$col - $delta] =~ /L|\#/);
            $neighbors++ if ('#' eq $seat_map[$row + $delta][$col - $delta]);
        } else { $sw = 1; }
        if (!$sc && $row + $delta <= $#seat_map) {
            $sc = (!$ranged || $seat_map[$row + $delta][$col] =~ /L|\#/);
            $neighbors++ if ('#' eq $seat_map[$row + $delta][$col]);
        } else { $sc = 1; }
        if (!$se && $col + $delta <= $#{$seat_map[$row]} && $row + $delta <= $#seat_map) {
            $se = (!$ranged || $seat_map[$row + $delta][$col + $delta] =~ /L|\#/);
            $neighbors++ if ('#' eq $seat_map[$row + $delta][$col + $delta]);
        } else { $se = 1; }
        $delta++ if $ranged;
    }
    return $neighbors;
}

sub change_seats {
    my @new_map = ([],);
    my $changed = 0;
    my $filled_seats = 0;
    for my $row (0..$#seat_map) {
        for my $col (0..$#{$seat_map[$row]}) {
            if ($seat_map[$row][$col] =~ /L|\#/) {
                $filled_seats++ if ($seat_map[$row][$col] =~ /#/); 
                
                if ('L' eq $seat_map[$row][$col]) {
                    if (0 == neighbors($row,$col)){
                        $new_map[$row][$col] = '#';
                        $changed = 1;
                        $filled_seats++;
                    } else {
                        $new_map[$row][$col] = 'L';
                    }
                }
                if ('#' eq $seat_map[$row][$col]) {
                    if ($tolerance <= neighbors($row,$col)) {
                        $new_map[$row][$col] = 'L';
                        $changed = 1;
                        $filled_seats--;
                    } else {
                        $new_map[$row][$col] = '#';
                    }
                }
            } else {
                $new_map[$row][$col] = '.';
            }
        }
    }
    return ($changed, $filled_seats, @new_map);
}

# Part 1
@seat_map = map { 
    [split //, $_];
} (@puzzle_data);
$tolerance = 4;
$ranged = 0;
$in_motion = 1;
while ($in_motion) {
    ($in_motion, $filled, @seat_map) = change_seats(); #@seat_map);
}
report_number(1, $filled);

exit unless $main::do_part_2;

# Part 2
@seat_map = map { 
    [split //, $_];
} (@puzzle_data);
$tolerance = 5;
$ranged = 1;
$in_motion = 1;
while ($in_motion) {
    ($in_motion, $filled, @seat_map) = change_seats(); #@seat_map);
}
report_number(2, $filled);

1;

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
use List::Util qw(max min sum);
my $VERSION = '0.20.10';

my $result;

my @puzzle_data = sort { $a <=> $b } (read_lines $main::puzzle_data_file);
  
# Part 1
my $curr_jolts = 0;
my @delta_jolts = (0) x 4;
my $device_jolts = 3 + max(@puzzle_data);
map {
    $delta_jolts[$_ - $curr_jolts]++;
    $curr_jolts = $_ ;
} (@puzzle_data, $device_jolts);
report_number(1, $delta_jolts[1] * ($delta_jolts[3]));

exit unless $main::do_part_2;

# Part 2
my @dag_map = (0, @puzzle_data, $device_jolts);
my @dag_counts = ();
sub dag_paths {
    my ($start, $end) = @_;
    return 1 if ($start == $end);
    return $dag_counts[$start] if defined $dag_counts[$start];
    $dag_counts[$start] = sum( map {
        dag_paths($_, $end) if (
            defined $dag_map[$_] &&
            $dag_map[$_] - $dag_map[$start] <= 3
        );
    } ($start + 1 .. $start + 3));
    return $dag_counts[$start];
}
report_number(2, dag_paths(0, $#dag_map));

1;

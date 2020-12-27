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
use List::Util qw(min max sum);

my $VERSION = '0.20.09';

my @puzzle_data = read_lines $main::puzzle_data_file;


my $preamble = $main::use_live_data? 25 : 5;

# Part 1
my ($base, $first, $last, $target, $found);
$base = $preamble;
$found = 1;
while ($found && $base < scalar @puzzle_data) {
    $found = 0;
    $first = $base - $preamble;
    while (!$found && $first < $base - 1) {
        $last = $first + 1;
        $last++ if $puzzle_data[$first] == $puzzle_data[$last];
        while ($puzzle_data[$base] != $puzzle_data[$first] + $puzzle_data[$last] && $last++ < $base) {}
        if ($puzzle_data[$base] == $puzzle_data[$first] + $puzzle_data[$last]) {
            $found = $base;
        } else {
            $first++;
        }
    }
    $base++ if ($puzzle_data[$base] == ($puzzle_data[$first] + $puzzle_data[$last]));
}
report_number(1, $puzzle_data[$base]);

exit unless $main::do_part_2;

# Part 2
$found = 0;
$first = -1;
my ($high, $low);
while (!$found && ++$first < $base - 1) {
     $low =$puzzle_data[$first];
     $high =$puzzle_data[$first];
    $last = $first;
    while (!$found && ++$last < $base && $puzzle_data[$base] > sum(@puzzle_data[$first .. $last])) {
             $low = ($low < $puzzle_data[$last]) ? $low : $puzzle_data[$last];
             $high = ($high > $puzzle_data[$last]) ? $high : $puzzle_data[$last];
    }
    $found = (sum(@puzzle_data[$first .. $last]) == $puzzle_data[$base]);
}
report_number(2, $low + $high);

1;

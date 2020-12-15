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

my $VERSION = '0.20.15';

my $result;

my @puzzle_data = read_comma_list $main::puzzle_data_file;

if (!$main::use_live_data) {
    @puzzle_data = (3,1,2);
}
my ($round, $next, $last, %history) = (0);

# Part 1
say "====== Part 1 ======";
foreach (@puzzle_data) { $history{$_} = ++$round; }
$last = $puzzle_data[-1];
$next = $round - $history{$last};
while ($round < 2020) {
    $last = $next;
    if (!defined $history{$last}) {
        $next = 0;
        ++$round;
    } else {
        $next = ++$round - $history{$last};
    }
    $history{$last} = $round;
}
report_number(1, $last);

say "====================";

exit unless $main::do_part_2;

# Part 2
say "====== Part 2 ======";
%history = ();
$round = 0;
foreach (@puzzle_data) { $history{$_} = ++$round; }
$last = $puzzle_data[-1];
$next = $round - $history{$last};
while ($round < 30_000_000) {
    $last = $next;
    if (!defined $history{$last}) {
        $next = 0;
        ++$round;
    } else {
        $next = ++$round - $history{$last};
    }
    $history{$last} = $round;
}
report_number(2, $last);


say "====================";

1;

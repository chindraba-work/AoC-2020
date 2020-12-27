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
use Math::ModInt qw(mod);
use Math::ModInt::ChineseRemainder qw(cr_combine);
use Elves::GetData qw( :all );
use Elves::Reports qw( :all );

my $VERSION = '0.20.13';

my $result;

my @puzzle_data = read_lines $main::puzzle_data_file;

my $base_time = $puzzle_data[0];
my @routes = split ',', $puzzle_data[1];
my $line = 0;
my $remaining = 939;

sub lowest {
    return ($_[0] < $_[1]) ? $_[0] : $_[1];
}
    

# Part 1
foreach my $route (@routes) {
    unless ('x' eq $route) {
        my $bal = $route - ($base_time % $route);
        $remaining = lowest($bal, $remaining);
        $line = $route if $bal == $remaining;
    }
}
report_number(1, $remaining * $line);

exit unless $main::do_part_2;

# Part 2
my @pairs;
foreach (0..$#routes) {
    push @pairs, mod(-$_, $routes[$_]) if 'x' ne $routes[$_];
}
report_number(2, cr_combine( @pairs ));

1;

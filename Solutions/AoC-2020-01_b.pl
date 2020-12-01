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

use 5.026001;
use strict;
use warnings;
use Elves::GetData qw( :all );

my $VERSION = '0.20.01';

our $show_progress = 0;

my $puzzle_data_file = $main::data_file;

my @expense_list = slurp_data $puzzle_data_file;
say $expense_list[0];
my $sum_found = 0;
my $first_index = 0;
my $second_index;
my $third_index;
while (! $sum_found && $first_index < scalar @expense_list ) {
    $second_index = 1 + $first_index;
    while (! $sum_found && $second_index < scalar @expense_list ) {
        $third_index = $second_index + 1;
        while (! $sum_found && $third_index < scalar @expense_list ) {
            if  ( 2020 == $expense_list[$first_index] + $expense_list[$second_index] + $expense_list[$third_index]) {
                $sum_found = 1;
            } else {
                $third_index++;
            }
        }
        $second_index++ unless $sum_found;
    }
    $first_index++ unless $sum_found;
}
my $product = $expense_list[$first_index] * $expense_list[$second_index] * $expense_list[$third_index];
print "The three numbers are $expense_list[$first_index], $expense_list[$second_index], and $expense_list[$third_index] for $product product.\n";

1;

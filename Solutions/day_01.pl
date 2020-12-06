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

my $VERSION = '0.20.01';

my $result;
my ($sum_found, $first_index, $second_index, $third_index);

my @expense_list = read_lines $main::puzzle_data_file;

# Part 1
($sum_found, $first_index, $second_index, $third_index) = (0) x 4;
while (! $sum_found && $first_index <= $#expense_list ) {
    $second_index = 1 + $first_index;
    while (! $sum_found && $second_index <= $#expense_list ) {
        if  ( 2020 == $expense_list[$first_index]
                    + $expense_list[$second_index] ) {
            $sum_found = 1;
            $result = $expense_list[$first_index]
                     * $expense_list[$second_index];
        } else {
            $second_index++;
        }
    }
    $first_index++ unless $sum_found;
}
printf "The two numbers are %u and %u.\nTheir product is %u.\n",
    $expense_list[$first_index],
    $expense_list[$second_index],
    $result;
report_number(1, $result);

exit unless $main::do_part_2;
# Part 2
($sum_found, $first_index, $second_index, $third_index) = (0) x 4;
while (! $sum_found && $first_index <= $#expense_list ) {
    $second_index = 1 + $first_index;
    while (! $sum_found && $second_index <= $#expense_list ) {
        $third_index = $second_index + 1;
        while (! $sum_found && $third_index <= $#expense_list ) {
            if  ( 2020 == $expense_list[$first_index]
                        + $expense_list[$second_index]
                        + $expense_list[$third_index]) {
                $sum_found = 1;
                $result = $expense_list[$first_index] 
                         * $expense_list[$second_index]
                         * $expense_list[$third_index];
            } else {
                $third_index++;
            }
        }
        $second_index++ unless $sum_found;
    }
    $first_index++ unless $sum_found;
}
printf "The three numbers are %u, %u and %u.\nTheir product is %u.\n",
    $expense_list[$first_index],
    $expense_list[$second_index],
    $expense_list[$third_index],
    $result;
report_number(2, $result);

    
1;

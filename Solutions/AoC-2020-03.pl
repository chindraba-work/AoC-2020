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

my $VERSION = '0.20.03';

my $do2 = 1;
my $day_num = 3;
my $part_num;
my $puzzle_data_file = $main::data_file;
my ($valid, $count, $count_min, $count_max, $letter, $phrase);
my $result;


my $testing = 0;
my @check_data =(
'..##.......',
'#...#...#..',
'.#....#..#.',
'..#.#...#.#',
'.#...##..#.',
'..#.##.....',
'.#.#.#....#',
'.#........#',
'#.##...#...',
'#...##....#',
'.#..#...#.#',
);

my @puzzle_data = $testing ? @check_data : read_lines $puzzle_data_file;

sub count_trees {
    my ($col_inc, $row_inc) = @_;
    my ($row, $col, $trees) = (0,0,0);
    my (@row_data);
    while ($row < $#puzzle_data) {
        $row += $row_inc;
        $col += $col_inc;
        @row_data = split //, $puzzle_data[$row];
        $col -= scalar @row_data unless ($col < scalar @row_data);
        $trees++ if $row_data[$col] eq '#';
    }
    return $trees;
}

# Part 1
$part_num = 1;
$result = count_trees(3,1);
    

printf "\n%s\nAdvent of Code 2020, Day %u Part %u : the answer is %u\n\n%s",
    $main::break_line,
    $day_num,
    $part_num,
    $result,
    $main::break_line;

exit unless $do2;
# Part 2
$part_num = 2;
$result = 
    count_trees(1, 1) *
    count_trees(3, 1) *
    count_trees(5, 1) *
    count_trees(7, 1) *
    count_trees(1, 2);


printf "\n%s\nAdvent of Code 2020, Day %u Part %u : the answer is %u\n\n%s",
    $main::break_line,
    $day_num,
    $part_num,
    $result,
    $main::break_line;

    
1;

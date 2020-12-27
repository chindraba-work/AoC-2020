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
use Elves::Conway;

my $VERSION = '0.20.17';

my $result;
my $part;

my @puzzle_data = read_lines $main::puzzle_data_file;
my $conway_map;
my %conway_init = (
    'active_mark' => '#',
    'dimensions'  => 3,
    'stay_on'     => [2,3],
    'turn_on'     => [3],
    'plane_maps'  => [
        {
            char_dim   => 0,
            char_start => 0,
            line_dim   => 1,
            line_start => 0,
            datum      => [read_lines $main::puzzle_data_file],
        },
    ],
);

my @base_coords;

# Part 1
$part = 1;
Elves::Conway::init(%conway_init);
$conway_map = run_game(6);
report_number($part, scalar (keys %{$conway_map}));

exit unless $main::do_part_2;

# Part 2
$part = 2;
$conway_init{'dimensions'} = 4;
Elves::Conway::init(%conway_init);
$conway_map = run_game(6);
report_number($part, scalar (keys %{$conway_map}));

1;

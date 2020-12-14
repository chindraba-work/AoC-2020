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
use List::MoreUtils qw(first_index);

my $VERSION = '0.20.12';

my @puzzle_data = read_lines $main::puzzle_data_file;

my @instructions = map { 
    $_ =~ /([A-Z])(\d+)/;
    [$1, $2];
} (@puzzle_data);

my %status;
my $waypoint;


my @compass = qw(N E S W);

my %deltas = (
    N => [-1,0],
    S => [1,0],
    W => [0,-1],
    E => [0,1],
);

sub move{
    my @delta = @{$deltas{$_[0]}};
    my $speed = $_[1];
    $status{'loc'}[0] += $speed * $delta[0];
    $status{'loc'}[1] += $speed * $delta[1];
}

sub rotate {
    use integer;
    my ($index) = grep { $compass[$_] eq $_[0] } (0 .. $#compass);
    return $compass[(4 + $index + ($_[1] cmp 'O') * ($_[2] / 90)) % 4];
}

sub pivot {
    $status{'loc'} = [
        (1 == $_[0]) 
            ? $status{'loc'}[1]
            : 0 - $status{'loc'}[(2 == $_[0])? 0 : 1],
        (3 == $_[0])
            ? $status{'loc'}[0]
            : 0 - $status{'loc'}[(2 == $_[0])? 1 : 0]
    ];
}

my %command_table = (
    W => sub { move('W', $_[0]); },
    E => sub { move('E', $_[0]); },
    S => sub { move('S', $_[0]); },
    N => sub { move('N', $_[0]); },
    R => sub {
        if (!$waypoint) {
            $status{'face'} = rotate($status{'face'}, 'R', $_[0]);
        } else {
            pivot(($_[0] / 90) % 4);
        }
    },
    L => sub {
        if (!$waypoint) {
            $status{'face'} = rotate($status{'face'}, 'L', $_[0]);
        } else {
            pivot(4 - (($_[0] / 90) % 4));
        }
    },
    F => sub {
        if (!$waypoint) {
            move($status{'face'}, $_[0]);
        } else {
            $status{'pos'}[0] += $_[0] * $status{'loc'}[0];
            $status{'pos'}[1] += $_[0] * $status{'loc'}[1];
        }
    },
);

sub process {
    foreach (@_) {
        $_ =~ /([A-Z])(\d+)/;
        $command_table{$1}($2)
    }
}

# Part 1
say "====== Part 1 ======";
%status = (
    loc  => [0,0],
    face => 'E',
);
$waypoint = 0;
process(@puzzle_data);
report_number(1, abs($status{'loc'}[0])+abs($status{'loc'}[1]));

say "====================";

exit unless $main::do_part_2;

# Part 2
say "====== Part 2 ======";
%status = (
    loc  => [-1,10],
    face => 'E',
    pos  => [0,0],
);
$waypoint = 1;
process(@puzzle_data);
report_number(2, abs($status{'pos'}[0])+abs($status{'pos'}[1]));

say "====================";

1;

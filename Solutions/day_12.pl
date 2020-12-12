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

my $VERSION = '0.20.12';

my @puzzle_data = read_lines $main::puzzle_data_file;

my @instructions = map { 
    $_ =~ /([A-Z])(\d+)/;
    [$1, $2];
} (@puzzle_data);

my %status;
my $waypoint;

my %rotations = (
    L => {
        N => ['N','W','S','E'],
        W => ['W','S','E','N'],
        S => ['W','E','N','W'],
        E => ['E','N','W','S'],
    },
    R => {
        N => ['N','E','S','W'],
        W => ['W','N','E','S'],
        S => ['S','W','N','E'],
        E => ['E','S','W','N'],
    },
);
my %deltas = (
    N => [-1,0],
    S => [1,0],
    W => [0,-1],
    E => [0,1],
);
my %move_table = (
    F => sub {
        my $speed = shift;
        my @delta = @{$deltas{$status{'face'}}};
        if (!$waypoint) {
            $status{'loc'}[0] += $speed * $delta[0];
            $status{'loc'}[1] += $speed * $delta[1];
        } else {
            $status{'pos'}[0] += $speed * $status{'loc'}[0];
            $status{'pos'}[1] += $speed * $status{'loc'}[1];
        }
    },
    R => sub {
        my $deg = shift;
        if (!$waypoint) {
            $status{'face'} = $rotations{'R'}{$status{'face'}}[($deg / 90) % 4];
        } else {
            my $pivot = ($deg / 90) % 4;
            if (1 == $pivot) {
                $status{'loc'} = [$status{'loc'}[1],0 - $status{'loc'}[0]];
            } elsif ( 2 == $pivot) {
                $status{'loc'} = [0 - $status{'loc'}[0],0 - $status{'loc'}[1]];
            } elsif ( 3 == $pivot) {
                $status{'loc'} = [0 - $status{'loc'}[1],$status{'loc'}[0]];
            }
        }
    },
    L => sub {
        my $deg = shift;
        if (!$waypoint) {
            $status{'face'} = $rotations{'L'}{$status{'face'}}[($deg / 90) % 4];
        } else {
            my $pivot = 4- (($deg / 90) % 4);
            if (1 == $pivot) {
                $status{'loc'} = [$status{'loc'}[1],0 - $status{'loc'}[0]];
            } elsif ( 2 == $pivot) {
                $status{'loc'} = [0 - $status{'loc'}[0],0 - $status{'loc'}[1]];
            } elsif ( 3 == $pivot) {
                $status{'loc'} = [0 - $status{'loc'}[1],$status{'loc'}[0]];
            }
        }
    },
    W => sub {
        my $speed = shift;
        my @delta = @{$deltas{'W'}};
        $status{'loc'}[0] += $speed * $delta[0];
        $status{'loc'}[1] += $speed * $delta[1];
    },
    E => sub {
        my $speed = shift;
        my @delta = @{$deltas{'E'}};
        $status{'loc'}[0] += $speed * $delta[0];
        $status{'loc'}[1] += $speed * $delta[1];
    },
    S => sub {
        my $speed = shift;
        my @delta = @{$deltas{'S'}};
        $status{'loc'}[0] += $speed * $delta[0];
        $status{'loc'}[1] += $speed * $delta[1];
    },
    N => sub {
        my $speed = shift;
        my @delta = @{$deltas{'N'}};
        $status{'loc'}[0] += $speed * $delta[0];
        $status{'loc'}[1] += $speed * $delta[1];
    },
);

sub move {
    my ($dir, $distance) = @_;
    $move_table{$dir}($distance);
    if ($waypoint) {
    }
}


# Part 1
say "====== Part 1 ======";
%status = (
    loc  => [0,0],
    face => 'E',
);
$waypoint = 0;
foreach (@instructions) {
    move(@{$_});
}
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
foreach (@instructions) {
    move(@{$_});
}
report_number(2, abs($status{'pos'}[0])+abs($status{'pos'}[1]));

say "====================";

1;

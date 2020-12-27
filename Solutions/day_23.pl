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
use Elves::GetData qw( read_lines );
use Elves::Reports qw( report_number );

my $VERSION = '0.20.23';

my @puzzle_data = split(//, (read_lines($main::puzzle_data_file))[0]);
my $result;
my $part;


my (@to, @fm, @status);

sub load_cups {
    my ($last, $now, $next) = @puzzle_data[$#puzzle_data, 0,1];
    $to[0] = $now;
    $fm[0] = 'P';
    foreach my $idx (2 .. $#puzzle_data) {
        $fm[$now] = $last;
        $to[$now] = $next;
        ($last, $now, $next) = ($now, $next, $puzzle_data[$idx]);
    }
    $fm[$now] = $last;
    $to[$now] = $next;
    ($last, $now, $next) = ($now, $next, $puzzle_data[0]);
    $fm[$now] = $last;
    $to[$now] = $next;
}

sub walk_it {
    my @listing;
    my $start = $to[0];
    my $cup = 0;
    do {
        push @listing, $to[$cup];
        $cup = $to[$cup];
    } until ($to[$cup] eq $start);
    return @listing;
}

sub move {
    $fm[0] = $to[$to[0]];
    $to[$to[0]] = $to[$to[$to[$fm[0]]]];
    $fm[$to[$to[0]]] = $to[0];
    $to[$to[$to[$fm[0]]]] = $to[$_[0]];
    $fm[$_[0]] = $to[$to[$fm[0]]];
    $to[$_[0]] = $fm[0];
    $fm[$fm[0]] = $_[0];
    $to[0] = $to[$to[0]];
}

sub find_target {
    my @skip = ($to[$to[$to[$to[0]]]], $to[$to[$to[0]]], $to[$to[0]]);
    my $target = $to[0] - 1;
    my $valid_target = 0;
    while (! $valid_target) {
        if ( 0 == $target) {
            $target = $#to;
        } 
        if (
            $to[$to[0]] eq $target ||
            $to[$to[$to[0]]] eq $target ||
            $to[$to[$to[$to[0]]]] eq $target
        ) {
            $target--;
        } else {
            $valid_target = 1;
        }
    }
    return $target;
}


# Part 1
$part = 1;
load_cups();
foreach (1..100) {
    move(find_target());
}
$to[0] = 1;
@status = walk_it();
shift @status;
$result = join '', @status;
report_number($part, $result);

exit unless $main::do_part_2;

# Part 2
$part = 2;

@to = ();
@fm = ();
push @puzzle_data, (10..1_000_000);
load_cups();
foreach (1..10_000_000) {
    move(find_target());
}
$result = $to[1] * $to[$to[1]];
report_number($part, $result);

1;

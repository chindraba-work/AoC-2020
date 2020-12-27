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

my $VERSION = '0.20.08';

my $result;

my @puzzle_data = read_lines $main::puzzle_data_file;

sub boot {
    my @boot_code = @_;
    $result = 0;
    my @executed = (0) x $#boot_code;
    my ($next, $resume) = (0,1);
    while ( $resume && ($next <= $#boot_code) ) {
        $executed[$next] = 1;
        my ($cmd, $value) = split / /, $boot_code[$next];
        if ('jmp' eq $cmd) {
            $next += $value;
        } elsif ('nop' eq $cmd) {
            $next++;
        } elsif ('acc' eq $cmd) {
            $result += $value;
            $next++;
        }
        $resume = (! $executed[$next]);
    }
    return $resume;
}

sub re_boot {
    my @boot_code = @_;
    my $index = 0;
    my $fixed = 0;
    while (! $fixed && $index <= $#boot_code) {
        if ($boot_code[$index] =~ /no/) {
            $boot_code[$index] =~ s/no/jm/;
            $fixed = boot(@boot_code);
            if (!$fixed) {
                $boot_code[$index] =~ s/jm/no/;
                $index++;
            }
        } elsif  ($boot_code[$index] =~ /jm/) {
            $boot_code[$index] =~ s/jm/no/;
            $fixed = boot(@boot_code);
            if (!$fixed) {
                $boot_code[$index] =~ s/no/jm/;
                $index++;
            }
        } else {
            $index++;
        }
    }
}

# Part 1
boot(@puzzle_data);
report_number(1, $result);

exit unless $main::do_part_2;

# Part 2
re_boot(@puzzle_data);
report_number(2, $result);

1;

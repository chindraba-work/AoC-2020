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

my $VERSION = '0.20.19';

my $result;
my $part;

my @puzzle_data = read_lines $main::puzzle_data_file;

my %rules;
my $test;
my @data_stream;
my @good_stream;

sub get_rule {
    my $rule = shift;
    if (1 == $rules{$rule}{'solved'}) {
        return $rules{$rule}{'piece'};
    }
    while ($rules{$rule}{'piece'} =~ /(-(\d+)-)/) {
        my $this = $1;
        my $that = get_rule($2);
        $rules{$rule}{'piece'} =~ s/\Q$this/$that/g;
    }
    return $rules{$rule}{'piece'};
}

sub load_rules {
    my $line = shift @puzzle_data;
    while ('' ne $line) {
        my ($num,$text) = split ":", $line;
        $rules{$num}{'text'} = $text;
        if ($text =~ /^\s*"([a-z])"$/) {
            $rules{$num}{'solved'} = 1;
            $rules{$num}{'piece'} = $1;
        } else {
            $rules{$num}{'solved'} = 0;
            $text =~ s/(\s+(\d+))(?=\D)/-$2-/g;
            $text =~ s/(\s+(\d+))$/-$2-/;
            $text =~ s/\s//g;
            if ($text =~ /\|/) {
                $text = "($text)"
            }
            $rules{$num}{'piece'} = $text;
        }
        $line = shift @puzzle_data;
    }
    @data_stream = (@puzzle_data);
}

# Part 1
$part = 1;
load_rules();
$test = "^" . get_rule(0) . "\$";
@good_stream = ();
foreach (@data_stream) {
    if ($_ =~ /$test/) {
        push @good_stream, $_;
    }
}
report_number($part, scalar @good_stream);

exit unless $main::do_part_2;

# Part 2
$part = 2;
if (! $main::use_live_data) {
    @puzzle_data = read_lines $main::puzzle_data_file2;
    %rules = ();
    load_rules;
}
my $tail_trap = get_rule(11);
for (1..5) {
    $tail_trap =
        "(?<pre$_>" .
        get_rule(42) .
        ")?$tail_trap(?(<pre$_>)(" .
        get_rule(31) .
        "|(?!)))";
}
$test = "^" . get_rule(8). "+$tail_trap\$";
@good_stream = ();
foreach (@data_stream) {
    if ($_ =~ /$test/) {
        push @good_stream, $_;
    }
}
report_number($part, scalar @good_stream);

1;

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

my $VERSION = '0.20.16';

my $result;

my @puzzle_data = read_lines $main::puzzle_data_file;


my ($section_label, $checksum, $changed, @columns, @nearby, %numbers, %rules, @ticket) = ('rules', 0);

foreach my $entry (@puzzle_data) {
    if ($entry =~/(.*)\sticket/) {
        $section_label = $1
    } elsif ('' ne $entry && 'rules' eq $section_label) {
        my ($rule_name, $g1_b, $g1_e, $g2_b, $g2_e) = 
        ($entry =~ /^(.*):\s+(\d+)-(\d+)\s+or\s+(\d+)-(\d+)/);
        foreach ($g1_b .. $g1_e) {
            $numbers{$_}->{$rule_name} = 1;
        }
        foreach ($g2_b .. $g2_e) {
            $numbers{$_}->{$rule_name} = 1;
        }
        $rules{$rule_name} = -1;
    } elsif ('' eq $entry && 'rules' eq $section_label) {
        foreach my $rule (keys %rules) {
            foreach my $index (0 .. scalar (keys %rules) -1) {
                $columns[$index]->{$rule} = 0;
            }
        }
    } elsif ('' ne $entry && 'your' eq $section_label) {
        @ticket = (split /,/, $entry); 
    } elsif ('' ne $entry && 'nearby' eq $section_label) {
        my ($valid, @entries) = (1, (split /,/, $entry));
        foreach my $curr (0 .. $#entries) {
            if (defined $numbers{$entries[$curr]}) {
                foreach my $rule (keys %rules) {
                    if (defined $columns[$curr]->{$rule} && !defined $numbers{$entries[$curr]}->{$rule}) {
                        delete $columns[$curr]->{$rule};
                    }
                    if (defined $columns[$curr]->{$rule} && 1 == scalar (keys %{$columns[$curr]})) {
                        foreach my $other (0 .. $#entries) {
                            delete $columns[$other]->{$rule} unless ($other == $curr);
                        }
                    }
                }
            } else {
                $valid = 0;
                $checksum += $entries[$curr];
            }
            if ($valid) {
                push @nearby, \@entries;
            }
        }
    }
}
$changed = 1;
while (1 == $changed) {
    $changed = 0;
    foreach my $curr (0 .. $#columns) {
        if (1 == scalar (keys %{$columns[$curr]})) {
            my $rule = (keys %{$columns[$curr]})[0];
            foreach my $other (0 .. $#columns) {
                if ($other != $curr && defined $columns[$other]->{$rule}) {
                    delete $columns[$other]->{$rule};
                    $changed = 1;
                }
            }
        }
    }
}

# Part 1
say "====== Part 1 ======";

report_number(1, $checksum);

say "====================";

exit unless $main::do_part_2;

# Part 2
say "====== Part 2 ======";

$result = 1;

foreach (0 .. $#columns) {
    if ((keys %{$columns[$_]})[0] =~ /departure/) {
        $result *= $ticket[$_];
    }
}

report_number(2, $result);

say "====================";

1;

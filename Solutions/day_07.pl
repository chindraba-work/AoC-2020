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
use List::Util qw(sum min max);

my $VERSION = '0.20.07';

my $result;
my %puzzle_data = map {
    my %contents;
    $_ =~ /^(.+) bags contain (.+)\.$/;
    my $color = $1;
    unless ($2 =~ /no other bags/) {
        %contents = map { $_ =~ /\s?(\d+) (.+) bag/; {$2 => $1}; } (split /,/, $2 );
        $contents{'needs'} = undef;
    } else {
        $contents{'needs'} = 0;
    }
    ($color => {%contents} );
} (read_lines $main::puzzle_data_file);

# Part 1
say "====== Part 1 ======";

my %valid = ();
my @find = ('shiny gold');
while (@find) {
    my @found = ();
    foreach my $to_find (@find) {
        my @new = grep { defined $_ } map {
            defined $puzzle_data{$_}{$to_find} ? $_ : undef;
        } (keys %puzzle_data);
        push @found, @new;
        map { $valid{$_} = 1; } @new;
    }
    @find = @found;
}
report_number(1, scalar (keys %valid));

say "====================";

exit unless $main::do_part_2;

# Part 2
say "====== Part 2 ======";

sub fill_bag {
    return 0 if 'needs' eq $_[1];
    unless (defined $puzzle_data{$_[1]}{'needs'}) {
        $puzzle_data{$_[1]}{'needs'} = sum( map {
            fill_bag($puzzle_data{$_[1]}{$_}, $_)
        } (keys %{$puzzle_data{$_[1]}}));
    }
    return $_[0] + $_[0] * $puzzle_data{$_[1]}{'needs'};
}

$result = 0;
report_number(2, fill_bag(1,'shiny gold') - 1);

say "====================";

1;

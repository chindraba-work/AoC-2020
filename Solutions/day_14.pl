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
use List::Util qw(sum);

my $VERSION = '0.20.14';

my $result;

my @puzzle_data = read_lines $main::puzzle_data_file;

my @memory;
my %big_memory;

my @commands = map {
    $_ =~ /(.+)\s+=\s+(.+)/;
    [$1, $2];
} (@puzzle_data);

sub mask_it {
    my $val = shift;
    my @mask = split //, shift;
    my @bit_stream = split(//,sprintf('%036b',$val));
    
    foreach (0..35) {
        $bit_stream[$_] = $mask[$_] unless 'X' eq $mask[$_];
    }
    no warnings;
    return oct("0b" . join('',@bit_stream));
}

sub store_it {
    my $loc = shift;
    my $val = mask_it(@_);
    $memory[$loc] = mask_it(@_);
}
sub merge_bits {
    my ($bit, $val, @list) = @_;
    my @new_list = ();
    foreach my $addr (@list) {
        my @group = split(//,sprintf('%036b',$addr));
        $group[$bit] = 1;
        no warnings;
        push(@new_list, oct("0b" . join('',@group)));
        if ('X' eq $val) {
            $group[$bit] = 0;
            push(@new_list, oct("0b" . join('',@group)));
        }
    }
    return @new_list;
}

sub mask_addr {
    my @map = split //, $_[1];
    my @list = ($_[0]);
    foreach my $bit (0..35) {
        @list = merge_bits($bit, $map[$bit], @list) unless '0' eq $map[$bit];
    }
    return @list;
}

sub store_them {
    my $val = shift;
    foreach (@_) {
        $big_memory{$_} = $val;
    }
}

# Part 1
say "====== Part 1 ======";
my $mask;
foreach (@commands) {
    if ('mask' eq @{$_}[0]) {
        $mask = @{$_}[1];
    } else {
        @{$_}[0] =~ /(\d+)/;
        my $add = $1;
        store_it($add, @{$_}[1], $mask);
    }
}
report_number(1, sum(map{ $_? $_:0;}(@memory)));

say "====================";

exit unless $main::do_part_2;

# Part 2
say "====== Part 2 ======";
if (!$main::use_live_data && defined $main::puzzle_data_file2) {
    @puzzle_data = read_lines $main::puzzle_data_file2;
}
@commands = map {
    $_ =~ /(.+)\s+=\s+(.+)/;
    [$1, $2];
} (@puzzle_data);

$mask = ();
foreach (@commands) {
    if ('mask' eq @{$_}[0]) {
        $mask = @{$_}[1];
    } else {
        @{$_}[0] =~ /(\d+)/;
        my @addr_list = mask_addr($1, $mask);
        store_them(@{$_}[1], @addr_list);
    }
}
@memory = ();
foreach (keys %big_memory) {
    push @memory, $big_memory{$_};
}

report_number(2, sum(map{ $_? $_:0;}(@memory)));
say "====================";

1;

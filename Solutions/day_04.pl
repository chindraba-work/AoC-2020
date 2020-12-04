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

my $VERSION = '0.20.04';

my $do2 = 1;
my $day_num = 4;
my $part_num;
my $puzzle_data_file = $main::data_file;
my ($valid, $count, $count_min, $count_max, $letter, $phrase);
my $result;

my $testing = 0;
my @check_data =(
'ecl:gry pid:860033327 eyr:2020 hcl:#fffffd',
'byr:1937 iyr:2017 cid:147 hgt:183cm',
'',
'iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884',
'hcl:#cfa07d byr:1929',
'',
'hcl:#ae17e1 iyr:2013',
'eyr:2024',
'ecl:brn pid:760753108 byr:1931',
'hgt:179cm',
'',
'hcl:#cfa07d eyr:2025 pid:166559648',
'iyr:2011 ecl:brn hgt:59in',
);

my @passport_list = map {
    { map { split /:/, $_ } (split / /, $_) } 
} ($testing ? split("  ", join(' ', @check_data)) : read_comma_list($puzzle_data_file, "  "));

# Part 1
$part_num = 1;
$result = 0;
map {
    $result++ if (
        defined $_->{'byr'} &&
        defined $_->{'iyr'} &&
        defined $_->{'eyr'} &&
        defined $_->{'hgt'} &&
        defined $_->{'hcl'} &&
        defined $_->{'ecl'} &&
        defined $_->{'pid'}
    )
} (@passport_list);


printf "\n%s\nAdvent of Code 2020, Day %u Part %u : the answer is %u\n\n%s",
    $main::break_line,
    $day_num,
    $part_num,
    $result,
    $main::break_line;

exit unless $do2;
# Part 2
$part_num = 2;

$result = 0;
no warnings qw( experimental::smartmatch );
map {
    $result++ if (
        defined $_->{'byr'} && $_->{'byr'} ~~ [1920 .. 2002] &&
        defined $_->{'iyr'} && $_->{'iyr'} ~~ [2010 .. 2020] &&
        defined $_->{'eyr'} && $_->{'eyr'} ~~ [2020 .. 2030] &&
        defined $_->{'hgt'} && $_->{'hgt'} =~ /^([0-9]+)(in|cm)$/ &&
            ( $2 eq 'cm' && $1 ~~ [150 .. 193] || $2 eq 'in' && $1 ~~ [59 .. 76] ) &&
        defined $_->{'hcl'} && $_->{'hcl'} =~ /\#[0-9a-f]{6}/ &&
        defined $_->{'ecl'} && $_->{'ecl'} =~ /amb|blu|brn|gry|grn|hzl|oth/ &&
        defined $_->{'pid'} && $_->{'pid'} =~ /^[0-9]{9}$/
    )
} (@passport_list);

printf "\n%s\nAdvent of Code 2020, Day %u Part %u : the answer is %u\n\n%s",
    $main::break_line,
    $day_num,
    $part_num,
    $result,
    $main::break_line;

1;

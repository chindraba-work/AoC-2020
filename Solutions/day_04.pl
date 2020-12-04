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
use Data::Dumper;

my $VERSION = '0.20.04';

my $do2 = 1;
my $day_num = 4;
my $part_num;
my $puzzle_data_file = $main::data_file;
my ($valid, $count, $count_min, $count_max, $letter, $phrase);
my $result;

my $testing = 0;
my @check_data =(
'eyr:1972 cid:100',
'hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926',
'',
'iyr:2019',
'hcl:#602927 eyr:1967 hgt:170cm',
'ecl:grn pid:012533040 byr:1946',
'',
'hcl:dab227 iyr:2012',
'ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277',
'',
'hgt:59cm ecl:zzz',
'eyr:2038 hcl:74454a iyr:2023',
'pid:3556412378 byr:2007',
);
# my @check_data =(
# 'pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980',
# 'hcl:#623a2f',
# '',
# 'eyr:2029 ecl:blu cid:129 byr:1989',
# 'iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm',
# '',
# 'hcl:#888785',
# 'hgt:164cm byr:2001 iyr:2015 cid:88',
# 'pid:545766238 ecl:hzl',
# 'eyr:2022',
# '',
# 'iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719',
# );

my @puzzle_data = $testing ? @check_data : read_lines($puzzle_data_file);

sub normalize {
    my $set = join ',', @_;
    $set =~ s/,,/\n/g;
    $set =~ s/,/ /g;
    return split /\n/, $set;
}
sub passport_record {
    my %passport_data = map { split /:/, $_ } (split / /, $_[0]);
}

my @passport_list = map { {passport_record $_} } (normalize @puzzle_data);
    
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
        defined $_->{'hcl'} &&
            $_->{'hcl'} =~ /\#[0-9a-f]{6}/ &&
        defined $_->{'ecl'} &&
            $_->{'ecl'} =~ /amb|blu|brn|gry|grn|hzl|oth/ &&
        defined $_->{'pid'} &&
            $_->{'pid'} =~ /^[0-9]{9}$/
    )
} (@passport_list);

printf "\n%s\nAdvent of Code 2020, Day %u Part %u : the answer is %u\n\n%s",
    $main::break_line,
    $day_num,
    $part_num,
    $result,
    $main::break_line;

1;

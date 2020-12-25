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

my $VERSION = '0.20.22';

my $result;
my $part;

my @puzzle_data = read_lines $main::puzzle_data_file;

my @elf_deck;
my @crab_deck;
my %final_deck;
my $target = \@elf_deck;

foreach (@puzzle_data) {
    if ('' eq $_) {
        $target = \@crab_deck;
    } elsif (m/^\d+$/) {
        push @{$target}, 0 + $_;
    }
}

my %game_deck = (
    elf => [@elf_deck],
    crab =>  [@crab_deck],
);

sub play_game {
    my %game_status = @_;
    my $elf = $game_status{'elf'};
    my $crab = $game_status{'crab'};
    my %status_log;
    my $log_key;
    my $winner = '';
    while ('' eq $winner && 0 <= $#{$elf} && 0 <= $#{$crab}) {
        $log_key = sprintf "E:%s:C:%s", join(':', (@{$elf})), join(':', (@{$crab}));
        if (defined($game_status{'recurse'}) && (exists($status_log{$log_key}))) {
            $winner = 'elf';
        } else {
            $status_log{$log_key} = undef;
            my $round_to = undef;
            my ($elf_card,$crab_card) = (shift @{$elf}, shift @{$crab});
            if (
                defined $game_status{'recurse'} 
                && $elf_card <= scalar(@{$elf})
                && $crab_card <= scalar(@{$crab})
            ) {
                my %subgame = play_game(
                    elf => [@{$elf}[0 .. $elf_card - 1]],
                    crab => [@{$crab}[0 .. $crab_card - 1]],
                    recurse => 1,
                );
                $round_to = $subgame{'winner'};
            } else {
                $round_to = (1 == ($elf_card <=> $crab_card))? 'elf' : 'crab';
            }
            if ('elf' eq $round_to) {
                push @{$elf}, ($elf_card, $crab_card);
            } else {
                push @{$crab}, ($crab_card, $elf_card);
            }
        }
    }
    if ('' eq $winner) {
        $game_status{'winner'} = ($#{$crab} < $#{$elf})? 'elf' : 'crab';
    } else {
        $game_status{'winner'} = $winner;
    }
    return %game_status;
}

# Part 1
$part = 1;
say "====== Part 1 ======";
$result = 0;
%final_deck = play_game(
    elf => [@{$game_deck{'elf'}}],
    crab => [@{$game_deck{'crab'}}],
);
foreach my $card (0 .. $#{$final_deck{$final_deck{'winner'}}}) {
    $result += 
        ${$final_deck{$final_deck{'winner'}}}[$card]
        * (scalar(@{$final_deck{$final_deck{'winner'}}}) - $card);
}
report_number($part, $result);

say "====================";

exit unless $main::do_part_2;

# Part 2
$part = 2;
say "====== Part 2 ======";
$result = 0;
%final_deck = play_game(
    elf => [@{$game_deck{'elf'}}],
    crab => [@{$game_deck{'crab'}}],
    recurse => 1,
);
foreach my $card (0 .. $#{$final_deck{$final_deck{'winner'}}}) {
    $result += 
        ${$final_deck{$final_deck{'winner'}}}[$card]
        * (scalar(@{$final_deck{$final_deck{'winner'}}}) - $card);
}
report_number($part, $result);

say "====================";

1;

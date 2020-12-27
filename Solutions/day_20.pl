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

my $VERSION = '0.20.20';

my $result;
my $part;

my @puzzle_data = read_lined_hash $main::puzzle_data_file, '  ';
my %tiles = ();
my %borders = ();
my @corners = ();
my @titles = ();
my %anchor_search;

sub map_borders {
    my ($tile, @data) = @_;
    my %edges = ();
    $edges{'N:U'} = $data[0];
    $edges{'N:R'} = join('', reverse (map {(split(//, $_))[0]} @data));
    $edges{'N:D'} = join('', reverse split(//, $data[$#data]));
    $edges{'N:L'} = join('', map {(split(//, $_))[$#data]} @data);
    
    $edges{'F:U'} = join('', reverse split //, $data[0]);
    $edges{'F:R'} = join('', reverse (map {(split(//, $_))[$#data]} @data));
    $edges{'F:D'} = $data[$#data];
    $edges{'F:L'} = join('', map {(split(//, $_))[0]} @data);
    foreach (qw(N:U N:R N:D N:L F:U F:R F:D F:L)) {
        $tiles{$tile}{$_} = $edges{$_};
        $borders{$edges{$_}}{$tile} = "$_";
    }
}

sub map_tile {
    my $title = shift;
    my ($tile) = ($title =~ /(\d+)$/);
    $tiles{$tile}{'image'} = [(split ' ', $_[0])];
    map_borders($tile, (split ' ', $_[0]));
}

sub remap_tile {
    my $tile = $_[0];
    foreach my $dir (qw(N:U N:R N:L N:D F:U F:L F:R F:D)) {
        delete $borders{$tiles{$tile}{$dir}}->{$tile};
        if (0 == scalar (keys %{$borders{$tiles{$tile}{$dir}}})) {
            delete $borders{$tiles{$tile}{$dir}};
        }
    }
    map_borders($tile, @{$tiles{$tile}{'image'}});
}

sub turn_matrix {
    my $direction = shift;
    my @matrix = @_;
    my @turned_grid = ();
    my @turned_matrix = ();
    my $size = $#matrix;
    if ('N' eq $direction || 'U' eq $direction) {
        @turned_matrix = @_;
    } else {
        foreach my $row (0 .. $size ) {
            my @natrual_row = (split(//,$matrix[$row]));
            if ('D' eq $direction) {
                @{$turned_grid[$size - $row]} = ('', reverse(split(//,$matrix[$row])));
            } elsif ('F' eq $direction) {
                @{$turned_grid[$row]} = ('', reverse(split(//,$matrix[$row])));
            } else {
                foreach (0 .. $size) {
                    if ('L' eq $direction) {
                        push @{$turned_grid[$size - $_]}, $natrual_row[$_];
                    } elsif ('R' eq $direction) {
                        unshift @{$turned_grid[$_]}, $natrual_row[$_];
                    }
                }
            }
        }
        foreach (0 .. $size) {
            push @turned_matrix, (join('', @{$turned_grid[$_]}));
        }
    }
    return \@turned_matrix;
}

sub turn_tile {
    my $direction = shift;
    my $tile = shift;
    $tiles{$tile}{'image'} = turn_matrix($direction, @{$tiles{$tile}{'image'}});
    remap_tile($tile);
}

sub trim_matrix {
    my @source = @_;
    my @trimmed_matrix;
    foreach (1 .. $#source -1) {
        push @trimmed_matrix, join("", (split(//, $source[$_]))[1 .. $#source - 1]);
    }
    return (@trimmed_matrix);
}

sub load_tiles {
    foreach (@puzzle_data) {
        my $title = (keys %{$_})[0];
        push @titles, $title;
        map_tile($title, ${$_}{$title});
    }
}

sub corner_sort {
    my $tile = shift;
    my $corner;
    push @corners, $tile;
    if ( 1 == (keys %{$borders{$tiles{$tile}{'N:U'}}})) {
        if ( 1 == (keys %{$borders{$tiles{$tile}{'N:R'}}})) {
            $corner = 'NW';
        }
        if ( 1 == (keys %{$borders{$tiles{$tile}{'N:L'}}})) {
            $corner = 'NE';
        }
    } elsif ( 1 == (keys %{$borders{$tiles{$tile}{'N:D'}}})) {
        if ( 1 == (keys %{$borders{$tiles{$tile}{'N:R'}}})) {
            $corner = 'SW';
        }
        if ( 1 == (keys %{$borders{$tiles{$tile}{'N:L'}}})) {
            $corner = 'SE';
        }
    }
    $anchor_search{$corner} = $tile;
}

sub border_sort {
    load_tiles();
    my @signatures = (keys %borders);
    my %outer = ();
    foreach my $signature (@signatures)  {
        if (1 == scalar (keys %{$borders{$signature}})) {
            if (exists $outer{(keys %{$borders{$signature}})[0]}) {
                $outer{(keys %{$borders{$signature}})[0]}++;
                if ( 4 == $outer{(keys %{$borders{$signature}})[0]} ) {
                    corner_sort( (keys %{$borders{$signature}})[0] );
                }
            } else {
                $outer{(keys %{$borders{$signature}})[0]} = 1;
            }
        }
    }
}

sub anchor_corner {
    my $base_corner;
    if (exists $anchor_search{'NW'}) {
        $base_corner = $anchor_search{'NW'};
    } elsif (exists $anchor_search{'NE'}) {
        $base_corner = $anchor_search{'NE'};
        turn_tile('L', $base_corner);
    } elsif (exists $anchor_search{'SE'}) {
        $base_corner = $anchor_search{'SE'};
        turn_tile('D', $base_corner);
    } elsif (exists $anchor_search{'SW'}) {
        $base_corner = $anchor_search{'SW'};
        turn_tile('D', $base_corner);
        turn_tile('F', $base_corner);
    }
    return $base_corner;
}

sub bottom_match {
    my $from_edge = shift;
    my $from = shift;
    my $to;
    my $target = $tiles{$from}{$from_edge};
    foreach (keys %{$borders{$target}}) {
        $to = $_ if ($_ ne $from);
    }
    return undef if (! defined $to);
    my $match_edge = $borders{$target}{$to};
    my ($a, $b) = ($match_edge =~ /(.):(.)/);
    if ('F' eq $a) {
        turn_tile('F', $to);
        $match_edge = $borders{$target}{$to};
    }
    if ('U' ne $b) {
        turn_tile($b, $to);
        $match_edge = $borders{$target}{$to};
    }
    return $to;
}

sub side_match {
    my $from_edge = shift;
    my $from = shift;
    my $to;
    my $target = $tiles{$from}{$from_edge};
    foreach (keys %{$borders{$target}}) {
        $to = $_ if ($_ ne $from);
    }
    return undef if (! defined $to);
    my $match_edge = $borders{$target}{$to};
    my ($a, $b) = ($match_edge =~ /(.):(.)/);
    if ('N' eq $a) {
        turn_tile('F', $to);
        $match_edge = $borders{$target}{$to};
    }
    if ('U' eq $b) {
        turn_tile('L', $to);
        $match_edge = $borders{$target}{$to};
    } elsif ('R' eq $b) {
        turn_tile('D', $to);
        $match_edge = $borders{$target}{$to};
    } elsif ('D' eq $b) {
        turn_tile('R', $to);
        $match_edge = $borders{$target}{$to};
    }
    return $to;
}

sub stitch_tiles {
    border_sort();
    my @grid;
    my $motion = 'side';
    my $grid_x = 0;
    my $grid_y = 0;
    $grid[$grid_y][$grid_x] = anchor_corner();
    my $joined_tile = undef;
    my $continue = 1;
    while ($continue) {
        if ('side' eq $motion) {
            $joined_tile = side_match('N:L', $grid[$grid_y][$grid_x]);
            if (defined $joined_tile) {
                $grid_x++;
                $grid[$grid_y][$grid_x] = $joined_tile;
            } else {
                $motion = 'down';
                $grid_x = 0;
            }
        } else {
            $joined_tile = bottom_match('F:D', $grid[$grid_y][$grid_x]);
            if (defined $joined_tile) {
                $grid_y++;
                $grid[$grid_y][$grid_x] = $joined_tile;
                $motion = 'side'
            } else {
                $continue = 0;
            }
        }
    }
    return (@grid);
}

sub sat_image {
    my @tile_grid = stitch_tiles();
    my $marks = 0;
    my @image_map = ();
    for my $grid_y (0 .. $#tile_grid) {
        my @tile_row = @{$tile_grid[$grid_y]};
        for my $grid_x (0 .. $#tile_row) {
            my @tile_data = trim_matrix(@{$tiles{$tile_row[$grid_x]}{'image'}});
            my $top_row = $grid_y * scalar @tile_data;
            foreach my $image_row (0 .. $#tile_data) {
                $image_map[$top_row + $image_row] .= $tile_data[$image_row];
            }
        }
    }
    foreach (0 .. $#image_map) {
        $marks += ($image_map[$_] =~ s/\#/V/g);
    }
    # Highlighted in the puzzle is "after flipping and rotating it", so I'll start with that.
    @image_map = @{turn_matrix('L',@{turn_matrix('F', @image_map)})};
    return ($marks, \@image_map);
}

sub check_sea_monster {
    my ($image, $row, $offset) = @_;
    my $waterline = "^.{" . ($offset + 1) . "}(V.{2}){5}V";
    if ($image->[$row + 1] =~ /$waterline/) {
        return 1 if ('V' eq substr($image->[$row - 1],$offset + 18, 1));
        return 0;
    } else {
        return 0
    }
}

sub find_sea_monsters {
    my $image = shift;
    my $turns = 0;
    my $flipped = 0;
    my $monsters_found = 0;
    while (1) {
        for my $row (1 .. $#{$image} -1 ) {
            my $searching = 1;
            my $padding = '(.*?)';
            while ($searching) {
                my $loop_line = "^$padding(V.{4}V){3}V{2}";
                if ($image->[$row] =~ /$loop_line/) {
                    my $margin = length($1);
                    $monsters_found++ if (check_sea_monster($image, $row, $margin));
                    $margin++;
                    $padding = "(.{$margin,})";
                } else {
                    $searching = 0;
                }
            }
        }
        return $monsters_found if (0 < $monsters_found);
        $image = turn_matrix('L', @{$image});
        if (4 == ++$turns) {
            return 0 if ($flipped);
            $image = turn_matrix('F', @{$image});
            $turns = 0;
            $flipped = 1;
        }
    }
}



# Part 1
$part = 1;
say "====== Part 1 ======";
my ($hashes, $image) = sat_image();

$result = 1;
foreach (@corners) {
    $result *= $_;
}

report_number($part, $result); # 20899048083289 and 54755174472007
say "====================";
exit unless $main::do_part_2;

# Part 2
$part = 2;
say "====== Part 2 ======";

my $monsters = find_sea_monsters($image);
$result = $hashes - 15 * $monsters;

report_number($part, $result); # 273 and 1692

say "====================";

1;

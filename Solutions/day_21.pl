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

my $VERSION = '0.20.21';

my $result;
my $part;

my @puzzle_data = read_lines $main::puzzle_data_file;

my $item_count = 0;
    # How many times each ingredient is listed
my %ingredient_counts;
    # list of ingredients in each item
my @item_ingredients; #  [item] = {ingredient => undef, ingredient => undef },
    # list of items each ingredient is in
my %ingredient_items; # { ingredient => { 1 => undef, 4 => undef }, ingredient => { 3 => undef }, }
    # list of possible allergens for each ingredient
my %ingredient_allergens; # { ingredient => { allergen => undef, allergen => undef} }
    # list of ingredients with known allergens
my %ingredient_pairs; # { ingredient => allergen, ingredient => allergen, ingredient => allergen, }

    # list of allergens in each item
my @item_allergens; # index matches main input list, element is {allergen => undef},
    # list of items each allergen is listed for
my %allergen_items; # { allergen => { 1=> undef, 3 => undef }, allergen => { 5 => undef }, }
    # list of possible ingredients for each allergen
my %allergen_ingredients; # allergen => { ingredient => undef, ingredient => undef, }
    # list of allergens with know ingredients
my %allergen_pairs; # { allergen => ingredient, allergen => ingredient, }

# file allergen associations for an item
sub load_allergens {
    my @allergen_list = split /, /, $_[0];
    my @ingredient_list = split / /, $_[1];
    foreach my $allergen (@allergen_list) {
        $item_allergens[$item_count]->{$allergen} = undef;
        $allergen_items{$allergen}->{$item_count} = undef;
        foreach my $ingredient (@ingredient_list) {
            $allergen_ingredients{$allergen}->{$ingredient} = undef;
        }
    }
}

# file ingredient associations for an item
sub load_ingredients {
    my @ingredient_list = split / /, $_[0];
    my @allergen_list = split /, /, $_[1];
    foreach my $ingredient (@ingredient_list) {
        $item_ingredients[$item_count]->{$ingredient} = undef;
        $ingredient_items{$ingredient}->{$item_count} = undef;
        if (exists $ingredient_counts{$ingredient}) {
            $ingredient_counts{$ingredient}++;
        } else {
            $ingredient_counts{$ingredient} = 1;
        }
        foreach my $allergen (@allergen_list) {
            $ingredient_allergens{$ingredient}->{$allergen} = undef;
        }
    }
}

# file the item assications from the input
sub load_items {
    foreach my $item (@_) {
        my ($ingredient_list, undef, $allergen_list) = ($item =~ /^([^()]+)( \(contains ([^()]+)\))?$/);
        load_ingredients($ingredient_list, $allergen_list);
        load_allergens($allergen_list, $ingredient_list);
        $item_count++;
    }
}

# test for resolved allergen (allergen)
sub allergen_resolved {
    return (exists $allergen_pairs{$_[0]})? 1 : 0;
}

# test for resolved ingredient (ingredient)
sub ingredient_resolved {
    return (exists $ingredient_pairs{$_[0]})? 1 : 0;
}

# list of unresolved allergens for an item (item_num)
sub open_allergens {
    my @allergen_list;
    foreach my $allergen (keys %{$item_allergens[$_[0]]}) {
        if (! allergen_resolved($allergen)) {
            push @allergen_list, $allergen;
        }
    }
    return (@allergen_list);
}

# list of unresolved ingredients for an item (item_num)
sub open_ingredients {
    my @ingredient_list;
    foreach my $ingredient (keys %{$item_ingredients[$_[0]]}) {
        if (! ingredient_resolved($ingredient)) {
            push @ingredient_list, $ingredient;
        }
    }
    return (@ingredient_list);
}

# create a list of items with a single unresolved allergen
sub find_filterable_items {
    my %filterable_items;
    foreach my $item_num (0 .. $#item_allergens) {
        my @allergens = open_allergens($item_num);
        if (1 == scalar @allergens) {
            $filterable_items{$item_num} = $allergens[0];
        }
    }
    my @item_list = (sort {
        $filterable_items{$a} cmp $filterable_items{$b}
    } keys %filterable_items);
    return (\%filterable_items, @item_list);
}

# reduce list of possible ingredients by elimination
sub sift_allergen {
    my $target = $_[0];
    my $filter_item = $_[1];
    my @items_to_check = keys %{$allergen_items{$target}};
    foreach my $item_num (@items_to_check) {
        if ($item_num ne $filter_item) {
            foreach my $ingredient (keys %{$allergen_ingredients{$target}}) {
                if (! exists $item_ingredients[$item_num]->{$ingredient}) {
                    delete $allergen_ingredients{$target}->{$ingredient};
                }
            }
        }
    }
}

# process sifted list of ingredients looking for lists of one
sub filter_allergen {
    my ($allergen, $item) = @_;
    my %ref_list;
    my @ingredient_list = open_ingredients($item);
    foreach my $ingredient (@ingredient_list) {
        if (exists $allergen_ingredients{$allergen}->{$ingredient}) {
            $ref_list{$ingredient} = undef;
        }
    }
    $allergen_ingredients{$allergen} = {%ref_list};
    sift_allergen($allergen, $item);
    @ingredient_list = keys %{$allergen_ingredients{$allergen}};
    if ($#ingredient_list) {
        return 0;
    } else {
        my $ingredient = $ingredient_list[0];
        $ingredient_pairs{$ingredient} = $allergen;
        $allergen_pairs{$allergen} = $ingredient;
        return 1;
    }
}

# process the listings until all allergens have an ingredient paired
sub filter_allergens {
         # list items with a single unresolved allergen
    my ($allergens_to_filter, @items_to_filter) = find_filterable_items ();
    while (scalar @items_to_filter) {
        my $item_to_filter = shift @items_to_filter;
        my $allergen = $allergens_to_filter->{$item_to_filter};
        if (filter_allergen($allergen, $item_to_filter)) {
            ($allergens_to_filter, @items_to_filter) = find_filterable_items ();
        }
    }
}

load_items(@puzzle_data);
filter_allergens();

# Part 1
$part = 1;
say "====== Part 1 ======";

$result = 0;
foreach my $ingredient (keys %ingredient_items) {
    if (!exists $ingredient_pairs{$ingredient}) {
        $result += $ingredient_counts{$ingredient};
    }
}

report_number($part, $result);

say "====================";

exit unless $main::do_part_2;

# Part 2
$part = 2;
say "====== Part 2 ======";
$result = join(',',(sort {
    $ingredient_pairs{$a} cmp $ingredient_pairs{$b}
} keys %ingredient_pairs));

report_string($part, $result);

say "====================";

1;

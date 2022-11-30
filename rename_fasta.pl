  use strict;
  use warnings;

    my @arr;

    while (<>) {
        chomp;
        my @a = split /\t/;
        push @arr, $a[1] . "_" . $a[0] if length;
        last if eof; }

    while (<>) {
        print /^>/ ? ">" . shift(@arr) . "\n" : $_; }

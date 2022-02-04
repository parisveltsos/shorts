while (<>) { $. > 1 and /^>/ ? print "\n" : chomp; print }

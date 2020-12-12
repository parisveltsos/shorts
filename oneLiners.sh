# Count bases in fastq

cat test.fastq | paste - - - - | cut -f 2 | tr -d '\n' | wc -c 
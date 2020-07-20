# bitcoin-all-addresses
i will not spare the time. give up.

lists of unique addresses from blockchair output dumps

thank you, blockchair team!

files (4210 files):

blockchair_bitcoin_outputs_20090103.tsv.gz to blockchair_bitcoin_outputs_20200718.tsv.gz

total number of unique addresses: ?

general methodology:

1.download all output dump files from blockchair;

1.1.check the smallest file sizes to be sure those files downloaded correctly;

1.2.also test .gz files `gunzip -t [*.gz]`;

2.uncompress files and cut the 7th field (recipient) `gunzip -c [FILE] | cut -d$'\t' -f7 > [FILE].addr.txt`;

3?.use perl and print addresses the first time they are seen `perl -ne 'print unless $seen{$_}++' $( printf '%s\n' *.addr.txt | sort -t_ -k4 -n )`;

4?.split resulting file at about 90MB `split -C 9000000 [SINGLEFILE.txt]`;

references:

https://blockchair.com/dumps/

https://gz.blockchair.com/bitcoin/

http://addresses.loyce.club/?C=M;O=D

http://loyceipv6.tk:20319/blockdata

https://bitcointalk.org/index.php?topic=5259621.0

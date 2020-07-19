# bitcoin-all-addresses
lists of unique addresses from blockchair output dumps

thank you, blockchair team!

files (4210 files):

blockchair_bitcoin_outputs_20090103.tsv.gz to blockchair_bitcoin_outputs_20200718.tsv.gz

total number of unique addresses: ?

general methodology:

1.download all output dump files from blockchair;

1.1.check the smallest file sizes to be sure those files downloaded correctly;

1.2.also test .gz files `gunzip -t [*.gz]`;

2.uncompress files and cut the 7th field (recipient) `gunzip -c [FILE] | cut -d$'\t' -f7`;

3.use perl and print addresses the first time they are seen `perl -ne 'print unless $seen{$_}++'`;

4.split in files of about 180MB `split -C 180000000 [SINGLEFILE.txt]`;

5.make 7z files and hope they are below 100MB each to upload to github.

references:

https://blockchair.com/dumps/

https://gz.blockchair.com/bitcoin/

http://addresses.loyce.club/?C=M;O=D

http://loyceipv6.tk:20319/blockdata

https://bitcointalk.org/index.php?topic=5259621.0

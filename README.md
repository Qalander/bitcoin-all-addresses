# bitcoin-all-addresses
[wait for the uploading, it is going to be somewhat painful for me]

lists of unique addresses from blockchair output dumps

thank you, blockchair team!

dump files from blockchair (4210 files) from 20090103 to 20200718

checksum of dump files from blockchair is available.

address list is split in 262 files totalling approximately 24.58GB.

one feature of my lists is i tried to keep the order of addresses in which they first appear in blockchair dumps.

addresses total: 1483853800

unique addresses total: 692773144

unique addresses 1*: ?

unique addresses 3*: ?

unique addresses bc*: ?

unique addresses * -*: ?

general methodology:

1.download all output dump files from blockchair;

1.1.check the smallest file sizes to be sure those files downloaded correctly;

1.2.also test .gz files:

    gunzip -t [*.gz]

2.uncompress files and cut the 7th field (recipient):

    for f in *.tsv.gz ;do gunzip -c "$f" | cut -d$'\t' -f7 > "${f}.addr.txt" ;done

3.concatenate resulting files in the original order;

4.number lines:

    nl concat.txt  > concatnl.txt

4.sort and output unique addresses only from the previous concatenated file; set large temporary diretory for buffers and LC_ALL to C (faster):

    TMPDIR="$PWD" LC_ALL=C sort -k2 -u -o concatnl.uniq.txt concatnl.txt

5.rearrange into the original order and cut only the address field (also set temp dir and LC_ALL):

    sort -n concatnl.uniq.txt | cut -f2 > final.txt

6.split resulting file at about 94MB to upload to github:

    split -C 94000000 final.txt


	Please consider giving me a nickle!  =)
  
		bc1qlxm5dfjl58whg6tvtszg5pfna9mn2cr2nulnjr


references:

https://blog.chainalysis.com/reports/bitcoin-addresses

https://blockchair.com/dumps/

https://gz.blockchair.com/bitcoin/

http://addresses.loyce.club/?C=M;O=D

http://loyceipv6.tk:20319/blockdata

https://bitcointalk.org/index.php?topic=5259621.0

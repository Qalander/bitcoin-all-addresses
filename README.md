# bitcoin-all-addresses
lists of unique addresses from blockchair output dumps

thank you, blockchair team!

files (4210 files):

from 20090103 to 20200718

checksum of dump files from blockchair is available.


addresses total: ?

unique addresses total: ?

unique addresses 1*:

unique addresses 3*:

unique addresses *-*:

general methodology:

1.download all output dump files from blockchair;

1.1.check the smallest file sizes to be sure those files downloaded correctly;

1.2.also test .gz files:

    gunzip -t [*.gz]

2.uncompress files and cut the 7th field (recipient):

    for f in *.tsv.gz ;do gunzip -c "$f" | cut -d$'\t' -f7 > "${f}.addr.txt" ;done

3.concatenate resulting files;

4.number lines:

    nl concat.txt  > concatnl.txt

4.sort and output unique addresses only from the previous concatenated file (requires large temp directory):

   TMPDIR="$PWD" LC_ALL=C sort -k2 -u -o concatnl.uniq.txt concatnl.txt

5.rearrange into the original order and cut only the address field.

   sort -n concatnl.uniq.txt | cut -f2 > final.txt

6.split resulting file at about 90MB `split -C 9000000 [SINGLEFILE.txt]` to upload to github.

references:

http???????????????????????????????

https://blockchair.com/dumps/

https://gz.blockchair.com/bitcoin/

http://addresses.loyce.club/?C=M;O=D

http://loyceipv6.tk:20319/blockdata

https://bitcointalk.org/index.php?topic=5259621.0

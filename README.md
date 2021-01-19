# bitcoin-all-addresses

Lists of unique addresses from blockchair output dumps.

_Thank you, blockchair team and loyceV!_

[Dump files from blockchair](https://gz.blockchair.com/bitcoin/outputs/):
4393 files, from 20090103 to 20210117

[Checksum of dump files](https://github.com/mountaineerbr/bitcoin-all-addresses/blob/master/cksum.blockchair.outputs.txt)
from blockchair is available.

Address list is split in 297 files (xaa to xlk)
totalling approximately 27.89GB
(if you `git clone` the entire repo, it will be larger than that).

One feature of my lists is I kept the order of addresses
in which they first appeared in blockchair dumps.

Stats (until 2020-07-18)

TYPE            | MATCHES
:---------------|---------------:
       __addresses total__| 1483853800
__unique addresses total__|  692773144
__unique addresses 1*__|     470763465
__unique addresses 3*__ |    167765027
__unique addresses bc1*__|    39094520
__unique addresses with -__|  15150132 

Stats (until 2021-01-17)

TYPE            | MATCHES
:---------------|---------------:
       __addresses total__| 1652542603
__unique addresses total__|  784345877
__unique addresses 1*__|     510031682
__unique addresses 3*__ |    208054134
__unique addresses bc1*__|    50366868
__unique addresses with -__|  15893193

OBS: text cut from `blockchair_bitcoin_outputs_20201205.tsv.gz` seems
to contain a last empty line.

OBS: addresses starting with - in blockchair dumps are unspendable
and usually encode data.

---

## General methodology:

### 1. Download all output dump files from blockchair,
see script
[blockchair.btcoutputs.sh](https://github.com/mountaineerbr/bitcoin-all-addresses/blob/master/blockchair.btcoutputs.sh) ;

#### 1.1. Check the smallest file sizes to be sure those files downloaded correctly;

OBS: Make sure files are processed in the correct date order in all steps required!

#### 1.2. Also test .tsv.gz files:

```bash
gunzip -t [*.tsv.gz]
```

### 2. Uncompress files and cut the 7th field (recipient):

```bash
for f in *.tsv.gz ;do gunzip -c "$f" | cut -d$'\t' -f7 > "${f}.addr.txt" ;done
```

### 3. Concatenate resulting files in the original order and add line numbers

```bash
#sort *.addr.txt files by date and make a filename array
unset FILES
while read
do
	FILES+=( "$REPLY" )
done <<<"$( printf '%s\n' *.addr.txt | sort -t_ -k4 -n )"

cat -n "${FILES[@]}"
```

### 4. Sort and output unique addresses only from the previous concatenated file;
tip: set large temporary directory for buffers and LC_ALL and LANG to C
(GNU tools will work faster) and also consider setting `sort` option `--parallel=N`:

```bash
export TMPDIR=/some/large/tmpdir
export LC_ALL=C LANG=C

sort -k2 -u -o concatnl.uniq.txt concatnl.txt
```

### 5. Rearrange into the original order and cut only the address field:

```bash
sort -n concatnl.uniq.txt | cut -f2 > final.txt
```

### 6. Split resulting file at about 94MB to upload to github:

```bash
split -C 94000000 final.txt
```

You may pipe some of these commands together, check script
[blockchair.btcoutputs.process.sh](https://github.com/mountaineerbr/bitcoin-all-addresses/blob/master/blockchair.btcoutputs.process.sh)
for some code tips.

---

	Please consider sending me a nickle!  =)
  
		bc1qlxm5dfjl58whg6tvtszg5pfna9mn2cr2nulnjr

---

## References

Original topic in Bitcointalk that led to this repo -- https://bitcointalk.org/index.php?topic=5259621.0

https://blog.chainalysis.com/reports/bitcoin-addresses

https://blockchair.com/dumps/

https://gz.blockchair.com/bitcoin/

http://addresses.loyce.club/?C=M;O=D

http://loyceipv6.tk:20319/blockdata

## See also

loyceV address lists, which should be updated often (but his lists are not chronological):

List of all Bitcoin addresses ever used -- https://bitcointalk.org/index.php?topic=5265993.0

List of all Bitcoin addresses with a balance -- https://bitcointalk.org/index.php?topic=5254914.0


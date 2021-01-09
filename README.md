# bitcoin-all-addresses

lists of unique addresses from blockchair output dumps

_thank you, blockchair team!_

[dump files from blockchair](https://blockchair.com/dumps/): 4210 files, from 20090103 to 20200718

checksum of dump files from blockchair is available.

address list is split in 262 files (xaa to xkb) totalling approximately 24.58GB (if you `git clone` the repo, it is larger than that).

one feature of my lists is i kept the order of addresses in which they first appeared in blockchair dumps.

type            | matches
---------------:|---------------:
__addresses total__| 1483853800
__unique addresses total__| 692773144
__unique addresses 1*__| 470763465
__unique addresses 3*__ |167765027
__unique addresses bc*__| 39094520
__unique addresses with -__| 15150132 

---

## general methodology:

### 1.download all output dump files from blockchair, see example script `blockchair.btcoutputs.sh` ;


#### 1.1.check the smallest file sizes to be sure those files downloaded correctly;

OBS: make sure files are processed in the correct date order in all steps required!

#### 1.2.also test .gz files:

```bash
gunzip -t [*.gz]
```

### 2.uncompress files and cut the 7th field (recipient); see also script `blockchair.btcoutputs.addrgrep.sh` :

```bash
for f in *.tsv.gz ;do gunzip -c "$f" | cut -d$'\t' -f7 > "${f}.addr.txt" ;done
```

### 3.concatenate resulting files in the original order;

### 4.number lines:

```bash
nl concat.txt  > concatnl.txt
```

### 5.sort and output unique addresses only from the previous concatenated file; set large temporary diretory for buffers and LC_ALL to C (faster):

```bash
export TMPDIR="$PWD"
export LC_ALL=C

sort -k2 -u -o concatnl.uniq.txt concatnl.txt
```

### 6.rearrange into the original order and cut only the address field (also export $TMPDIR and $LC_ALL):

```bash
sort -n concatnl.uniq.txt | cut -f2 > final.txt
```

### 7.split resulting file at about 94MB to upload to github:

```bash
split -C 94000000 final.txt
```

---

	Please consider giving me a nickle!  =)
  
		bc1qlxm5dfjl58whg6tvtszg5pfna9mn2cr2nulnjr

---

## references

Original topic in Bitcointalk that led to this repo -- https://bitcointalk.org/index.php?topic=5259621.0

https://blog.chainalysis.com/reports/bitcoin-addresses

https://blockchair.com/dumps/

https://gz.blockchair.com/bitcoin/

http://addresses.loyce.club/?C=M;O=D

http://loyceipv6.tk:20319/blockdata

## see also

loyceV address lists, which should be updated often (but his lists are not chronological):

List of all Bitcoin addresses ever used -- https://bitcointalk.org/index.php?topic=5265993.0

List of all Bitcoin addresses with a balance -- https://bitcointalk.org/index.php?topic=5254914.0

# bitcoin-all-addresses
uniq addresses from blockchair output dumps

method:

download all output dump files from blockchair;

uncompress files and cut the 7th field (recipient);

use perl and print addresses unless seen;

split in files of about 180MB;

7z files and hope they are below 100MB each to upload to github.

references:

https://blockchair.com/dumps/

https://gz.blockchair.com/bitcoin/

http://addresses.loyce.club/?C=M;O=D

https://bitcointalk.org/index.php?topic=5259621.0

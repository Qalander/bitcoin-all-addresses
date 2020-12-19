#!/bin/bash
#!/bin/zsh
# dec/2020  by mountaineerbr
# download blockchair output dump files systematically

#for some tasks like extracting lots of blockchain data (e.g. all
#transactions over a 2 month period) it's better to use our dumps
#feature instead of using our api or other services
#https://blockchair.com/dumps/
#https://gz.blockchair.com/bitcoin/
#http://addresses.loyce.club/?C=M;O=D
#https://bitcointalk.org/index.php?topic=5259621.0
#https://bitcointalk.org/index.php?topic=5246271.0
#https://bitcointalk.org/index.php?topic=5254914.0

#filename examples at the end of script

#directory that will hold downloaded files
#to download all files, requires ~100GB
DIR="${DIR:-/media/primary/blockchair.outputs.dumps}"
#DIR="$HOME/blockchair.outputs.dumps"
#DIR=

#file containing download target file names
FILELIST="$DIR/00.FILELIST.blockchair.txt"

#logs
LOG="$DIR/00.log.txt"
LOGERR="$DIR/00.log.err.txt"

#download urls
URL='https://gz.blockchair.com/bitcoin/outputs'

#lift the limits
#blockchair api key
#KEY=""

#script name
SN="${0##*/}"

#user agent
UAG='User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.106 Safari/537.36'

HELP="NAME
	$SN - download blockchair output dump files systematically


USAGE
	$SN [-2hr] [NUM]
	

	this script will download transaction output record files
	from <https://gz.blockchair.com/bitcoin/outputs>.

	you may set environment variable \$DIR to point to the
	download folder, else set \$DIR in the script head sorce
	code.
	
	the first time the script is executed, a list of files to
	download from the server is generated at \$DIR .
	downloaded files are minimally checked for actual data.
	failed downloads are skipped. run the script again to
	download skipped, failed or new files.

	to start reading from the nth line of the filelist, set a
	NUM integer as positional argumentthe. note that 0 and 1
	start reading from the first line.


RATE LIMITS
	an example of list with filenames to download is added to
	the end of this script. if you need, please create a filelist
	manually before running this script (if blockchair blocks you).
	the file holding the list with filenames to download must
	be named ${FILELIST##*/} .

	oficially, blockchair documentation says downloads are
	limited to 10KB/s.  if you have got an api key, download
	limits will be lifted.  probably, only one instance of this
	script can be run per IP address with these limits on;
	downloading everything may take some days to weeks.

	however, lately it seems the limit has been increased
	to 50-100KB/s.

	set blockchair api key (if you have got one!) to lift the
	downloding limits in the script head source code, or set
	environment variable \$KEY .


OBSERVATION
	to download all files, approximately 100 GB are required.
	download directory is set to ${DIR} .

	Requires GNU coreutils. Written with zsh but should work
	with bash, too.


SEE ALSO
	<https://bitcointalk.org/index.php?topic=5259621>
	<https://gz.blockchair.com/README.html>
	<https://blockchair.com/dumps>
	<http://addresses.loyce.club>


OPTIONS
	\$DIR 	Environment variable, sets download directory.
	-h 	Print this help.
	-r 	Reverse order of files for download."


#cleaning func
trapf()
{
	trap \  INT TERM
	
	#remove file on interruption
	[[ -f "$F" ]] && rm -v "$F"

	exit 1
}

#exec duration feedback
exitf()
{
	trap \  EXIT

	echo -e "\n>>>took $SECONDS seconds  ($(( SECONDS / 60 )) mins)" >&2
}


#parse options
while getopts dhr c
do
	case $c in
		d)
			#debug
			OPTDEBUG=1
			;;
		h)
			#help
			printf '%s\n' "$HELP"
			exit 0
			;;
		r)
			#reverse list order
			REV=-
			;;
		\?)
			exit 1
			;;
	esac
done
shift $(( OPTIND - 1 ))
unset c


#get rid of trailing forward slashes
DIR="${DIR%\/}"
URL="${URL%\/}"

#user arg $1
SKIP="$(( $1 ))" || exit 1
c=$SKIP

#reverse list?
if [[ -n "$REV" ]]
then
	reversef()
	{
		#skip latest n days
		tac | tail -n+"${SKIP:-1}"
	}
else
	reversef()
	{
		#skip latest n days..
		tail -n+"${SKIP:-1}"
	}
fi

#curl or wget?
if command -v curl &>/dev/null
then
	YOURAPP=( curl -Lb non-existing -H"$UAG" )
	OUTFLAG=-o
elif command -v wget &>/dev/null
then
	YOURAPP=( wget --header="$UAG" )
	OUTFLAG=-O
else
	echo "$SN: err -- curl or wget required" >&2
	exit 1
fi

#check if destination dir exists
[[ -d "$DIR" ]] || mkdir -pv "$DIR" || exit 1

#is there a list file already?
echo '>>>checking/generating a list of files to download..' >&2
if [[ -f "$FILELIST" ]]
then
	#load files from filelist
	FILES=( $( reversef < "$FILELIST" ) )
else
	#download and load filelist
	#make a new copy of it at result $DIR
	FILES=( $( "${YOURAPP[@]}" "$OUTFLAG" - "$URL" | sed 's/<[^>]*>//g' | grep -Eo 'blockchair_bitcoin_outputs[^ ]+' | tee "$FILELIST" | reversef ) )
	CURLEXIT="${PIPESTATUS[0]:-${pipestatus[1]}}"
fi

#check curl/wget status
if (( CURLEXIT ))
then
	echo "error: curl/wget" >&2
	exit $CURLEXIT
#files array empty?
elif [[ -z "${FILES[*]}" ]]
then
	mv -v "$FILELIST" "${FILELIST}.empty"
	echo "error: empty filelist" >&2
	exit 1
fi

#line count
WCL="$( wc -l < "$FILELIST" )"

#set api key parameter
if [[ -n "$KEY" ]] &&
	[[ "$URL" = *blockchair.com* ]]
then
	KEY="?$KEY"
else
	unset KEY
fi

#traps
trap trapf INT TERM
trap exitf EXIT

#download loop
for f in "${FILES[@]}"
do
	#filepath
	F="$DIR/$f"

	#counter
	if [[ -n "$REV" ]]
	then
		(( c = WCL - d ))
		(( ++d ))
	else
		(( ++c ))
	fi

	#file exists?
	if [[ -f "$F" ]]
	then
		#skip
		continue
	else
		#reserve file
		: > "$F"
	fi

	echo -e "\n>>>file $REV$c/$WCL: $f  "

	#try to download file
	if "${YOURAPP[@]}" "$OUTFLAG" "$F" "$URL/${f}${KEY}" &&
		[[ -s "$F" ]] &&
		! grep -Fi -e '<html>' -e '402 Payment Required' "$F" >&2
	then
		echo ">>>ok   $F  in $(( SECONDS - SECONDSX )) secs  $(( ( SECONDS - SECONDSX ) / 60 )) mins" | tee -a "$LOG" >&2
	else
		#remove file on curl/wget error
		{
			echo ">>>err  $F"
			rm -v "$F" 2>&1
		} | tee -a "$LOGERR" >&2
	fi

	SECONDSX=$SECONDS
done

#remove file list on success
if [[ -f "$FILELIST" ]]
then
	echo "warning: file list back up" >&2
	mv -v "$FILELIST" "${FILELIST}.old"
fi


exit
#START OF FILELIST EXAMPLE BELOW#
blockchair_bitcoin_outputs_20090103.tsv.gz
blockchair_bitcoin_outputs_20090109.tsv.gz
blockchair_bitcoin_outputs_20090110.tsv.gz
blockchair_bitcoin_outputs_20090111.tsv.gz
blockchair_bitcoin_outputs_20090112.tsv.gz
blockchair_bitcoin_outputs_20090113.tsv.gz
blockchair_bitcoin_outputs_20090114.tsv.gz
blockchair_bitcoin_outputs_20090115.tsv.gz
blockchair_bitcoin_outputs_20090116.tsv.gz
blockchair_bitcoin_outputs_20090117.tsv.gz
blockchair_bitcoin_outputs_20090118.tsv.gz
blockchair_bitcoin_outputs_20090119.tsv.gz

#printf '%s\n' blockchair_bitcoin_outputs_20{09..19}{01..12}{01..31}.tsv.gz 


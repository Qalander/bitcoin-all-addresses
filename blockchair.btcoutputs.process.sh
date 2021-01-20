#!/bin/zsh
# jan/2021  by mountaineerbr
# process blockchair dumps and grep bitcoin addresses
# these are just some tips, you should develop whole
# methodology yourself. change accordingly.


##functions

#cut address field from blockchair *.tsv.gz files
cutaddrf()
{
	local GZDIR ALLDIR FILES REPLY f n dest 
	typeset -a FILES
	
	#user set
	GZDIR="/media/primary/blockchair.outputs.dumps"
	ALLDIR="/media/primary/blockchair.outputs.dumps/step3"
	
	#sort blockchair dump files *.tsv.gz
	#by date and make a filename array
	#(eg blockchair_bitcoin_outputs_20090103.tsv.gz)
	while read
	do
		FILES+=( "$REPLY" )
	done <<<"$( printf '%s\n' "$GZDIR"/*.tsv.gz | sort -t_ -k4 -n )"
	
	#process each file
	#cut the address field (7th field) from blockchair *.tsv.gz files
	for f in "${FILES[@]}"
	do
		#destination file name
		dest="$ALLDIR/${f##*/}.addr.txt"
		
		#check if input exists
		[[ -e "$dest" ]] && continue
			
		if 
			#extract and cut only the address field
			gunzip -vc "$f" | cut -d$'\t' -f7 > "$dest"
			[[ "$pipestatus[*]" = *[1-9]* ]] 
		then
			#if pipe fails, remove bad file
			echo >&2
			rm -v "$dest" >&2
		fi
	done
}

#make a list of unique address from *.addr.txt files
uniqaddrf()
{
	local FILES ALLDIR OUTDIR TMPDIR REPLY
	typeset -a FILES
	
	#user set
	ALLDIR="/media/primary/blockchair.outputs.dumps/step3"
	OUTDIR="/media/primary/blockchair.outputs.dumps/test5"
	#set a large temp dir for `sort`
	TMPDIR="/media/primary/tmp"

	#make gnu tools work faster, for our case, this should be OK
	export TMPDIR
	export LC_ALL=C LANG=C

	#sort *.addr.txt files
	#by date and make a filename array
	#(eg blockchair_bitcoin_outputs_20090103.tsv.gz.addr.txt)
	while read
	do
		FILES+=( "$REPLY" )
	done <<<"$( printf '%s\n' "$ALLDIR"/*.addr.txt | sort -t_ -k4 -n )"

	#processing pipeline
	#also consider setting sort option --parallel=N
	cat -n "${FILES[@]}" | 	#concatenate and add line numbers
		sort -k2 -u | 	#sort by the second field (address) and output only unique entries
		sort -n | 	#sort by the first field (line number)
		cut -f2 > "$OUTDIR/final.txt"  #cut the second field only (address)
}
#the first sort took ~3h20min to complete on my intel i7 and usb hdd
#the second sort took ~2h to complete

#get some address stats
countaddrf()
{
	local LIST ALLDIR all uni a1 a3 bc nn

	LIST="/media/primary/blockchair.outputs.dumps/test5/final.txt"
	ALLDIR="/media/primary/blockchair.outputs.dumps/step3"

	#counts
	all="$( for f in "$ALLDIR"/*.addr.txt ;do wc=$(( wc + $(wc -l <"$f") - 1 )) ;done ;print $wc )"
	print all: $all
	uni="$(( $(wc -l <"$LIST") - 1 ))"
	print unique: $uni
	a1="$( grep  -c '^1' "$LIST" )"
	print 1\*: $a1
	a3="$( grep  -c '^3' "$LIST" )"
	print 3\*: $a3
	bc="$( grep  -c '^bc1' "$LIST" )"
	print bc1\*: $bc
	nn="$( grep -Fc '-' "$LIST" )"
	print \*-\*: $nn

	#check
	print "check: $((a1+a3+bc+nn)) must be equal to $uni"
}
#OBS: text cut from `blockchair_bitcoin_outputs_20201205.tsv.gz` seems
#to contain a last empty line.
#these take about 27min to run

#split list to upload to github
#{ split -C 94000000 final.txt ;}


##run

#cutaddrf &&
#uniqaddrf

#countaddrf


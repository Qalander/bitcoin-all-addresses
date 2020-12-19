#!/bin/zsh
#!/bin/bash
# grep bitcoin addresses from blockchair dumps

#user set
INDIR="/media/primary/blockchair.outputs.dumps"
OUTDIR="$PWD"
#OUTDIR="/media/primary/blockchair.outputs.dumps/addr"

#zsh shell option
#setopt extendedglob

#list blockchair dump files *.tsv.gz
#after sorting dates correctly
while read
do
	FILES+=( "$REPLY" )
done <<<"$( printf '%s\n' "$INDIR"/*.tsv.gz | sort -t_ -k4 -n )"

#process each file asynchronously
for f in "${FILES[@]}"
do
	#counter
	(( ++n ))
	
	#destination file name
	dest="$OUTDIR/${f##*/}.addr.txt"
	
	#feedback to stderr
	printf ">>>%s/%s: %s  \r" "$n" "${#FILES[@]}" "${f##*/}" >&2

	#check if input exists
	if [[ -e "$dest" ]]
	then
		continue
	else
		#or lock file on disc 
		: >"$dest"
	fi
	
	#extract and cur only address field
	if ! gunzip -c "$f" | cut -d$'\t' -f7 > "$dest"
	then
		echo >&2
		rm -v "$dest" >&2
	fi
done

wait
echo >&2


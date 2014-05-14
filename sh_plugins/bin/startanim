i=`wc -l ~/.startanim | cut -f7 -d' '`
count=1
while [ $i -ne $count ]
do
	clear
	echo "`tail -n $count ~/.startanim`"
	usleep 20000
	(( count++ ))
done
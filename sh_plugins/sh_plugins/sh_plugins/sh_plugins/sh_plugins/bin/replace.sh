#!/bin/sh
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    replace.sh                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tseguier <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2014/11/01 14:51:04 by tseguier          #+#    #+#              #
#    Updated: 2014/11/01 14:51:04 by tseguier         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

if [ $# -lt 2 ]
then
	echo "usage : replace tofind newstr [findflags] [replace in filename]"
	exit ;
fi
find="find . -type f"
if [ $# -gt 2 ]
then
	find=$find" -and $3"
fi
echo $find
find=`sh -c "$find"`
for i in $( echo $find )
do
	if [ $# -lt 4 ]
	then
		echo $i
		echo sed -e "s/$1/$2/g"
		sed -e "s/$1/$2/g"  $i > $i.bak && cat -e $i.bak && mv -f $i.bak $i
	else
		out=`echo $i | sed -e "s/$1/$2/g"`
		echo "$i > $out"
		sed -e "s/$1/$2/g"  $i > $out && rm -f $i
	fi
done


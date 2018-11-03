#!/bin/sh
#total run time: 1m56s
#system macOS 10.13 2*e5462@2.8Ghz 10G RAM
#-----------------------------------------get the file name------------------------------------
declare -a bout=()
declare -a hout=()
for (( i = 1; i < 10; i++ )); do
	for files in ~/project2/data/opt/* ~/project2/data/heu/*; do
		if [ "$files" == ~/project2/data/opt/bout$i ]; then
			bout[$i]=$files 
		elif [ "$files" == ~/project2/data/heu/hout$i ]; then
			hout[$i]=$files
		fi

	done
done

#2d array 
declare -a bkase=(0)
declare -a bvalue=(0)
declare -a hvalue=(0)
declare -a hkase=(0)
bsize=0
hsize=0
printf "">summary
printf "">p2.dat
#-------------------------------load file content into data structure for opt case---------------------------
j=1
for (( j = 1; j < 10; j++ )); do
	count=1
	k=1
	echo "Scenario $j" >>summary
	while IFS= read -r line
	do
    	if [[ "$k" -eq 1 ]]; then
			bkase[$count]=$line
		elif [[ "$k" -eq 2 ]]; then
			bvalue[$count]=$line
		elif [[ "$k" -eq 3 ]]; then
			#donothing
			k=0
       		 count=$((count+1))
		fi
		k=$((k+1))
	done <${bout[$j]}
	bsize=$((count-1))
	#-----------------------------load file content into data structure for heu case-------------------
	count=1
	k=1
	while IFS= read -r line
	do
    	if [[ "$k" -eq 1 ]]; then
			hkase[$count]=$line
		elif [[ "$k" -eq 2 ]]; then
			hvalue[$count]=$line
		elif [[ "$k" -eq 3 ]]; then
			#donothing
			k=0
        	count=$((count+1))
		fi
		k=$((k+1))
	done <${hout[$j]}
	hsize=$((count-1))

	#----------------------------------------------------------------------------------------------
	counter=0
	dif=0
	suum=0
	min=10
	max=0
	#2 loop to check the same if the name match
	for (( a = 1; a < $bsize+1; a++ )); do
		for (( b = 1; b < $hsize+1; b++ )); do	
			#find equal
			if [[ ${bkase[$a]} == ${hkase[$b]} ]]; then
				dif=$(echo "${hvalue[$b]}-${bvalue[$a]}"|bc)
				if [[ 1 -eq "$(echo "${dif} > ${max}" | bc)"  ]]; then
					max=$dif
				fi
				if [[ 1 -eq "$(echo "${dif} < ${min}" | bc)" ]]; then
					min=$dif
				fi	
				suum=$(echo "$suum+$dif"|bc)
				counter=$((counter+1))
			fi
		done
	done
	if [[ $counter -eq 0 ]]; then
		printf "$j ">>p2.dat
		echo "The average for scenario $j is: 0">>summary
		printf "0 ">>p2.dat
		max=0
		min=0
	else
		printf "$j ">>p2.dat
		echo "The average for scenario $j is: $(bc -l <<< "$suum/$counter")">>summary
		printf "$(bc -l <<< "$suum/$counter") ">>p2.dat
		#echo $counter
	fi
	echo "The maximum for scenario $j is: $max" >>summary
	printf "$max ">>p2.dat
	echo "The minimum for scenario $j is: $min \n" >>summary
	printf -- "$min \n">>p2.dat
	dif=0
	counter=0
	suum=0
done
#------------------------------------------------plot--------------------------------------------
gnuplot <<__EOF
set term png
set output "output.png"
set autoscale
set xrange [1:9]
set xtics 1,1,9
set key outside
set grid
set ylabel "benchmark"
set xlabel "scenario"
plot 'p2.dat' using 1:2 title "mean diff" with linespoints, '' using 1:3 title "max diff" with linespoints, '' using 1:4 title "min diff" with linespoints
__EOF



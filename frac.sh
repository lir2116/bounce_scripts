#!/usr/bin/env bash

# LIR script to cycle through different total energies and fractions of v_parallel and v_perpendicular (vx, vy)

echo "
BEFORE YOU RUN: 
- create folder ./output/your_eqdsk_name
- manually input geqdsk and starting position in basic.cpp
- make sure the last line of your frac.txt file is 0

Inputs (Prompted): 

eq (geqdsk) 
     - used to locate output folder

ener (eV) 
     - starting energy of particle in eV

estep (eV) 
     - energy increment in eV (ie. if you input ener = 100, estep = 50 it will run 100 eV, 150 eV, 200 eV)

max_ener (eV) 
     - maximum energy of particle in eV

iter (number) 
     - [number of lines in frac.txt] - 1

folder (folder name) 
     - what you want your output folder to be named for this scan
"


echo -n "equilibrium file name?"
read -r eq

echo -n "starting energy (eV)?"
read -r ener

echo -n "energy increment (eV)?"
read -r estep

echo -n "ending energy (eV)?"
read -r max_ener

#echo -n "starting position (x,y,z)?"
#read -r pos

# note: iterations is no. of times this code runs, not maxiter in basic.cpp
echo -n "iterations?"
read -r iter

echo -n "output (position) folder name?"
read -r folder

# input file currently containing (vx, vy, vz) list
file='frac.txt'

# variables:
# i = line number
# j = original equilibrium in basic.cpp
# k = original energy value in basic.cpp
# l = original starting position in basic.cpp
# m = original energy distribtion in basic.cpp

# distr = energy distribution on previous line (used for find-and-replace)

i=1
j=g200006.01000
k=4000
l=(1.8,0,0.3)
m=1

# make output folder
mkdir ./output/$eq/$folder

while [ $((ener)) -le $((max_ener)) ]; do
    i=1

    while read line; do

	if [ $((i)) -eq 1 ]; then

	    # replace existing values with first set
	    sed -i -e 's/'"nstu = $j"'/'"nstu = $eq"'/g' src/basic.cpp
	    sed -i -e 's/'"double energy = $k"'/'"double energy = $ener"'/g' src/basic.cpp
	    #sed -i -e 's/'"Vector pos$l"'/'"Vector pos$pos"'/g' src/basic.cpp
	    sed -i -e 's/'"vty = $m"'/'"vty = $line"'/g' src/basic.cpp
	    
	    # make and run basic with new values
	    make
	    ./basic
	    
	    # move outputs to folder
	    cd output
	    mv example_coords_RZ.txt $eq/$folder/example_coords_RZ_$((i))_$ener.txt
	    mv example_coords.txt $eq/$folder/example_coords_$((i))_$ener.txt
	    mv example_energy.txt $eq/$folder/example_energy_$((i))_$ener.txt
	    mv example_time.txt $eq/$folder/example_time_$((i))_$ener.txt

	    # back to the Bounce directory
	    cd ..

	    # save value of current line for next find-and-replace
	    distr=$line

	    # update i
	    i=$((i+1))

	elif [ $((i)) -lt $((iter)) ]; then

	    # find and replace, again
	    sed -i -e 's/'"vty = $distr"'/'"vty = $line"'/g' src/basic.cpp

	    # make and run basic with new values
	    make
	    ./basic

	    # move and rename output files

	    cd output

	    mv example_coords_RZ.txt $eq/$folder/example_coords_RZ_$((i))_$ener.txt
	    mv example_coords.txt $eq/$folder/example_coords_$((i))_$ener.txt
	    mv example_energy.txt $eq/$folder/example_energy_$((i))_$ener.txt
	    mv example_time.txt $eq/$folder/example_time_$((i))_$ener.txt

	    # back to the Bounce directory
	    cd ..

	    # save value of current line for next find-and-replace
	    distr=$line

	    # update i
	    i=$((i+1))

	else 
	    
	    # find and replace, again
	    sed -i -e 's/'"vty = $distr"'/'"vty = $line"'/g' src/basic.cpp

	    # make and run basic with new values
	    make
	    ./basic

	    # move and rename output files

	    cd output

	    mv example_coords_RZ.txt $eq/$folder/example_coords_RZ_$((i))_$ener.txt
	    mv example_coords.txt $eq/$folder/example_coords_$((i))_$ener.txt
	    mv example_energy.txt $eq/$folder/example_energy_$((i))_$ener.txt
	    mv example_time.txt $eq/$folder/example_time_$((i))_$ener.txt

	    # back to the Bounce directory
	    cd ..

	    # replace values back to original 
	    	
	    sed -i -e 's/'"nstu = $eq"'/'"nstu = $j"'/g' src/basic.cpp
	    sed -i -e 's/'"energy = $ener"'/'"energy = $k"'/g' src/basic.cpp
	    #sed -i -e 's/'"Vector pos$pos"'/'"Vector pos$l"'/g' src/basic.cpp
	    sed -i -e 's/'"vty = $line"'/'"vty = $m"'/g' src/basic.cpp
	    
	fi
	
    done < $file
    # update energy
    ener=$((ener+estep))

done

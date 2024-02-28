LIR README file for bounce_scripts directory

Files: 

frac.txt
   - input file of energy distributions used by frac.sh

frac.sh 
   - file to run bounce with different energies and energy distributions

parser.py 
   - file to determine whether particles are lost, passing, or bouncing

x_pt_sorter.zip
   - file to: 
	(1) run the parser file
	(2) sort into good/bad curvature bounces, lost to limiter and lost to x point
	(3) generate plot of E_parallel vs E_perpendicular, color-coded by good/bad curvature bounces or passing
	(4) plot good-curvature trapped fractions for different equilibria
	(5) plot E_parallel, E_perpendicular and whether or not the particle is lost to the x-point
	(6) find the R, Z coordinates of a given flux surface of a given equilibrium
	(7) create an OMFIT tree for a given equilibrium (used when loading a new equilibrium)
	

Instructions: 
1. Move all the files in this folder to your Bounce folder
2. Edit frac.txt to contain the E_parallel fractions you would like to run Bounce with. MAKE SURE THE LAST LINE IS 0!
3. Change the equilibrium name and starting position in basic.cpp
4. Create a folder labeled with the name of your equilibrium in the outputs folder
5. Load the necessary modules IN THIS ORDER:

$ module load python/3 gnuplot/4.6.7 
$ module purge gcc-4.9.2
$ module load gcc-11.2.0

6. Run frac.sh, follow the prompts
7. Open OMFIT and load x_pt_sorter.zip
8. Create a tree with the name of your equilibrium, then add the geqdsk file to the tree
9. Manually edit the equilibrium name, ending list and energy list (if necessary) in parser.py. The ending list corresponds to the endings of files in the output/your_eq_name folder
10. Run the parser file in OMFIT
11. Change the eq eq_name values (at the top) and filename, passing_file, and E_file values as needed in the rest of the files and run as-needed

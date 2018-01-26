# 2d_csd_visualizer
MatLab GUI for 2D Cortical Spreading Simulation Visualizing


This GUI partners with https://github.com/ADTuttle/2d_CSD. And is meant to provide an easy way to visualize the output of the different concentrations, voltages, and volume fractions involved.


### File Format
The files are formatted with the initial information on line one. It follows the following:
Number x coords, Number of y coords, Number of recorded time steps, Number of compartments, Number of ions.

It prints the following loop:

Each time step

  Concentrations of each ion
  
      in each compartment
      
        For each y coordinate
        
            The concentration of each x coordinate in a comma seperated row.
            
             New line for y.
             
  Voltage in each compartment
  
        For each y coordinate
        
            The concentration of each x coordinate in a comma seperated row.
            
            New line for y.
            
  Volume frac in each compartment (excluding extracellular)
  
     For each y coordinate
     
         The concentration of each x coordinate in a comma seperated row.
         
          New line for y.
          
          
Repeat for each time step the above.

/*
list-plot.scad
library defining functions for plotting lists of points.

future work - create a listplot function for points in 2D (x,y) since some openSCAD primitives only work with 2D coordinates.

*/

// plot a set of 3D points using cubes of adustable sidelength
module list_plot3D(points,cube_size=0.01){
    for(i = [0:1:len(points)-1]) {translate(points[i]) cube(cube_size);}
}
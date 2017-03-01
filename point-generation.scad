/* 
Point-generation.scad
library for generating points lying on a surface either in regular grids or in a pseudo-random configuration.
 */

include <xyz-sphere-transform.scad>;
include <list-plot.scad>;

// random_sphere_point() generates a pseudo-random point lying on a sphere of non-random radius "r"
function random_sphere_point(r=1) = xyz_from_sphere_degrees(r,theta=rands(0,180,1)[0],phi=rands(0,360,1)[0]);

// randomSpherePoints() generates "n" pseudo-random points lying on a sphere of "r" radius
function random_sphere_points(n=1, r=1) = [for(i=[1:1:n]) random_sphere_point(r)];

// canonical_order_faces() generates a set of vectors defining triangular faces from a set of 3D points that is based on the canonical order of those points. Not currently useful, just a test of creating polyhedron faces from sample data in a generative fashion.
function canonical_order_faces(points) = [for(i = [0:1:len(points)-2]) [i, i+1, i+2]];

// example code - generate 1000 points on a sphere of radius 5. generate triangular connected polyhedron faces from the canonical order of these points.

// samplePoints = random_sphere_points(n=9999, r=5);
// list_plot3D(samplePoints, cube_size=0.05);
//polyhedron(points = samplePoints, faces = canonical_order_faces(samplePoints));


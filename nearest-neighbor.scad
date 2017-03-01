/*
nearest-neighbor.scad
Defines functions related to a nearest-neighbor-search algorithm for finding points that are closest each other in a given space.

Should be useful for generatively defining in a set of points which elements form polyhedral faces on a smooth, well defined 3D surface even if the spacing of the points is not regular.

https://en.wikipedia.org/wiki/Nearest_neighbor_search

NNS can be done in n-dimensions. In the case of a set of 3D points, the problem is simpler since we only have 3 dimensions in a metric space, and therefore can use distance in the traditional sense as the "closeness" test.

The naive approach would be to compute the distance of every point in the set "S" relative to the query point "q", however the computation time can be reduced if you structure the data so as to re-use previously calculated results.


Fixed-radius NNS
https://en.wikipedia.org/wiki/Fixed-radius_near_neighbors
One approach that reduces computation time is the special case of the NNS with a defined maximum radius "delta".
A grid is constructed in cartesian space with unit cubes of sidelength delta, and each point in the set "S" is categorized according to which unit cube it exists in within this grid.

This reduces the search time since finding the nearest "k"-neighbors of the query point "q" means only having to check the unit cube it exists in, and the adjoining unit cubes, and then computing the norm between "q" and the neighbors within those cubes.

*/

include <xyz-sphere-transform.scad>;
include <list-plot.scad>;
include <point-generation.scad>;

// distance_3D(a,b) calculates the absolute distance between the two 3D points "a" and "b"
function distance3D(a,b) = norm(a-b);

// point_set_distances3D(point_set) is a naive calculation of distances between points. 
// This approach does not attempt to prevent calculating the distance between a point and itself. 
// It also doesn't reduce the set to a minimal size by not re-calculating a given result - e.g. distance3D(a, b) and distance3D(b,a) which are equivalent.
// For a set of 3 points, an efficient algorithm would only produce a set of results with three vectors, whereas this one produces nine.
function point_set_distances3D(point_set) = [for(i=[0:1:len(point_set)-1], j=[0:1:len(point_set)-1]) [i, j, distance3D(point_set[i],point_set[j])]];

// test code
samplePoints = random_sphere_points(n=30,r=2.5);
list_plot3D(samplePoints, cube_size=0.05);

dist = point_set_distances3D(samplePoints);
//echo(dist);


// let's visually create the delta-unit grid with transparent cubes so that it is easy to check if grouping is working correctly.

delta=1;

// construct a grid of cubes of with sidelength delta that contains all points generated in samplePoints. For a sphere of sufficient radius and small enough delta, this would mean a lot of cubes in the center would be empty of points. May want to see if it's possible to exclude generation of cubes in the grid that are known to be empty, and optimize the search algorithm to only look at occupied cubes.
// for now, let's use a naive algorithm that just checks for the maximum dimension in any x,y,z coordinate over the set of samplePoints and use a grid over the cubic space of that.


samplePoints_norm = [for(i=[0:1:len(samplePoints)-1]) norm(samplePoints[i])];
max_norm = max(samplePoints_norm);
num_container_boxes = ceil(max_norm/delta);

function box_centers(delta) = [for(i=[-num_container_boxes:delta:num_container_boxes], j=[-num_container_boxes:delta:num_container_boxes], k=[-num_container_boxes:delta:num_container_boxes] ) [i, j, k]];

boxes = box_centers(delta);

module transparent_cube_grid(delta){
    for(i=[0:1:len(boxes)-1]) translate(boxes[i])%cube(delta,center=true);
}


echo(samplePoints);
echo(num_container_boxes);
echo(len(boxes));
transparent_cube_grid(delta);


//function fixed_radius_grid(point_set, delta) =  





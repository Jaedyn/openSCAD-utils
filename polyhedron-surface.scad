// plot a set of 3D points using cubes of adustable sidelength
module list_plot(points,cube_size=0.01){
    for(i = [0:1:len(points)-1]) {translate(points[i]) cube(cube_size);}
}

// reverse the canonical order of elements in a vector
function reverse_order(vector) = [for(i=[0:1:len(vector)-1]) vector[len(vector)-i-1]];

// Pi defined to a few more digits of precision than what OpenSCAD does natively as the specially defined variable PI.
// PI() is a function rather than a constant since I may substitute the hard constant with an actual algorithm to calculate PI to n-digits of precision later.
function PI() = 3.141592653589793;

// conversion functions for radians & degrees since I may need to do math in radians later
function degrees_to_radians(degrees=0) = (degrees/360)*2*PI();
function radians_to_degrees(radians=0) = (radians/(2*PI()))*360;

// Spherical (r,theta,phi) to Cartesian (x,y,z) coordinate transformation
// source: Mathematical Methods for Scientists and Engineers - Donald A. McQuarrie

// x = r*cos(phi)*sin(theta)     
// y = r*sin(phi)*sin(theta)     
// z = r*cos(theta)              
//
// 0 <= r     <   infinity
// 0 <= theta <=  Pi (180 degrees)
// 0 <= phi   <=  2*Pi (360 degrees)

// *_sphere_degrees functions take angle arguments in degrees
function x_sphere_degrees(r=1,theta=0,phi=0) = r*cos(phi)*sin(theta); 
function y_sphere_degrees(r=1,theta=0,phi=0) = r*sin(phi)*sin(theta); 
function z_sphere_degrees(r=1,theta=0) = r*cos(theta);
function xyz_from_sphere(r=1,theta=0,phi=0) = [x_sphere_degrees(r,theta,phi), y_sphere_degrees(r,theta,phi), z_sphere_degrees(r,theta)];

// *_sphere_radians functions take angle arguments in radians and convert to degrees - since OpenSCAD's trig functions only take angle arguments as degrees
function x_sphere_radians(r=1,theta=0,phi=0) = x_sphere_degrees(r,radians_to_degrees(theta),radians_to_degrees(phi));
function y_sphere_radians(r=1,theta=0,phi=0) = y_sphere_degrees(r,radians_to_degrees(theta),radians_to_degrees(phi));
function z_sphere_radians(r=1,theta=0) = z_sphere_degrees(r,radians_to_degrees(theta));

// random_sphere_point() generates a pseudo-random point lying on a sphere of non-random radius "r"
function random_sphere_point(r=1) = xyz_from_sphere(r,theta=rands(0,180,1)[0],phi=rands(0,360,1)[0]);

// randomSpherePoints() generates "n" pseudo-random points lying on a sphere of "r" radius
function randomSpherePoints(n=1, r=1) = [for(i=[1:1:n]) random_sphere_point(r)];

// canonical_order_faces() generates a set of vectors defining triangular faces from a set of 3D points that is based on the canonical order of those points
function canonical_order_faces(points) = [for(i = [0:1:len(points)-2]) [i, i+1, i+2]];

randpoints = randomSpherePoints(9999);
list_plot(randpoints,0.01);
//polyhedron(points = randpoints, faces = canonical_order_faces(randpoints));



// time to figure out if I can generate face-vector sets according to a nearest-neighbor-search (NNS) algorithm.
// this type of problem can be solved in linear time for a constant set of dimensions. Search time grows exponentially with increasing dimensions.

//------------------------------------------------------------------------------------------
// Test code for creating an evenly spaced set of points in a spherical coordinate system. 
//
//theta_range = [0,1,30];
//phi_range = [0,3,90];
//
//theta_index = [for(i = [theta_range[0]:theta_range[1]:theta_range[2]]) i];
//phi_index = [for(i = [phi_range[0]:phi_range[1]:phi_range[2]]) i];
//
//surfacePoints = [for(theta = theta_index, phi=phi_index) [x_sphere_degrees(1,theta,phi),y_sphere_degrees(1,theta,phi),z_sphere_degrees(1,theta)]];
//
//slice1 = [for(i = [0:len(theta_index):len(theta_index)*len(phi_index)]) surfacePoints[i]];
//slice2 = reverse_order([for(i = [0:len(theta_index):len(theta_index)*len(phi_index)]) surfacePoints[i+1]]);
//
// Lots of random points on a sphere (just a test of the function)
//for(i = [1:1:5000]) {translate(random_sphere_point(r=1)) cube(0.001);}
//
// Plot of surface points that were evenly generated over a sphere using the theta, phi indices
//color("green")
//for(i = [0:1:len(surfacePoints)-1]) {translate(surfacePoints[i]) cube(0.001);}
//
//color("green")
//list_plot(slice1,0.01);
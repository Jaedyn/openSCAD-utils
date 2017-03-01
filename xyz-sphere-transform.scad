/*
xyz-sphere-transform.scad
library defining functions for coordinate transformations from spherical (r, theta, phi) to cartesian (x,y,z)
*/

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
function xyz_from_sphere_degrees(r=1,theta=0,phi=0) = [x_sphere_degrees(r,theta,phi), y_sphere_degrees(r,theta,phi), z_sphere_degrees(r,theta)];

// *_sphere_radians functions take angle arguments in radians and convert to degrees - since OpenSCAD's trig functions only take angle arguments as degrees
function x_sphere_radians(r=1,theta=0,phi=0) = x_sphere_degrees(r,radians_to_degrees(theta),radians_to_degrees(phi));
function y_sphere_radians(r=1,theta=0,phi=0) = y_sphere_degrees(r,radians_to_degrees(theta),radians_to_degrees(phi));
function z_sphere_radians(r=1,theta=0) = z_sphere_degrees(r,radians_to_degrees(theta));
function xyz_from_sphere_radians(r=1,theta=0,phi=0) = [x_sphere_radians(r,theta,phi), y_sphere_radians(r,theta,phi), z_sphere_radians(r,theta)];

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
// Plot of surface points that were evenly generated over a sphere using the theta, phi indices
//color("green")
//for(i = [0:1:len(surfacePoints)-1]) {translate(surfacePoints[i]) cube(0.001);}
//
//color("green")
//list_plot3D(slice1,0.01);
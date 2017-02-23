function PI() = 3.141592653589793;
function degrees_to_radians(degrees=0) = (degrees/360)*2*PI();
function radians_to_degrees(radians=0) = (radians/(2*PI()))*360;

// Spherical (r,theta,phi) to Cartesian (x,y,z) coordinate transformation
// source: Mathematical Methods for Scientists and Engineers - Donald A. McQuarrie

// x = r*cos(phi)*sin(theta)     0 <= r     <   infinity
// y = r*sin(phi)*sin(theta)     0 <= theta <=  Pi
// z = r*cos(theta)              0 <= phi   <=  2*Pi

// *_sphere_degrees functions take angle arguments in degrees
function x_sphere_degrees(r=1,theta=0,phi=0) = r*cos(phi)*sin(theta); 
function y_sphere_degrees(r=1,theta=0,phi=0) = r*sin(phi)*sin(theta); 
function z_sphere_degrees(r=1,theta=0) = r*cos(theta);

// *_sphere_radians functions take angle arguments in radians and convert to degrees - since OpenSCAD's trig functions only take angle arguments as degrees.
function x_sphere_radians(r=1,theta=0,phi=0) = x_sphere_degrees(r,radians_to_degrees(theta),radians_to_degrees(phi));
function y_sphere_radians(r=1,theta=0,phi=0) = y_sphere_degrees(r,radians_to_degrees(theta),radians_to_degrees(phi));
function z_sphere_radians(r=1,theta=0) = z_sphere_degrees(r,radians_to_degrees(theta));




//general surface for constructing a polyhedron from a parametrically defined 3D surface that may or may not be closed.
module polysurface(){

}

//test case surface function for a sphere - generates a list of points on the surface.



//need to also write a module that creates a valid path list of triangle faces connecting the surface points in order for the polyhedron function to work.
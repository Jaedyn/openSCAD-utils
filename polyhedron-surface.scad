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


// testing coordinate transformation by generating a list of points along a spherical surface and then plotting cubes at those points.
// note: OpenSCAD doesn't like trying to render too many elements using a single list of points. Successful renders were achieved with a list of up to 9,800 points in a single list
// Splitting your list into two separate lists, and then two for() loops that plot the cubes doesn't result in an error for a test case that generates ~18,000 points split across two ~9,000 point lists.

surfacePoints = [for(theta = [0:4.5:360], phi = [0:3:360]) [x_sphere_degrees(1,theta,phi),y_sphere_degrees(1,theta,phi),z_sphere_degrees(1,theta)]];
surfacePoints2 = [for(theta = [0:6:360], phi = [0:3.1:360]) [x_sphere_degrees(1,theta,phi),y_sphere_degrees(1,theta,phi),z_sphere_degrees(1,theta)]];
color("blue")
for(i = [0:1:len(surfacePoints)-1]) {translate(surfacePoints[i]) cube(0.01);}
color("green")
for(i = [0:1:len(surfacePoints2)-1]) {translate(surfacePoints2[i]) cube(0.01);}

//general surface for constructing a polyhedron from a parametrically defined 3D surface that may or may not be closed.
module polysurface(){

}

//test case surface function for a sphere - generates a list of points on the surface.



//need to also write a module that creates a valid path list of triangle faces connecting the surface points in order for the polyhedron function to work.
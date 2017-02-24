function PI() = 3.141592653589793;
function degrees_to_radians(degrees=0) = (degrees/360)*2*PI();
function radians_to_degrees(radians=0) = (radians/(2*PI()))*360;
function reverse_order(vector) = [for(i=[0:1:len(vector)-1]) vector[len(vector)-i-1]];

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

// *_sphere_radians functions take angle arguments in radians and convert to degrees - since OpenSCAD's trig functions only take angle arguments as degrees.
function x_sphere_radians(r=1,theta=0,phi=0) = x_sphere_degrees(r,radians_to_degrees(theta),radians_to_degrees(phi));
function y_sphere_radians(r=1,theta=0,phi=0) = y_sphere_degrees(r,radians_to_degrees(theta),radians_to_degrees(phi));
function z_sphere_radians(r=1,theta=0) = z_sphere_degrees(r,radians_to_degrees(theta));

// function for generationg a random point on a sphere of defined radius (default r=1)
function random_sphere_point(r=1) = xyz_from_sphere(r,theta=rands(0,180,1)[0],phi=rands(0,360,1)[0]);
function canonical_order_faces(points) = [for(i = [0:1:len(points)-2]) [i, i+1, i+2]];

// plot a set of points using cubes of adustable sidelength
module list_plot(points,cube_size=0.01){
    for(i = [0:1:len(points)-1]) {translate(points[i]) cube(cube_size);}
}

// testing coordinate transformation by generating a list of points along a spherical surface and then plotting cubes at those points.
// note: OpenSCAD doesn't like trying to render too many elements using a single list of points. Successful renders were achieved with a list of up to 9,800 points in a single list. I haven't figured out the exact limit that causes OpenSCAD to throw an error, but it appears to be for any list > 10,000 elements (exactly 10,000 elements is ok)
// Splitting your list into two separate lists, and then two for() loops that plot the cubes doesn't result in an error for a test case that generates ~18,000 points split across two ~9,000 point lists.

theta_range = [0,1,30];
phi_range = [0,3,90];

theta_index = [for(i = [theta_range[0]:theta_range[1]:theta_range[2]]) i];
phi_index = [for(i = [phi_range[0]:phi_range[1]:phi_range[2]]) i];

surfacePoints = [for(theta = theta_index, phi=phi_index) [x_sphere_degrees(1,theta,phi),y_sphere_degrees(1,theta,phi),z_sphere_degrees(1,theta)]];

slice1 = [for(i = [0:len(theta_index):len(theta_index)*len(phi_index)]) surfacePoints[i]];
//slice2 = reverse_order([for(i = [0:len(theta_index):len(theta_index)*len(phi_index)]) surfacePoints[i+1]]);

// Lots of random points on a sphere (just a test of the function)
//for(i = [1:1:5000]) {translate(random_sphere_point(r=1)) cube(0.001);}

// Plot of surface points that were evenly generated over a sphere using the theta, phi indices
//color("green")
//for(i = [0:1:len(surfacePoints)-1]) {translate(surfacePoints[i]) cube(0.001);}

function randomSpherePoints(n) = [for(i=[1:1:n]) random_sphere_point()];

randpoints = randomSpherePoints(1000);

list_plot(randpoints,0.01);
polyhedron(points = randpoints, faces = canonical_order_faces(randpoints));

color("green")
list_plot(slice1,0.01);

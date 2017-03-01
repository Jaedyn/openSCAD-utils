/* bolt-nut.scad
Library for creating  and bolt (external) nut (internal) threads that smoothly fit each other when using the same thread parameters for both - no adjustments or scaling necessary when 3D printed to account for dimensional accuracy of the printer.

This was inspired by a simple "naive" model I made initially for creating nuts and bolts that linearly extrudes an ellipse through a full revolution. Internal threads (nut) are made by differencing a bolt of the same threading parameters (no adjustments) to create a void for the bolt to be inserted. However, the naive model creates a nut and bolt that will not quite fit together unless you take a dremel to them, so I added some features to make them fit together right off the printer:

1. External threads (bolt) have a thread_shave parameter that flattens the outer edge of the threads. This is imitates how an ISO spec bolt would be shaped in order to minimize surface contact friction as it slides into the internal threads of a nut with curved threads.
    See: https://en.wikipedia.org/wiki/ISO_metric_screw_thread for a diagram.
    I have not attempted to match any other feature of the ISO spec for screw threads, I'm just imitating this one feature of the design that makes the nut and bolt slide together more smoothly.

2. The insertion side of the bolt and the nut are tapered.
    For the nut, this is accomplished by subtraction of a solid cone that is slightly inset to the insertion side
    For the bolt, a cylinder with an inner conical surface is intersected with the end of the threads and differenced.

With these modifications to the ellipse extrusion, the nut and bolt will fit together right off the printer with no modification - as long as you don't try printing something too small to the point that surface features get too rough or small for the 3D printer to accurately print them. I have confirmed that the default values of the bolt() and nut() will print a bolt and nut that fit together using the printer I have available.

Test printer: Monoprice Select Mini 3D Printer with Heated Build Plate - 115365. 
Nominal resolution is 400 microns with 1.75 mm PLA filament. 
Control software is CUDA 15.x, and the model was printed with brim supports to prevent the bolt from slipping on the platform while being printed.

$fn = 100 results in F6 CGAL render times of up to 15-30 minutes for the default bolt() and nut() models.
$fn = 20 is generally good enough for faster model tweaking before doing a final render.

*/

$fn=20;

// cone modules for tapering the threads
//---------------------------------------
// constructs a cylinder with a cone subtracted

module taper_cone_bolt(radius=5, angle=60){
    height = radius * tan(angle);               // note that height approaches infinity as angle approaches 90. putting in 90 will create a nonsensical result, 89 works fine though.
    difference(){
        cylinder(h=height, r=radius);           // cylinder that matches the maximum outer radius of the threads
        cylinder(h=height,r1=radius,r2=0);      // subtracted cone
    }
}

// constructs a cone that comes to a point at the bottom
module taper_cone_nut(radius=5, angle=60){
    height = radius * tan(angle);               
    cylinder(h=height, r1=0,r2=radius);         
}

// bolt & nut modules
//---------------------------------------

// external thread (male bolt)
module bolt(
    height=10,                  // length (height) of the bolt
    outer_radius=10,            // outer_radius must be bigger than inner_radius. Threads are guaranteed to fit inside this radius as long as scale_x & scale_y are < 1.
    inner_radius=6,             // 0 <= inner_radius < scale_smaller*outer_radius -> inner_radius specifies the radius of the core of the bolt that will be emptied to form a pipe. Always use a value less than the magnitude of the smaller radius of the ellipse (i.e., scale_smaller*outer_radius, where scale_smaller = whichever of scale_x or scale_y is smaller than the other) that forms the threads, or else you'll eliminate the sidewall of the screw and just have a helical thread sitting in space.
    scale_x=0.8,                // 0 < scale_x < 1  -> scaling ratio of the ellipse in the x-dimension that is extruded. 
    scale_y=0.7,                // 0 < scale_y < 1  -> scaling ratio of the ellipse in the y-dimension that is extruded. 
    thread_shave=0.5,           // 0 <= thread_shave <= 1  -> thread_shave specifies the percentage of the thread that will be shaved off as a fraction of 1 (e.g., 0.5 => 50% shaved off, 0 => no shave, 1 => completely shaved off) 
    revolutions=-2,             // number of full 360 degree revolutions the thread will make over the length of the bolt.
    taper_angle=60              // angle of taper of the thread at the insertion side.
    ){

    radius_offset = inner_radius - outer_radius;    // should be a negative quantity (outer radius > inner radius) so that offset circles are smaller. inner_radius defines the the interior of a pipe.
    scale_smaller = scale_y < scale_x ? scale_y : scale_x; // determines which scale factor is smaller for taper_height calculation (guarantees the taper_cone_bolt intersects the smaller radius of the ellipse)
    scale_bigger = scale_y > scale_x ? scale_y : scale_x; // determines which scale factor is bigger.
    taper_height = (1-scale_smaller)*outer_radius*tan(taper_angle); // calculates the distance to draw down the taper_cone() to intersect the first thread of the bolt
    thread_shave_mag = -((1-scale_bigger)+((scale_bigger-scale_smaller)*thread_shave))*outer_radius; // a literal dimension, not a percentage. Includes the amount of reach from the outer_radius to the scale_bigger*outer_radius, so this is not the literal dimension of the amount of thread shaved.

    if(inner_radius > (scale_smaller*outer_radius)){echo("inner_radius (which creates a hole in the bolt's core) is bigger than the inner radius of the thread. Either make inner_radius smaller, or make the smaller value of the two parameters scale_x & scale_y of your bolt bigger, otherwise you will produce a floating helical thread or empty space rather than a bolt as expected.");}

    difference(){
        linear_extrude(height, twist=revolutions*360){
            difference(){
                difference(){
                    scale([scale_x,scale_y])circle(outer_radius);   // constructs the threads by revolving an ellipse (the scaled circle) through a linear extrusion.
                    offset(r=radius_offset)circle(outer_radius);    // the offset circle is for subtracting an inner core if you desire to use the bolt as a piping coupler. Make sure outer_radius > inner_radius.
                }

                difference(){
                    circle(outer_radius);                         // circle of slightly larger radius than the maximum outer radius of the threads
                    offset(r=thread_shave_mag)circle(outer_radius);   // inset circle that defines the edge that "shaves" the thread
 
                    // creates a circular (not an elliptical) ring with an inset radius slightly smaller than the maximum radius of the ellipse.
                    // this ring is differenced against the ellipse in order to "shave" the ellipse slightly, which creates a flat thread after the linear_extrusion operation.
                    // shaving the thread aids insertion of the bolt by decreasing surface contact with the internal threads of the nut (see: https://en.wikipedia.org/wiki/ISO_metric_screw_thread) for an example of this.
                }
            }
        }

        translate([0,0,height-taper_height])taper_cone_bolt(radius=outer_radius,angle=taper_angle);

    }
}

module nut(
    height=10,
    outer_radius=10,
    inner_radius=6,
    scale_x=0.8,
    scale_y=0.7,
    thread_shave=0.5,
    revolutions=-2,
    taper_angle=60
    ){
    
    radius_offset = inner_radius - outer_radius;    // should be a negative quantity (outer radius > inner radius) so that offset circles are smaller. inner_radius defines the the interior of a pipe.
    scale_smaller = scale_y < scale_x ? scale_y : scale_x; 
    scale_bigger = scale_y > scale_x ? scale_y : scale_x; // determines which of the scale factors is bigger for use in taper_height
    taper_height = scale_bigger*outer_radius*tan(taper_angle); // calculates the distance to draw down the taper_cone() to intersect the first thread of the bolt
    thread_shave_mag = outer_radius; 

    difference(){
        difference(){
            //outer cylinder
            linear_extrude(height){
                difference(){
                    circle(outer_radius);
                    offset(r=radius_offset)circle(outer_radius);
                }
            }

            //subtracted threads
            linear_extrude(height,twist=revolutions*360){
                scale([scale_x,scale_y])circle(outer_radius);
            }
        }

        //inverted (small diameter at base) cone subtracted to taper the initial thread insert
        translate([0,0,height-taper_height])taper_cone_nut(radius=outer_radius,angle=taper_angle);
    }
}



bolt(inner_radius=6.5);
translate([20,0,0])nut(inner_radius=7.0);

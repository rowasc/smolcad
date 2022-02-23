/**
A very simple box generator because I needed it
**/
$fn=20;

module using_hulls(){
    number_of_cylinders = 4;
    radius = 20;
    height=25;

    hull(){
        for (i = [1:number_of_cylinders]) {
            rotate(i * 360/number_of_cylinders)
                translate([100,100,0]) 
                    cylinder(r=radius, h=height);
        }
    }
}

//outside sizes for enclosure
box_width = 25;
box_lenght = 80;
box_height = 25;

// additional params
walls_multiplier=0.6; // thickness multiplier, make <1 for less thick, >1 for thick walls
corner_radius = 1;
wall_thickness = 2.5*walls_multiplier;
post_diameter=2;
hole_diameter=2;
lid_thickness =1.2*walls_multiplier;
lid_outer_extension=2*walls_multiplier;
lid_lip=1;
lid_tolerance=.1;
tolerance=.1;


module separators(y) {
    translate([(0 - box_width/2 + wall_thickness),y, lid_thickness]){
        cube([box_width - wall_thickness*2, wall_thickness, box_height - corner_radius-lid_thickness]);
    }
}
module posts(x, y, z, h, r) {
    translate([x,y,z]){
        cylinder(r = r, h=h);
    }
    
    translate([-x,y,z]){
        cylinder(r = r, h=h);
    }
    
    translate([-x,-y,z]){
        cylinder(r = r, h=h);
    }
   
    translate([x,-y,z]){
        cylinder(r = r, h=h);
    }
}
module enclosure(){
    difference(){
        //box
        color("red") hull(){
            posts(
                x=( box_width/2 - corner_radius),
                y=( box_lenght/2 - corner_radius),
                z=0,
                h=box_height,
                r=corner_radius
            );
        }

        //hollow part

        hull(){
            posts(
                x=( box_width/2 - corner_radius - wall_thickness),
                y=( box_lenght/2 - corner_radius - wall_thickness),
                z=wall_thickness,
                h=box_height,
                r=corner_radius
            );
        }
        //lip inside
        hull(){
            posts(
                x=( box_width/2 - corner_radius - lid_lip),
                y=( box_lenght/2 - corner_radius - lid_lip),
                z=(box_height-lid_thickness),
                h=lid_thickness+lid_tolerance*2,
                r=corner_radius
            );
        }
    }
}

module lid(){
    translate([0,0,5]) union(){

        hull(){
            posts(
                x=( box_width/2 - corner_radius - wall_thickness/2 - lid_tolerance),
                y=( box_lenght/2 - corner_radius - wall_thickness/2 - lid_tolerance),
                z=(box_height-lid_thickness),//5 is just to make it stick up so we can see it while working on the model
                h=lid_thickness,
                r=corner_radius
            );
        }
        //lid
        difference(){
            color("blue") hull(){
            posts(
                x=( box_width/2 - corner_radius - wall_thickness/2 + lid_outer_extension),
                y=( box_lenght/2 - corner_radius - wall_thickness/2 +lid_outer_extension),
                z=(box_height),//5 is just to make it stick up so we can see it while working on the model
                h=lid_thickness*2,
                r=corner_radius
            );
        }
        
    
        color("red") hull(){
            posts(
                x=( box_width/2 - corner_radius),
                y=( box_lenght/2 - corner_radius),
                z=(box_height+lid_thickness),
                h=lid_thickness*2,
                r=corner_radius
            );
        }
        }
        
    }
}
enclosure();

color("blue") separators(
    y= ( wall_thickness/2*-1)
);

/**color("blue") separators(
    y= ( wall_thickness/2*-1) - box_lenght/2
);
**/
/**
color("blue") separators(
    y= ( wall_thickness/2*-1) + box_lenght/2
);**/

//rotate([180,180,180]) translate([box_width*1.1,0,-box_height-lid_thickness*4]) lid();

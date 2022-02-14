//somehow this affects the cylinders and text so they are smoother
$fn=25;
// dupont connector outer size
width = 2.8;
depth = 2.8;
lenght = 12;//the connectors should fit perfectly snug in the case, but 2mm should stick out so that they can be pulled out
border = 1;//if the holder isn't strong, it tends to break down when you stick a dupont in it
// outer size, just for convenience
dupontWidth = width+border;
dupontLenght = lenght+border;
dupontHeight = depth+border;
//these are individual so that I can make changes to one side or the other
module dupont () {
    // dupont holder x1, difference uses the first param as a solid, and then removes the rest of the params from it
    difference() {
        // outside of the connector's single holder
        cube([dupontWidth, lenght, depth+border]);
        // inside of the dupont connector single holder
        translate ([border/2, 0, border/2]) cube([width, lenght, depth]);
    }
}
/**
* Parametrizable maker of tiny dupont group holders
**/
module makeHolder (total=3) {
    // divider line for the two sides of the connector
    translate([dupontWidth*(1), lenght-(border/2), depth+border ]) color ("red") cube([dupontWidth*total, border/2, border/2]); 
    // obviously we gotta label the sides, it's nice to have labels (?
    translate([dupontWidth+1, border, dupontHeight ]) linear_extrude(.4) text("Innie", 2);
    translate([dupontWidth+1, (lenght*2)-2-border, dupontHeight ]) linear_extrude(.4) text("Outie", 2);
    /**
     we are creating 3 holders, since that's what I usually need for keyboards
     but it's easy to just change this to be 5, 10, whatever size holder we need
    **/
    for(dupontCount = [1 : total]) {
        xDistance = dupontWidth*dupontCount;
        translate([xDistance, 0,0]) color("red") dupont();
        // hacky "border/8"  is to avoid edges touching without overlapping AKA "not a manifold" error
        // IDK what a nice fix would be here, yet
        rotate([0,0,180]) translate([-1*dupontWidth*(dupontCount+1), -1*((lenght-(border/8))*2),0]) color("blue") dupont();
    }
}
// make 3 holders, just change 3 to whatever number we need
makeHolder(3);
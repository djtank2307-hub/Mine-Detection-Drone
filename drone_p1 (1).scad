// Professional 150mm Micro Drone Frame (15x15 cm class)
// V4: High-End FPV Aesthetic, Skeletonized, Swept Arms, Motor Bumpers
// Units: Millimeters (mm)

$fn = 120; // Extremely high resolution for pristine curves

// --- Parametric Variables ---
wheelbase = 150;        
bottom_thickness = 4.0; 
top_thickness = 2.0;    
standoff_height = 25;   
edge_radius = 2.5;      

// Hardware Spacing
fc_spacing = 20;        
pi5_x = 58;             
pi5_y = 49;             
motor_spacing = 9;      
standoff_radius = 26;   

// Camera Module 3
cam_offset_y = 38;      
cam_hole_x = 21.0;      
cam_hole_y = 12.5;      
cam_lens_d = 14;        

// --- Modules for Professional Cutouts ---
module hex_cutout(radius) {
    circle(r=radius, $fn=6);
}

module rounded_slot(l, w) {
    hull() {
        translate([-l/2 + w/2, 0]) circle(d=w);
        translate([l/2 - w/2, 0]) circle(d=w);
    }
}

// --- Part 1: Bottom Power & Vision Deck ---
module bottom_plate() {
    color("#2a2a2a") { // Carbon Fiber gray
        difference() {
            linear_extrude(height = bottom_thickness) {
                offset(r=edge_radius) offset(delta=-edge_radius) {
                    union() {
                        // Main Hub
                        circle(r=32);
                        
                        // Swept Camera Chin
                        hull() {
                            translate([0, 15]) square([40, 10], center=true);
                            translate([0, cam_offset_y]) square([26, 22], center=true);
                        }
                        
                        // Tapered Arms with Motor Bumpers
                        for (angle = [45, 135, 225, 315]) {
                            rotate([0, 0, angle]) {
                                hull() {
                                    // Wide root at the base
                                    translate([15, 0]) circle(r=9);
                                    // Narrower tip at the motor
                                    translate([wheelbase/2 - 5, 0]) circle(r=6);
                                }
                                // Motor Pad with Bumper
                                translate([wheelbase/2, 0]) {
                                    circle(r=11.5); // Main pad
                                    translate([2, 0]) circle(r=12.5); // Bumper extension
                                }
                            }
                        }
                    }
                }
            }
            
            // Camera Mount (Verified 21x12.5mm)
            translate([0, cam_offset_y, -1]) {
                cylinder(h=bottom_thickness+2, d=cam_lens_d);
                for (x = [-cam_hole_x/2, cam_hole_x/2]) {
                    for (y = [-cam_hole_y/2, cam_hole_y/2]) {
                        translate([x, y, 0]) cylinder(h=bottom_thickness+2, d=2.2);
                    }
                }
            }
            
            // 20x20mm FC Stack Holes
            for (x = [-fc_spacing/2, fc_spacing/2]) {
                for (y = [-fc_spacing/2, fc_spacing/2]) {
                    translate([x, y, -1]) cylinder(h=bottom_thickness+2, d=2.2);
                }
            }
            
            // Frame Standoff Holes (M3)
            for (angle = [45, 135, 225, 315]) {
                rotate([0, 0, angle]) translate([standoff_radius, 0, -1])
                    cylinder(h=bottom_thickness+2, d=3.2);
            }
            
            // Motor Mounting Holes (9mm spacing)
            for (angle = [45, 135, 225, 315]) {
                rotate([0, 0, angle]) translate([wheelbase/2, 0, -1]) {
                    cylinder(h=bottom_thickness+2, d=6); // Center bearing
                    for (m = [0, 90, 180, 270]) {
                        rotate([0, 0, m]) translate([motor_spacing/2, 0, 0])
                            cylinder(h=bottom_thickness+2, d=2.2);
                    }
                }
            }
            
            // Professional Skeletonization (Weight Reduction Cutouts)
            for (angle = [0, 180, 270]) {
                rotate([0, 0, angle]) translate([22, 0, -1])
                    linear_extrude(height=bottom_thickness+2) hex_cutout(6);
            }
            
            // Arm truss cutouts
            for (angle = [45, 135, 225, 315]) {
                rotate([0, 0, angle]) translate([38, 0, -1])
                    linear_extrude(height=bottom_thickness+2) rounded_slot(24, 4.5);
            }
        }
    }
}

// --- Part 2: Top Pi 5 Compute Deck ---
module top_plate() {
    color("#3a3a3a") {
        translate([0, 0, standoff_height]) {
            difference() {
                linear_extrude(height = top_thickness) {
                    offset(r=edge_radius) offset(delta=-edge_radius) {
                        union() {
                            // Core Pi 5 Footprint
                            square([82, 56], center=true);
                            
                            // Standoff mounting tabs
                            for (angle = [45, 135, 225, 315]) {
                                rotate([0, 0, angle]) translate([standoff_radius, 0])
                                    circle(r=6);
                            }
                            
                            // Rear Antenna / VTX Tail (Faces -Y)
                            translate([0, -35]) square([25, 15], center=true);
                        }
                    }
                }
                
                // Frame Standoff Holes (M3)
                for (angle = [45, 135, 225, 315]) {
                    rotate([0, 0, angle]) translate([standoff_radius, 0, -1])
                        cylinder(h=top_thickness+2, d=3.2);
                }
                
                // Raspberry Pi 5 Mounting Holes (58x49mm, M2.5)
                for (x = [-pi5_x/2, pi5_x/2]) {
                    for (y = [-pi5_y/2, pi5_y/2]) {
                        translate([x, y, -1]) cylinder(h=top_thickness+2, d=2.75);
                    }
                }
                
                // LiPo Battery Strap Slots
                translate([25, 0, -1]) 
                    linear_extrude(height = top_thickness+2) rounded_slot(4, 16);
                translate([-25, 0, -1]) 
                    linear_extrude(height = top_thickness+2) rounded_slot(4, 16);
                
                // Antenna Zip-Tie Slots on Rear Tail
                translate([8, -38, -1]) 
                    linear_extrude(height = top_thickness+2) rounded_slot(2, 6);
                translate([-8, -38, -1]) 
                    linear_extrude(height = top_thickness+2) rounded_slot(2, 6);
                
                // Camera Ribbon Cable Pass-through
                translate([0, 22, -1]) 
                    linear_extrude(height = top_thickness+2) rounded_slot(20, 3);
                    
                // Top Plate Skeletonization
                translate([0, -15, -1]) 
                    linear_extrude(height=top_thickness+2) hex_cutout(8);
                translate([0, 0, -1]) 
                    linear_extrude(height=top_thickness+2) hex_cutout(8);
            }
        }
    }
}

// --- Part 3: Hexagonal Aluminum Standoffs ---
module standoffs() {
    color("Crimson") { // Anodized red standoffs
        for (angle = [45, 135, 225, 315]) {
            rotate([0, 0, angle]) translate([standoff_radius, 0, 0])
                linear_extrude(height = standoff_height) hex_cutout(2.8);
        }
    }
}


bottom_plate();
top_plate();
standoffs();
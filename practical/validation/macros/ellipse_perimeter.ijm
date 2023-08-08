// shape parameters
r1 = 40;
r2 = 20;
perimTh = 193.77;

// check with fixed orientation
imgEllipse = "ellipse40x20";
newImage(imgEllipse, "8-bit black", 200, 200, 1);
centerX = 100 + random;
centerY = 100 + random;
theta = random * 180;
run("Fill Ellipse", "center_x=&centerX center_y=&centerY major=&r1 minor=&r2 orientation=&theta fill=255");

// Run analysis with ImageJ
setAutoThreshold("Default dark");
run("Analyze Particles...", "display clear");

// retrieve perimeter and compute error
perimIJ = Table.get("Perim.", 0);
errorIJ = 100 * (perimIJ - perimTh) / perimTh;
print("Relative Error using ImageJ: " + errorIJ + "%");

// Run analysis with MorphoLibJ
run("Analyze Regions", "area perimeter equivalent_ellipse");
selectWindow(imgEllipse + "-Morphometry");

// retrieve perimeter and compute error
perimMLJ = Table.get("Perimeter", 0);
errorMLJ = 100 * (perimMLJ - perimTh) / perimTh;
print("Relative Error using MorphoLibJ: " + errorMLJ + "%");
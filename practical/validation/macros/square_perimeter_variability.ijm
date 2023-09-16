// shape parameters
sideLength = 100;
perimTh = 400.0;

// the image name
imgName = "squareS100";

// number of repetitions
nRepets = 100;

// initialize array
perimIJArray = newArray(nRepets);
perimMLJArray = newArray(nRepets);

run("Clear Results");

for (i=0; i < nRepets; i++) {
    // check with fixed orientation
    newImage(imgName, "8-bit black", 200, 200, 1);
    centerX = 100 + random;
    centerY = 100 + random;
    ori = random * 180;
    run("Fill Rotated Square", "center_x=&centerX center_y=&centerY side_length=&sideLength orientation=&ori fill=255");

    // Run analysis with ImageJ
    setAutoThreshold("Default dark");
    run("Analyze Particles...", "display");

    // retrieve perimeter and compute error
    selectWindow("Results");
    perimIJ = Table.get("Perim.", i);
    print(perimIJ);
    perimIJArray[i] = perimIJ;
    errorIJ = 100 * (perimIJ - perimTh) / perimTh;
    print("Relative Error using ImageJ: " + errorIJ + "%");

    // Run analysis with MorphoLibJ
    run("Analyze Regions", "area perimeter");
    selectWindow(imgName + "-Morphometry");

    // retrieve perimeter and compute error
    perimMLJ = Table.get("Perimeter", 0);
    perimMLJArray[i] = perimMLJ;
    errorMLJ = 100 * (perimMLJ - perimTh) / perimTh;
    print("Relative Error using MorphoLibJ: " + errorMLJ + "%");
    // clean up
    close(imgName);
}

// Array.print(perimIJArray);
// Array.print(perimMLJArray);

Array.getStatistics(perimIJArray, min, max, mean, std);
print("ImageJ stats");
print("   min: "+min);
print("   max: "+max);
print("   mean: "+mean);
print("   std dev: "+std);

Array.getStatistics(perimMLJArray, min, max, mean, std);
print("MorphoLibJ stats");
print("   min: "+min);
print("   max: "+max);
print("   mean: "+mean);
print("   std dev: "+std);

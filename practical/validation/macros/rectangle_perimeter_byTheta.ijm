// shape parameters
side1 = 150;
side2 = 50;
perimTh = 400;
centerX = 100 + random;
centerY = 100 + random;

// the image name
imgName = "ellipse40x20";

// number of repetitions
nTheta = 180;

// initialize array
thetaArray = newArray(nTheta);
perimIJArray = newArray(nTheta);
errorIJArray = newArray(nTheta);
perimMLJArray = newArray(nTheta);
errorMLJArray = newArray(nTheta);

run("Clear Results");

for (i=0; i < nTheta; i++) {
    // check with fixed orientation
    newImage(imgName, "8-bit black", 200, 200, 1);
    theta = i;
    run("Fill Oriented Box", "center_x=&centerX center_y=&centerY box_length=&side1 box_width=&side2 orientation=&theta fill=255");
    thetaArray[i] = theta;
    
    // Run analysis with ImageJ
    setAutoThreshold("Default dark");
    run("Analyze Particles...", "display");

    // retrieve perimeter and compute error
    selectWindow("Results");
    perimIJ = Table.get("Perim.", i);
    print(perimIJ);
    perimIJArray[i] = perimIJ;
    errorIJ = 100 * (perimIJ - perimTh) / perimTh;
    errorIJArray[i] = errorIJ;
    //print("Relative Error using ImageJ: " + errorIJ + "%");

    // Run analysis with MorphoLibJ
    run("Analyze Regions", "area perimeter");
    selectWindow(imgName + "-Morphometry");

    // retrieve perimeter and compute error
    perimMLJ = Table.get("Perimeter", 0);
    perimMLJArray[i] = perimMLJ;
    errorMLJ = 100 * (perimMLJ - perimTh) / perimTh;
    errorMLJArray[i] = errorMLJ;
    //print("Relative Error using MorphoLibJ: " + errorMLJ + "%");
    // clean up
    close(imgName);
}

Plot.create("Variations of Perimeter", "Rectangle Orientation", "Perimeter");
Plot.setLimits(0, 180, 370, 435);
Plot.setLineWidth(2);
Plot.setColor("red");
Plot.add("line", thetaArray, perimIJArray);
Plot.setColor("blue");
Plot.setLineWidth(2);
Plot.add("line", thetaArray, perimMLJArray);
Plot.setLegend("ImageJ\tMorphoLibJ", "top-right");

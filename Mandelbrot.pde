// Declare the range of points we're plotting
float xMin = -2.5;
float xMax = 1;
float yMin = -1.5;
float yMax = 1.5;
// Declare the resolution and maximum iteration number
int resolution = 2;
int iterMax = 30;

void setup() {
  // Create the window and display the original mandelbrot
  size(600, 600);
  display();
}

// This just keeps the application listening for events such as the mouse scroll
void draw() {
}

// Function: included
// Returns a float from 0-255, indicating how many iterations it took to decide if a given point was inside/outside the mandelbrot set.
// 0 indicates the point is easily outside the set, 255 indicates it seems to be inside the set
//
// real_:        The real component of the point being tested
// imag_:        The imaginary component of the point being tested
// iterCount:   The maximum number of iteration steps the function will take
//
// return:       a float between [0,255] indicating how many steps it took to exclude the point from the mandelbrot set
float included(float real_, float imag_, int iterCount) {
  
  // start a counter for how many iterations we've taken
  int iterVal = 0;
  
  // Store temporary variables for the complex numbers, as well as the next values we'll take
  float real = 0;
  float imag = 0;
  float nextReal = 0;
  float nextImag = 0;
  
  // While we haven't exceeded the maximum iteration count, and while the magnitude of our complex number isn't >4 (at which point we escape the set)
  while (iterVal<iterCount & pow(real, 2)+pow(imag, 2)<4) {
    // Calculate what the next real and imaginary components are
    nextReal = pow(real, 2) - pow(imag, 2) + real_;
    nextImag = 2*real*imag + imag_;
    
    // update the real and imaginary components, and iterate the counter
    real = nextReal;
    imag = nextImag;
    iterVal++;
  }

  // iterVal will be between 0-iterCount, so rescale that to between 0 and 255; and return it.
  return map(iterVal, 0, iterCount, 0, 255);
}

// Function: display
// Displays the new mandelbrot set. Uses global variables to decide on the window range, resolution, etc.
void display() {
  // Clear the screen and declare some variables to be used later. turn off stroke.
  background(0);
  float xP;
  float yP;
  noStroke();
  // For every pixel, taking steps of size resolution
  for (int x=0; x<width; x+=resolution) {
    for (int y=0; y<600; y+=resolution) {
      // Map the pixel location (0-600) to a value in our image range
      xP = map(x, 0, width, xMin, xMax);
      yP = map(y, 0, height, yMin, yMax);
      
      // set the fill to be a value from 0-255 depending on how long the point takes to escape the set
      fill(included(xP, yP, iterMax));
      // Draw a rectangle
      rect(x, y, resolution, resolution);
    }
  }
  
  // Add red text to describe the maximum iteration and resolution
  fill(255, 0, 0);
  text("Max iteration: "+str(iterMax), 25, 25);
  text("resolution: "+str(resolution), 25, 40);
}

void mouseWheel(MouseEvent event) {
  // determine the current scale amount
  float xWidth = xMax-xMin;
  float yWidth = yMax-yMin;
  // Depending on which way the user scrolled
  if (event.getCount()<0) {
    // Zoom in
    xWidth*=0.75;
    yWidth*=0.75;
  } else {
    // Zoom out
    xWidth*=1.25;
    yWidth*=1.25;
  }
  // Set the center of the screen to where the mouse is currently
  float xCenter = map(mouseX, 0, width, xMin, xMax);
  float yCenter = map(mouseY, 0, height, yMin, yMax);
  
  // Set the new limits as the center (mouse location) with offsets set by the scale
  xMin = xCenter-0.5*xWidth;
  xMax = xCenter+0.5*xWidth;
  yMin = yCenter-0.5*yWidth;
  yMax = yCenter+0.5*yWidth;
  
  // redisplay the information
  display();
}

void keyPressed() {
  // Do different things depending on which key was pressed
  
  // If the left key was pressed and resolution is >1, decrease resolution (clearer image) and display
  if (keyCode==LEFT && resolution>1) {
    resolution-=1;
    display();
  }
  // If Right was pressed, increase resolution (less clear image) and display
  if (keyCode==RIGHT) {
    resolution+=1;
    display();
  }
  // If Down was pressed and we're iterating >5 times, decrease the max iteration by 5 and display
  if (keyCode==DOWN & iterMax>5) {
    iterMax-=5;
    display();
  }
  // If Up was pressed, increase maximum iteration by 5 and display
  if (keyCode==UP) {
    iterMax+=5;
    display();
  }
}

// If the mouse is clicked, reset all settings to default.
void mouseClicked() {
  xMin = -2.5;
  xMax = 1;
  yMin = -1.5;
  yMax = 1.5;
  resolution = 2;
  iterMax = 30;
  display();
}

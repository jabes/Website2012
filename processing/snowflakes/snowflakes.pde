float [] arrWidth;
float [] arrHeight; 
float [] arrX;
float [] arrY; 
float [] arrSpeed;
float [] arrWind;

int nFlakeAmount;
int nFlakeSpeed;

void setup () {

	//size(screen.width, screen.height);
	size(PROCESSING_SCREEN_WIDTH, PROCESSING_SCREEN_HEIGHT);

	smooth();
	noStroke();

	fill(0, 150, 255);

	nFlakeAmount = 800; // number of snow flakes drawn on the screen
	nFlakeSpeed = 200; // a multiple of how fast each snow flake moves

	// set our index length
	arrWidth = new float[nFlakeAmount];
	arrHeight = new float[nFlakeAmount];
	arrX = new float[nFlakeAmount];
	arrY = new float[nFlakeAmount];
	arrSpeed = new float[nFlakeAmount];
	arrWind = new float[nFlakeAmount];

	// setup initial snow flake attributes
	for(int i=1; i<nFlakeAmount; i++) {

		float flakeSize = random(1, 8);
		arrWidth[i] = flakeSize;
		arrHeight[i] = flakeSize;

		arrX[i] = random(0,width);
		arrY[i] = random(0,height);

		arrSpeed[i] = random(0,1) * nFlakeSpeed / flakeSize;
		arrWind[i] = random(-1,1) * arrSpeed[i] / 5;

	}
}


void draw () {

	background(0); // redraw over old rects

	// ok lets draw our flakes!
	for(int i=1; i<nFlakeAmount; i++) {

		rect(arrX[i],arrY[i],arrWidth[i],arrHeight[i]);

		if (arrY[i] > height) {
			arrY[i] = -arrHeight[i]; // if we have reached the bottom then move the flake back to the top
			arrX[i] = random(0,width); // reset x because the wind may have blown it off the canvas
		} else {
			arrY[i] += arrSpeed[i]; // move the snow flake down at its current speed
		}

		// move the flake in the X at its current wind
		arrX[i] += arrWind[i];

	}
  
}



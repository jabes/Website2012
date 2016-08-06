int nCircAmount;
float easing,x,y;

float [] arrCircPosX;
float [] arrCircPosY;
float [] arrCircRadius;
color [] arrCircColor;

void setup () {

	size(PROCESSING_SCREEN_WIDTH, PROCESSING_SCREEN_HEIGHT);

	smooth();
	noStroke();
	colorMode(HSB, 255);
	rectMode(CENTER);
	ellipseMode(CENTER);

	nCircAmount = 100;
	easing = 0.05;

	arrCircPosX = new float[nCircAmount];
	arrCircPosY = new float[nCircAmount];
	arrCircRadius = new float[nCircAmount];
	arrCircColor = new color[nCircAmount];


	for(int i=0; i<nCircAmount; i++) {

		arrCircPosX[i] = x = width/2;
		arrCircPosY[i] = y = height/2;
		arrCircRadius[i] =  i + 10;
		arrCircColor[i] = color(random(0,255),random(0,255),random(0,255));

	}

	arrCircRadius = reverse(arrCircRadius);
}


void draw () {

	background(255);

	x += (mouseX-x) * easing;
	y += (mouseY-y) * easing;

	// remove the first element in the array and append the current mouse position to the end
	arrCircPosX = append(reverse(shorten(reverse(arrCircPosX))),x);
	arrCircPosY = append(reverse(shorten(reverse(arrCircPosY))),y);


	for(int i=0; i<nCircAmount; i++) {

		fill(arrCircColor[i]);
		ellipse(arrCircPosX[i],arrCircPosY[i],arrCircRadius[i],arrCircRadius[i]);

	}
  
}



int nCircAmount;
float x, y, pathPosX, pathPosY, pathRadius, pathSpeed, nCircSize;

float [] arrCircPosX;
float [] arrCircPosY;
float [] arrCircRadius;
color [] arrCircColor;

void setup () 
{

	size(PROCESSING_SCREEN_WIDTH, PROCESSING_SCREEN_HEIGHT);
	//frameRate(30);

	smooth();
	noStroke();
	//colorMode(HSB, 255);

	pathPosX = width / 2;
	pathPosY = height / 2;
	// use the shortest viewport length to determine the path radius
	pathRadius = ((width > height) ? height : width) / 3.5;
	// arbitrary number for calculating how fast the circle moves around the path
	// keep it somewhat relevant to the path size
	pathSpeed = pathRadius * 10.0;

	nCircAmount = ceil(width / 10);

	// use pythagorean theorem to find the diagonal length of our viewport
	float d = sqrt(sq(width) + sq(height));
	// the viewport diagonal length + the motion path diameter = the diameter of our largest circle
	// divide by number of circles to obtain the size of each circle
	nCircSize = (d + (pathRadius * 2)) / (float) nCircAmount;

	arrCircPosX = new float[nCircAmount];
	arrCircPosY = new float[nCircAmount];
	arrCircRadius = new float[nCircAmount];
	arrCircColor = new color[nCircAmount];

	for (int i = 0; i < nCircAmount; i++) 
	{
		// set initial circle coords based off the start position of the path
		arrCircPosX[i] = pathPosX + pathRadius * cos(0);
		arrCircPosY[i] = pathPosY + pathRadius * sin(0);
		// int i will be 0 on first pass when it needs to be 1
		// ex: 0 * 5 = 0 <-- this results in the first circle having a radius of zero
		arrCircRadius[i] = (i + 1) * nCircSize;
		arrCircColor[i] = randomColor();
	}

	arrCircRadius = reverse(arrCircRadius);

}

void draw () 
{

	background(255);

	// get the x and y coords along the circle
	float time = millis() / pathSpeed;
	x = pathPosX + pathRadius * cos(time);
	y = pathPosY + pathRadius * sin(time);

	// remove the first element in the array and append the current mouse position to the end
	arrCircPosX = append(reverse(shorten(reverse(arrCircPosX))), x);
	arrCircPosY = append(reverse(shorten(reverse(arrCircPosY))), y);

	// shift the color values down the list
	arrCircColor = append(reverse(shorten(reverse(arrCircColor))), randomColor());

	for(int i = 0; i < nCircAmount; i++)
	{
		fill(stainColor(arrCircColor[i], (float) i / (float) nCircAmount));
		ellipse(arrCircPosX[i], arrCircPosY[i], arrCircRadius[i], arrCircRadius[i]);
	}

}

color stainColor(color c, float amount)
{
	int rr = (int) ((red(c) * (1 - amount) / 255) * 255);
	int gg = (int) ((green(c) * (1 - amount) / 255) * 255);
	int bb = (int) ((blue(c) * (1 - amount) / 255) * 255);
	return color(rr, gg, bb);
}

color randomColor()
{
	return color(random(0, 255), random(0, 255), random(0, 255));
}
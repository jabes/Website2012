
import processing.opengl.*;

int nBoxAmount = 500;
float[] boxPosX;
float[] boxPosY;
int[] boxPosZ;
float[] boxSize;
color[] boxColor;


void setup () {

	size(PROCESSING_SCREEN_WIDTH, PROCESSING_SCREEN_HEIGHT, OPENGL);

	smooth();
	noStroke();

	boxPosX = new float[nBoxAmount];
	boxPosY = new float[nBoxAmount];
	boxPosZ = new int[nBoxAmount];
	boxSize = new float[nBoxAmount];
	boxColor = new color[nBoxAmount];

	for(int i=0; i<nBoxAmount; i++) {

		boxPosX[i] = random(0, width);
		boxPosY[i] = random(0, height);
		boxPosZ[i] = i;
		boxSize[i] = random(5, 30);
		boxColor[i] = color(random(0, 255), random(0, 255), random(0, 255));

	}
	 
}

void draw () {
	
	background(0);
	lights();
	
	for(int i=0; i<nBoxAmount; i++) {
		drawBox(boxPosX[i], boxPosY[i], boxPosZ[i], boxSize[i], boxColor[i]);
	}

}

void drawBox (float x, float y, int z, float s, color c) {

	pushMatrix();

	fill(c);

	translate(x, y, z); 

	rotateX(float(mouseY) / 100);
	rotateY(float(mouseX) / 100);

	box(s);

	popMatrix();

}

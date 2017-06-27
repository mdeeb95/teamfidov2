var shapes = [];
var levels = [];
var clicks = [];
var DPI = 110;
var shapesLocked = false;
 
void setup() {
    size(screen.width - 50, screen.height - 275);
    for (var i = 0; i < 3; i++) {
        shapes.push(new Box(random(255), 1));
    }
    for (var i = 0; i < 3; i++) {
        shapes.push(new Circle(random(255), 1));
    }
}
 
void draw() {
    background(0, 0, 0);
    for (var i = 0; i < shapes.length; i++) {
        shapes[i].show();
    }
}
 
void mousePressed() {
	if (!shapesLocked) {
        var shapesover = [];
        for (var i = 0; i < shapes.length; i++) {
            if (shapes[i].shapeover == true) {
                shapesover.push(shapes[i]);
	            shapes[i].locked = true;
	            print("mouse is pressed")
	        } else {
	            shapes[i].locked = false;
	            print("mouse isn't pressed")
	        }
	        shapes[i].xoffset = mouseX - shapes[i].xpos;
	        shapes[i].yoffset = mouseY - shapes[i].ypos
	        print(shapes[i].locked);
	    }
	} else {
        clicks.push(new ScreenPress(mouseX, mouseY, shapesover));
    }
	console.log("mousex: "+mouseX+" mouseY: "+mouseY);
    return false;
}
 
void mouseDragged() {
    for (var i = 0; i < shapes.length; i++) {
        if (shapes[i].locked) {
            shapes[i].xpos = mouseX - shapes[i].xoffset;
            shapes[i].ypos = mouseY - shapes[i].yoffset;
        }
    }
}
 
void mouseReleased() {
    for (var i = 0; i < shapes.length; i++) {
        shapes[i].locked = false;
    }
}

void lockShapes() {
	shapesLocked = true;
	console.log("shapes are now locked");
}

void unlockShapes() {
	shapesLocked = false;
	console.log("shapes are now unlocked");
}

void logShapes() {
    console.log(shapes);
    console.log(clicks);
}

void updateDPI(screensize) {
    DPI = sqrt(sq(screen.width) + sq(screen.height)) / screensize;
}

boolean createNewShape(type, size, color) {
	console.log(color);
	if (type != null && size > 0) {
		switch(type) {
			case 'circle':
			var newcircle = new Circle(color, size / 2);
			shapes.push(newcircle);
			return true;
			case 'square':
			var newbox = new Box(color, size / 2);
			shapes.push(newbox);
			return true;
			case 'triangle':
			//create tri, no tri func yet
			break;
		}
	}
	return false;
}

void Level(shapes, name) {
    this.shapes = shapes;
    this.name = name;
}

void ScreenPress(x, y, clickedshapes) {
    this.x = x;
    this.y = y;
    this.hour = hour();
    this.minute = minute();
    this.second = second();
    this.clickedshapes = clickedshapes;
}
 
void Box(tempColor, tempSize) {
    this.c = tempColor;
    this.xpos = random(width);
    this.ypos = random(height);
    this.shapesize = tempSize;
    this.shapeover = false;
    this.locked = false;
    this.xoffset = 0;
    this.yoffset = 0;
    rectMode(RADIUS);
    console.log(this.shapesize);
 
    this.show = function() {
        var pixelsize = this.shapesize * DPI;
        console.log(pixelsize);
 
        if (mouseX > this.xpos - pixelsize && mouseX < this.xpos + pixelsize &&
            mouseY > this.ypos - pixelsize && mouseY < this.ypos + pixelsize) {
            this.shapeover = true;
            fill(this.c.r, this.c.g, this.c.b, 80);
 
            if (mousePressed && this.shapeover == true) {
                stroke(200, 79, 100);
                strokeWeight(5);
            } else {
                noStroke();
            }
 
        } else {
            this.shapeover = false;
            noStroke();
            fill(this.c.r, this.c.g, this.c.b);
        }
        rect(this.xpos, this.ypos, pixelsize, pixelsize, 7);
    };
}

void Circle(tempColor, tempSize) {
    this.c = tempColor
    this.xpos = random(width);
    this.ypos = random(height);
    this.shapesize = tempSize;
    this.shapeover = false;
    this.locked = false;
    this.xoffset = 0;
    this.yoffset = 0;
    ellipseMode(RADIUS);
 
    this.show = function() {
        var pixelsize = this.shapesize * DPI;

 		if (dist(mouseX, mouseY, this.xpos, this.ypos) <= pixelsize) {
            this.shapeover = true;
            fill(255);
            if (mousePressed && this.shapeover == true) {
                stroke(200, 79, 100);
                strokeWeight(5);
            } else {
                noStroke();
            }
        } else {
            this.shapeover = false;
            noStroke();
            fill(this.c.r, this.c.g, this.c.b);
        }
        ellipse(this.xpos, this.ypos, pixelsize, pixelsize);
    };
}
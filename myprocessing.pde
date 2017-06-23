var shapes = [];
var shapesLocked = false;
 
void setup() {
    // createCanvas(displayWidth,displayHeight);
    size(1300, 700);
    for (var i = 0; i < 3; i++) {
        shapes.push(new Box(random(255), random(10, 100)));
    }
    for (var i = 0; i < 3; i++) {
        shapes.push(new Circle(random(255), random(10, 30)));
    }
}
 
void draw() {
    background(0, 200, 200);
    for (var i = 0; i < shapes.length; i++) {
        shapes[i].show();
    }
}
 
void mousePressed() {
	if (!shapesLocked) {
    for (var i = 0; i < shapes.length; i++) {
        if (shapes[i].shapeover == true) {
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

boolean createNewShape(type, size, color) {
	if (type != null && size > 0) {
		switch(type) {
			case 'circle':
			var newcircle = new Circle(random(255), size);
			shapes.push(newcircle);
			return true;
			case 'square':
			var newbox = new Box(random(255), size / 2);
			shapes.push(newbox);
			return true;
			case 'triangle':
			//create tri, no tri func yet
			break;
		}
	}
	return false;
}
 
void Box(tempColor, tempSize) {
    this.c = tempColor
    this.xpos = random(width);
    this.ypos = random(height);
    console.log(tempSize);
    this.shapesize = tempSize;
    this.shapeover = false;
    this.locked = false;
    this.xoffset = 0;
    this.yoffset = 0;
    rectMode(RADIUS);
 
    this.show = function() {
 
        if (mouseX > this.xpos - this.shapesize && mouseX < this.xpos + this.shapesize &&
            mouseY > this.ypos - this.shapesize && mouseY < this.ypos + this.shapesize) {
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
            fill(this.c);
        }
        rect(this.xpos, this.ypos, this.shapesize, this.shapesize, 7);
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
 		if (dist(mouseX, mouseY, this.xpos, this.ypos) <= this.shapesize) {
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
            fill(this.c);
        }
        ellipse(this.xpos, this.ypos, this.shapesize, this.shapesize);
    };
}
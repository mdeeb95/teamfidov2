var shapes = [];
var lines = [];
var currentLevelNum = 1;
var levels = [];
var clicks = [];
var DPI = 110;
var shapesLocked = false;

var settingSequence = false;
var targetSequenceLength = 3;
var targetSequence = [];
var expectedShapeIndex = -1;

var gridOn = false;
var numGridRows = 0;
var numGridCols = 0;
var gridColor = "";
 
void setup() {
    //initializing basic processing canvas, and create an empty Level object to push to the Levels array
    size(screen.width, screen.height);
    var startinglevel = new Level(shapes, currentLevelNum);
    levels.push(startinglevel);
}
 
void draw() {
    //draw is called constantly and renders what is shown on the canvas
    background(0, 0, 0);
    for (var i = 0; i < shapes.length; i++) {
        shapes[i].show();
    }
    if (gridOn) {
        Line(gridColor, numGridRows, numGridCols);
    }
}
 
void mousePressed() {
    //detection for mouseover logic and mouse pressing logic, allows user to drag around a circle
    if (!shapesLocked) {
        var shapesover = [];
        for (var i = 0; i < shapes.length; i++) {
            if (shapes[i].shapeover == true) {
                shapesover.push(shapes[i]);
                shapes[i].locked = true;
                print("mouse is pressed");
                if (settingSequence && targetSequence.length < targetSequenceLength) {
                    if (targetSequence.indexOf(shapes[i]) === -1) {
                        targetSequence.push(shapes[i]);
                    }
                    console.log(targetSequence);
                }
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
        for (var i = 0; i < shapes.length; i++) {
            if (shapes[i].shapeover == true) {
                var expectedShape = targetSequence[expectedShapeIndex];
                if (expectedShape === shapes[i]) {
                    console.log("got the right one!!!");
                    //Play a sound when the correct shape is detected
                    var audioElement = document.createElement('audio');
                    audioElement.setAttribute('src', 'tap-crisp.mp3');
                    audioElement.play();
                    if (expectedShapeIndex === (targetSequence.length - 1)) {
                        unlockShapes();
                    } else {
                        expectedShapeIndex++;
                    }
                }
            }
        }
    }
    console.log("mousex: "+mouseX+" mouseY: "+mouseY);
    return false;
}
 
void mouseDragged() {
    //doing logic for movements between screen draws, this way processing knows how far to move the circle as the user drags
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


//helper functions to prevent the shapes from being moved/allow movement
void lockShapes() {
    if (!shapesLocked) {
    	shapesLocked = true;
        gridOn = false;
        if (targetSequence.length > 0) {
            expectedShapeIndex = 0;
        }
        console.log("shapes are now locked");
    }
}

void unlockShapes() {
    if (shapesLocked) {
        shapesLocked = false;
        console.log("shapes are now unlocked");
        gridOn = true;
    }
}

//debugging function to log the shapes variable into the console
void logShapes() {
    console.log(shapes);
    console.log(clicks);
}

void updateDPI(screensize) {
    DPI = sqrt(sq(screen.width) + sq(screen.height)) / screensize;
}

void setTargetSequenceLength(length) {
    targetSequenceLength = length;
    console.log(targetSequenceLength);
}

//push the current level onto the levels stack
void saveCurrentLevel() {
    var currentLevel = levels[currentLevelNum];
    currentLevel.shapes = shapes;
    console.log(levels[currentLevelNum]);
}

//load the level from the levels stack into the canvas, also logs them into the console for debugging
void loadLevel(levelNumber) {
    var loaded = levels[levelNumber - 1];
    console.log(loaded);
    shapes = loaded.shapes;
    console.log(shapes);
}

void makeNewLevel() {
    var newshapes = [];
    shapes = newshapes;
    var newlevel = new Level(newshapes, currentLevelNum + 1);
    currentLevelNum++;
    console.log(newlevel);
    levels.push(newlevel);
    return currentLevelNum;
}

void setTargetSequence() {
    settingSequence = true;
    console.log(settingSequence);
}

void endSetTargetSequence() {
    settingSequence = false;
    console.log(settingSequence);
}

//long switch, basically just takes vars from the bootstrap modal and creates new objects and pushes them into the current shapes object
boolean createNewShape(type, size, color, xCoord, yCoord) {
    console.log(color);
	if (type != null && size > 0) {
		switch(type) {
			case 'circle':
			var newcircle = new Circle(color, size / 2, xCoord, yCoord);
			shapes.push(newcircle);
			return true;
			case 'square':
			var newbox = new Box(color, size / 2, xCoord, yCoord);
			shapes.push(newbox);
			return true;
			case 'triangle':
            var newTriangle = new Triangle(color, size, xCoord, yCoord);
            shapes.push(newTriangle);
            return true;
			break;
		}
        saveCurrentLevel();
	}
	return false;
}

boolean createNewGrid(color, numRows, numColumns, populate) {
    gridOn = true;
    numGridRows = numRows;
    numGridCols = numColumns;
    gridColor = color;
    if (populate) {
        shapes = [];
        for (i = 0; i < numRows; i++) {
            for (j = 0; j < numColumns; j++) {
                var randomColor = "#000000".replace(/0/g,function(){return (~~(Math.random()*16)).toString(16);});
                randomColor = hexToRgb(randomColor);
                createNewShape('circle', 2, randomColor, (screen.width / numColumns * j + screen.width / numColumns / 2), (screen.height / numRows * i + screen.height / numRows / 2));
            }
        }
    }
    return true;
}

//mostly objects located below, shouldn't be doing a lot other than storing variables and helping with rendering functions
void Level(levelshapes, number) {
    this.shapes = levelshapes;
    this.number = number;
}

void ScreenPress(x, y, clickedshapes) {
    this.x = x;
    this.y = y;
    this.hour = hour();
    this.minute = minute();
    this.second = second();
    this.clickedshapes = clickedshapes;
}

void fullscreen() {
    size(screen.width, screen.height);
}
 
void Box(tempColor, tempSize, xCoord, yCoord) {
    this.c = tempColor;
    this.xpos = xCoord;
    this.ypos = yCoord;
    this.shapesize = tempSize;
    this.shapeover = false;
    this.locked = false;
    this.xoffset = 0;
    this.yoffset = 0;
    rectMode(RADIUS);
 
    this.show = function() {
        var pixelsize = this.shapesize * DPI;
 
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

void Circle(tempColor, tempSize, xCoord, yCoord) {
    this.c = tempColor;
    this.xpos = xCoord;
    this.ypos = yCoord;
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

void Line(tempColor, numRows, numColumns) {
    //this.c = tempColor
    var numrows = numRows;
    var numcolumns = numColumns;
    var screenWidth = screen.width;
    var screenHeight = screen.height;
    float rowOffset = screenHeight/numrows;
    float colOffset = screenWidth/numcolumns;

    stroke(gridColor.r, gridColor.g, gridColor.b);
        for (int i = 0; i < numrows - 1; i = i+1) {
            //stroke(tempColor.r, tempColor.g, tempColor.b);
            line(0, 0+(rowOffset*(i+1)), screen.width, 0+(rowOffset*(i+1)));  
        }
        for (int i = 0; i < numcolumns - 1; i = i+1) {
            //stroke(255,255,255);
            line(0+(colOffset*(i+1)), 0, 0+(colOffset*(i+1)), screen.height); 
            //stroke(tempColor.r, tempColor.g, tempColor.b); 
            //stroke(255,255,255);
        }
    //};
}

void Triangle(tempColor, tempSize, xCoord, yCoord) {
    this.c = tempColor;
    this.xpos = parseFloat(xCoord);
    this.ypos = parseFloat(yCoord);
    this.shapesize = tempSize;
    this.shapeover = false;
    this.locked = false;
    this.xoffset = 0;
    this.yoffset = 0;
 
    this.show = function() {
        var pixelsize = this.shapesize * DPI;
        var height = (sqrt(3)/2)*pixelsize;
        //console.log("height: " + height);
        var centerTriangle = height/3;
        //console.log("centerTriangle: " + centerTriangle);
 
        if (dist(mouseX, mouseY, this.xpos, this.ypos) <= centerTriangle) {
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
        triangle((this.xpos - (pixelsize/2)), (this.ypos + centerTriangle), this.xpos, (this.ypos - (2*centerTriangle)), (this.xpos + (pixelsize/2)), this.ypos + centerTriangle);
    };
}

void getClicks() {
    return clicks;
}

void exportData(args) {
    var result, ctr, keys, columnDelimiter, lineDelimiter, data;
    
    data = args.data || null;
    if (data == null || !data.length) {
        return null;
    }

    columnDelimiter = args.columnDelimiter || ",";
    lineDelimiter = args.lineDelimiter || "\n";

    keys = Object.keys(data[0]);

    result = '';
    result += keys.join(columnDelimiter);
    result += lineDelimiter;

    data.forEach(function(item) {
        ctr = 0;
        keys.forEach(function(key) {
            if (ctr > 0) result += columnDelimiter;

            result += item[key];
            ctr++;
        });
        result += lineDelimiter;
    });

    return result;
}

void downloadCSV(args) { 
    processingInstance = Processing.getInstanceById('mainCanvas');
    var data, filename, link;
    var csv = exportData({
        data: clicks
    });
    if (csv == null) return;

    filename = args.filename || 'result.csv';

    if (!csv.match(/^data:text\/csv/i)) {
        csv = 'data:text/csv;charset=utf-8,' + csv;
    }
    data = encodeURI(csv);

    link = document.createElement('a');
    link.setAttribute('href', data);
    link.setAttribute('download', filename);
    link.click();
}
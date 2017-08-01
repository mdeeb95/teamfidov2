var processingInstance;

function downloadCSV(args) {
    processingInstance = Processing.getInstanceById('mainCanvas');
    processingInstance.downloadCSV(args);
}

function lockShapes() {
	processingInstance = Processing.getInstanceById('mainCanvas');
	processingInstance.lockShapes();
}

function unlockShapes() {
	processingInstance = Processing.getInstanceById('mainCanvas');
	processingInstance.unlockShapes();
}

function setTargetSequence() {
	processingInstance = Processing.getInstanceById('mainCanvas');
	processingInstance.setTargetSequence();

	var done_button = document.getElementById('sequence-set-end');
	console.log(done_button);
	done_button.style.display = 'inline';

	var start_button = document.getElementById('sequence-set-start');
	console.log(start_button);
	start_button.style.display = 'none';
}

function endSetTargetSequence() {
	processingInstance = Processing.getInstanceById('mainCanvas');
	processingInstance.endSetTargetSequence();

	var done_button = document.getElementById('sequence-set-end');
	console.log(done_button);
	done_button.style.display = 'none';

	var start_button = document.getElementById('sequence-set-start');
	console.log(start_button);
	start_button.style.display = 'inline';
}

function logShapes() {
    processingInstance = Processing.getInstanceById('mainCanvas');
    processingInstance.logShapes();
}

function createShape() {
	processingInstance = Processing.getInstanceById('mainCanvas');
	var color = $('#cp11').colorpicker('getValue');
    var xCoord = $("#Xcoordinate").val();
    var yCoord = $("#Ycoordinate").val();
	var rgb = hexToRgb(color);
	var created = processingInstance.createNewShape($("#newshapetype").val(), $("#newshapesize").val(), rgb, xCoord, yCoord);
	if (created) {
		$('#myModal').modal('toggle');
	}
}

function createGrid() {
    processingInstance = Processing.getInstanceById('mainCanvas');
    var color = $('#gridcolorpick').colorpicker('getValue');
    var numRows = $("#numRows").val();
    var numColumns = $("#numColumns").val();
    var rgb = hexToRgb(color);
    var populate = $('#populate').is(':checked');
    var created = processingInstance.createNewGrid(rgb, numRows, numColumns, populate);
    if (created) {
        $('#secondModal').modal('toggle');
    }
}

function play(){
    var audioElement = document.createElement('audio');
    audioElement.setAttribute('src', 'tap-crisp.mp3');
    audioElement.play();
}

function saveCurrentLevel() {
    processingInstance = Processing.getInstanceById('mainCanvas');
    processingInstance.saveCurrentLevel(level);
}

function makeNewLevel() {
    processingInstance = Processing.getInstanceById('mainCanvas');
    var newlevelnum = processingInstance.makeNewLevel();
    console.log(newlevelnum);
    $('#leveldropdown').append($('<option>', {
        value: newlevelnum,
        text: newlevelnum
    }));
    $('#leveldropdown').val(newlevelnum);
}

function loadLevel() {
    processingInstance = Processing.getInstanceById('mainCanvas');
    processingInstance.loadLevel($('#leveldropdown').val());
    console.log($('#leveldropdown').val());
}

function updateDPI() {
    processingInstance = Processing.getInstanceById('mainCanvas');
    processingInstance.updateDPI($("#screeninches").val());
}

function setTargetSequenceLength() {
    processingInstance = Processing.getInstanceById('mainCanvas');
    processingInstance.setTargetSequenceLength($("#target-sequence-length").val());
}

function hexToRgb(hex) {
    // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
    var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
    hex = hex.replace(shorthandRegex, function(m, r, g, b) {
        return r + r + g + g + b + b;
    });

    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
}

function addShapeModal() {
	$('#cp11').colorpicker({
		customClass: 'colorpicker-2x',
        sliders: {
            saturation: {
                maxLeft: 200,
                maxTop: 200
            },
            hue: {
                maxTop: 200
            },
        }
    });
}

function createGridModal() {
    $('#gridcolorpick').colorpicker({
        customClass: 'colorpicker-2x',
        sliders: {
            saturation: {
                maxLeft: 200,
                maxTop: 200
            },
            hue: {
                maxTop: 200
            },
        }
    });
}

function fullscreen() {
    processingInstance = Processing.getInstanceById('mainCanvas');
    processingInstance.fullscreen();
    var element = $('#mainCanvas');
    //var requestMethod = element.requestFullScreen;
    document.body.style.overflow = 'hidden';
    $('html, body').animate({
        scrollTop: $("#mainCanvas").offset().top
    },2000);
    $(document).keyup(function(e) {     
        if(e.keyCode== 27) {
            deactivateFullscreen();
        } 
    });
    $('#fullscreenModal').modal('toggle');
}

function deactivateFullscreen() {
    document.body.style.overflow = 'visible';
}

var processingInstance;

function lockToggle() {
	processingInstance = Processing.getInstanceById('mainCanvas');
	processingInstance.lockShapes();
}

function createShape() {
	processingInstance = Processing.getInstanceById('mainCanvas');
	var color = $('#cp11').colorpicker('getValue');
	var rgb = hexToRgb(color);
	var created = processingInstance.createNewShape($("#newshapetype").val(), $("#newshapesize").val(), rgb);
	if (created) {
		$('#myModal').modal('toggle');
	} else {
		console.log('didnt make the shape for some reason, probably alert user');
	}
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
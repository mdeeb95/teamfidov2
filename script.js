var processingInstance;

function lockToggle() {
	processingInstance = Processing.getInstanceById('mainCanvas');
	processingInstance.lockShapes();
}

function createShape() {
	processingInstance = Processing.getInstanceById('mainCanvas');
	var created = processingInstance.createNewShape($("#newshapetype").val(), $("#newshapesize").val());
	if (created) {
		$('#myModal').modal('toggle');
	} else {
		console.log('didnt make the shape for some reason, probably alert user');
	}
}
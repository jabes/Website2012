var PROCESSING_SCREEN_WIDTH = 0,
	PROCESSING_SCREEN_HEIGHT = 0,
	rootPages = ["work", "contact"],
	globals = {},
	pageLoadEvents = {
		workProcessingSnowflakes: function () {
			loadProcessingSketch.call(this, ["2d"], {canvas: "Canvas"});
		},
		workProcessingTerrace: function () {
			loadProcessingSketch.call(this, ["2d"], {canvas: "Canvas"}, true, true, [600, 600]);
		},
		workProcessingCursorsnake: function () {
			loadProcessingSketch.call(this, ["2d"], {canvas: "Canvas"});
		},
		workProcessingRainbowcave: function () {
			loadProcessingSketch.call(this, ["2d"], {canvas: "Canvas"});
		},
		workProcessing3dboxes: function () {
			loadProcessingSketch.call(this, ["webgl", "experimental-webgl"], {canvas: "Canvas", webgl: "WebGL"});
		}
	};

function showError(statusText, statusCode) {
	var errorContainer = $('<div>').addClass("error-container");
	$('<h1>').addClass("error-header").text("Oh fishsticks! Seems we encountered some turbulence").appendTo(errorContainer);
	if (statusCode) {
		$('<span>').addClass("error-code").text(statusCode).appendTo(errorContainer);
		errorContainer.addClass("has-error-code")
	}
	$('<span>').addClass("error-text").text(statusText).appendTo(errorContainer);
	globals.elements.pageContent.html(errorContainer);
	console.log("ERROR: " + statusText);
}

function firePageEvent(eventId) {
	eventId = $.camelCase(eventId);
	console.log("EVENT ID: " + eventId);
	if (pageLoadEvents.hasOwnProperty(eventId)) {
		pageLoadEvents[eventId].call(globals.elements.pageContent[0]);
	}
}

function changePage(pageid) {
	
	/*
	if (globals.currentPageId) {
		globals.lastPageId = globals.currentPageId;
	}
	*/

	globals.currentPageId = pageid;

	globals.elements.pageLoader.show();
	globals.elements.pageContent.load("pages/" + pageid + ".html", function (responseText, textStatus, XMLHttpRequest) {
		
		var httpErrorMessage;

		switch (XMLHttpRequest.status) {
			case 400:
				httpErrorMessage = "The HTTP request failed. Try loading the page again.";
				break;
			case 401:
				httpErrorMessage = "You are unauthorized to view this restricted page.";
				break;
			case 403:
				httpErrorMessage = "You are forbidden to view this restricted page.";
				break;
			case 404:
				httpErrorMessage = "The page you are looking for was not found.";
				break;
			case 500:
				httpErrorMessage = "We encountered a problem with our server. Try loading the page again.";
				break;
			default:
				httpErrorMessage = XMLHttpRequest.statusText;
		}

		$(window).trigger("pageChanged", XMLHttpRequest);

		console.log("CHANGE PAGE: " + pageid + " / " + XMLHttpRequest.status + " " + XMLHttpRequest.statusText);
		
		if (textStatus === "error") {
			globals.elements.pageLoader.hide();
			showError(httpErrorMessage, XMLHttpRequest.status);
		} else {
			globals.elements.pageLoader.hide();
			globals.elements.pageContent.find("[pageid]").click(function () {
				changePage($(this).attr("pageid"));
				return false;
			});
			firePageEvent(pageid);
		}

	});

	if ($.inArray(pageid, rootPages) >= 0) {
		$("nav.top-main-nav").attr("active-pageid", pageid).find("[pageid='" + pageid + "']").addClass("active").siblings().removeClass("active");
	}

	document.location.hash = pageid;
}


function updateCanvasDimensions(canvas, parent, equal, dimensions) {
	// hide canvas to prevent it from altering the dimensions of its parent
	// get dimensions from parent (the height is a bit tricky) and assign them to constants used by the pde file
	// show canvas and apply new dimensions
	canvas.hide();
	if (dimensions.length > 0) {
		PROCESSING_SCREEN_WIDTH = dimensions[0];
		PROCESSING_SCREEN_HEIGHT = dimensions[1];
	} else {
		PROCESSING_SCREEN_WIDTH = parent.width(),
		PROCESSING_SCREEN_HEIGHT = $(window).height() - parent.offset().top - parent.offset().left - globals.elements.pageFooter.height();
	}
	if (equal) {
		if (PROCESSING_SCREEN_WIDTH > PROCESSING_SCREEN_HEIGHT) {
			PROCESSING_SCREEN_WIDTH = PROCESSING_SCREEN_HEIGHT;
		} else {
			PROCESSING_SCREEN_HEIGHT = PROCESSING_SCREEN_WIDTH;
		}
	}
	canvas.show().width(PROCESSING_SCREEN_WIDTH).height(PROCESSING_SCREEN_HEIGHT);
//	canvas[0].width = PROCESSING_SCREEN_WIDTH;
//	canvas[0].height = PROCESSING_SCREEN_HEIGHT;
	console.log("PROCESSING RESIZE [" + PROCESSING_SCREEN_WIDTH + "x" + PROCESSING_SCREEN_HEIGHT + "]");
}

function unloadAllProcessingSketches() {
	var i,
		ii = Processing.instances.length;
	if (ii > 0) {
		for (i = 0; i < ii; i++) {
			Processing.instances[i].exit();
		}
	}
	console.log("PROCESSING UNLOADED " + ii + " SKETCHES");
}

function loadProcessingSketch(renderMethods, modernizrRequirements, allowWindowResizeEvent, forceEqualDimensions, arrForceDimensions, fnCallback) {
	
	var screen = $(this),
		abortMsg,
		abort = function (message) {
			showError(message);
			globals.elements.pageLoader.hide();
			console.log("PROCESSING SKETCH WAS ABORTED BECAUSE THE BROWSER IS NOT COMPATIBLE");
			return false;
		};
	
	// rearrange arguments if needed
	if (!$.isArray(arrForceDimensions)) {
		fnCallback = arrForceDimensions;
		arrForceDimensions = [];
	}

	allowWindowResizeEvent = allowWindowResizeEvent || true;
	forceEqualDimensions = forceEqualDimensions || false;
	//arrForceDimensions = arrForceDimensions || [];
	
	globals.elements.pageLoader.show();
	
	$.each(modernizrRequirements, function (index, value) {
		if (!Modernizr[index]) {
			abortMsg = value + " is not supported in your browser.";
			return false; // stop iteration
		} else {
			console.log("BROWSER SUPPORTS " + value);
		}
	});

	if (abortMsg) {
		return abort(abortMsg);
	}

	yepnope({
		load: [
			"js/processing-1.4.8.min.js",
			"//rawgit.com/Pomax/Pjs-2D-Game-Engine/master/minim.js"
		],
		complete: function (a) {
			
			var $canvas = globals.elements.pageContent.find("#processingCanvas"),
				processingSource = $canvas.attr("data-processing-sources"),
				canvas = $canvas[0],
				ctx = null;

			if (!Processing) {
				return abort("Could not find Processing library.");
			}

			//unloadAllProcessingSketches();
			
			try {
				$.each(renderMethods, function (index, value) {
					if (!ctx) {
						ctx = canvas.getContext(value);
					}
					if (!ctx) {
						console.log('CANVAS CONTEXT "' + value + '" IS NOT SUPPORTED');
					} else {
						console.log('CANVAS CONTEXT "' + value + '" IS SUPPORTED');
						return false; // stop iteration
					}
				});
			}
			catch(e) {}
			
			if (!ctx) {
				return abort("While your browser seems to support all required features, some are disabled or unavailable.");
			}

			updateCanvasDimensions($canvas, screen, forceEqualDimensions, arrForceDimensions);
			
			Processing.loadSketchFromSources(canvas, processingSource.split(" "));

			// https://processing-js.lighthouseapp.com/projects/41284/tickets/1887
			var timer = 0,
				timeout = 3000,
				interval = 10,
				mem = setInterval(function () {
					var sketch = Processing.getInstanceById("processingCanvas");
					if (sketch) {
						console.log("SKETCH HAS LOADED");
						globals.elements.pageLoader.hide();
						updateCanvasDimensions($canvas, screen, forceEqualDimensions, arrForceDimensions);
						clearInterval(mem);
						if (fnCallback) {
							fnCallback(sketch);
						}
					} else {
						timer += interval;
						if (timer > timeout) {
							console.log("FAILED TO LOAD SKETCH");
							clearInterval(mem);
						}
					}
				}, interval);

			// this may fire twice and it is not a bug
			// it depends on how the browser implements the resize event
			$(window).off("resize");
			console.log("ALLOW WINDOW RESIZE EVENT: " + allowWindowResizeEvent);
			if (allowWindowResizeEvent) {
				$(window).on("resize", function () {
					//firePageEvent(globals.currentPageId);
					//changePage(globals.currentPageId);
					updateCanvasDimensions($canvas, screen, forceEqualDimensions, arrForceDimensions);
				});
			}

			//$(window).off("pageChanged").on("pageChanged", unloadAllProcessingSketches);
			$(window).on("pageChanged", unloadAllProcessingSketches);
			
		}
	});

}


$(document).ready(function () {

	globals.elements = {};
	globals.elements.pageLoader = $("#pageLoader");
	globals.elements.pageContent = $("#pageContent");
	globals.elements.pageFooter = $("#pageFooter");

	$("[pageid]").click(function () {
		changePage($(this).attr("pageid"));
		return false;
	});

	if (document.location.hash) {
		changePage(document.location.hash.substring(1));
	} else {
		//changePage("articles");
		changePage("work");
	}

});


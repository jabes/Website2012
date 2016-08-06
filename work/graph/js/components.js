/*global $, Raphael, Modernizr, json_parse, window, document */

var	chart, // flot object
	chartdata,
	datafiles = {
		statsData: "data/getSiteStats.php",
		statsHtml: "data/getSiteStatsHtml.php"
	},
	chartOptions = {
		series: {
			lines: {
				show: true,
				lineWidth: 3,
				fill: true,
				fillColor: "rgba(50,155,185, 0.2)"
			},
			points: {
				show: true,
				radius: 6,
				fill: true,
				fillColor: "rgb(50,155,185)"
			},
			shadowSize: 0,
			color: "rgb(50,155,185)"
		},
		legend: {
			show: false
		},
		grid: {
			borderWidth: 1,
			hoverable: true,
			color: "#309DBA",
			backgroundColor: "#FFF",
			labelMargin: 20
		},
		xaxis: {
			mode: "time",
			timeformat: "%b %d",
			position: "bottom"
		},
		yaxis: {
			position: "right"
		}
	},

	globalInfo = {},
	globalElements = {},
	reloadInterval = 0;






// THIS FUNCTION WILL DRAW A CORNER-ROUNDED TOOLTIP WITH THE POINTER IN ANY 4 DIRECTIONS
function getTooltipSvgPathData(width, height, cornerRadius, pointerDirection, pointerWidth, pointerHeight, margin) {

	'use strict';

	width = width || 0; // width of bubble in pixels
	height = height || 0; // height of bubble in pixels
	cornerRadius = cornerRadius || 0; // radius of bubble corners in pixels
	pointerDirection = pointerDirection || ""; // direction of pointer (tail) [top, right, bottom, left]
	pointerWidth = pointerWidth || 0; // width of pointer (tail) in pixels
	pointerHeight = pointerHeight || 0; // height of pointer (tail) in pixels
	margin = margin || 0; // margin between box and canvas edges in pixels

	var pathData = "", // SVG 1.1 path data as string
		halfWidth = width / 2,
		halfHeight = height / 2,
		padding = {}; // padding is the extra distance required by the canvas in order to fit the pointer (tail)

	// SET EXPECTED PADDING
	padding.top = (pointerDirection === "top") ? margin + pointerHeight : margin;
	padding.right = (pointerDirection === "right") ? margin + pointerWidth : margin;
	padding.bottom = (pointerDirection === "bottom") ? margin + pointerHeight : margin;
	padding.left = (pointerDirection === "left") ? margin + pointerWidth : margin;

	// CALCULATE THE PATH
	pathData = "M" + (padding.left + cornerRadius) + "," + padding.top;
	if (pointerDirection === "top") {
		pathData += " H" + (halfWidth - pointerWidth);
		pathData += " L" + halfWidth + "," + margin;
		pathData += " L" + (halfWidth + pointerWidth) + "," + padding.top;
	}
	pathData += " H" + (width - padding.right - cornerRadius);
	pathData += " Q" + (width - padding.right) + "," + padding.top + "," + (width - padding.right) + "," + (padding.top + cornerRadius);
	if (pointerDirection === "right") {
		pathData += " V" + (halfHeight - pointerHeight);
		pathData += " L" + (width - margin) + "," + halfHeight;
		pathData += " L" + (width - padding.right) + "," + (halfHeight + pointerHeight);
	}
	pathData += " V" + (height - padding.bottom - cornerRadius);
	pathData += " Q" + (width - padding.right) + "," + (height - padding.bottom) + "," + (width  - padding.right - cornerRadius) + "," + (height - padding.bottom);
	if (pointerDirection === "bottom") {
		pathData += " H" + (halfWidth + pointerWidth);
		pathData += " L" + halfWidth + "," + (height - margin);
		pathData += " L" + (halfWidth - pointerWidth) + "," + (height - padding.bottom);
	}
	pathData += " H" + (padding.left + cornerRadius);
	pathData += " Q" + padding.left + "," + (height - padding.bottom) + "," + padding.left + "," + (height - padding.bottom - cornerRadius);
	if (pointerDirection === "left") {
		pathData += " V" + (halfHeight + pointerHeight);
		pathData += " L" + margin + "," + halfHeight;
		pathData += " L" + padding.left + "," + (halfHeight - pointerHeight);
	}
	pathData += " V" + (padding.top + cornerRadius);
	pathData += " Q" + padding.left + "," + padding.top + "," + (padding.left + cornerRadius) + "," + padding.top;
	pathData += " Z";

	return pathData;

}


$.fn.repositionTooltip = function (custom) {

	'use strict';

	var settings = {
			cornerRadius: 5,
			pointerHeight: 5,
			pointerWidth: 5,
			tooltipMarginY: 10, // offset from dot
			offsetTop: 0, // distance from plot point to the top edge of its chart
			offsetLeft: 0, // distance from plot point to the left edge of its chart
			direction: "bottom"
		},

		background = this.find(".background").empty(),

		width = this.width(),
		height = this.height(),

		pathData,

		chartHolderOffset = chart.getPlaceholder().offset(),
		
		tooltipOffset;


	$.extend(settings, custom);

	tooltipOffset = {
		top: chartHolderOffset.top + settings.offsetTop - height - settings.tooltipMarginY,
		left: chartHolderOffset.left + settings.offsetLeft - (width / 2)
	};
	
	// CHECK IF THE TOOLTIP HAS ENOUGH ROOM
	if (tooltipOffset.top < 0) {
		this.addClass("upside-down");
		settings.direction = "top";
		tooltipOffset.top = chartHolderOffset.top + settings.offsetTop + settings.tooltipMarginY;
	} else {
		this.removeClass("upside-down");
	}

	pathData = getTooltipSvgPathData(width, height, settings.cornerRadius, settings.direction, settings.pointerWidth, settings.pointerHeight);

	// BUILD THE TOOLTIP CANVAS BACKGROUND
	new Raphael(background[0], width, height).path(pathData).attr({
		"fill": this.bgCanvasColor,
		"stroke": "none"
	});

	// POSITION THE TOOLTIP AND DISPLAY IT
	return this.css(tooltipOffset);

};



function getTodayPlotOffset(arrPlots) {

	'use strict';

	var pointOffset = null;

	$.each(arrPlots, function (index, value) {
		if (value[0] === globalInfo.dateToday) {
			pointOffset = chart.pointOffset({
				x: value[0],
				y: value[1]
			});
			return false; // break loop
		}
	});

	return pointOffset;

}


function destroyGraph() {


	'use strict';

	console.log("Graph Destroy");


	if (chart) {

		chart.shutdown();
		chart.getPlaceholder().empty().removeAttr("style");

		// CLEAR STAT TOOLTIP
		window.clearTimeout(globalElements.statTooltip.aniDelay);
		delete globalElements.statTooltip.aniDelay;
		globalElements.statTooltip.removeAttr("style").hide();

		// CLEAR TODAY TOOLTIP
		window.clearTimeout(globalElements.todayTooltip.aniDelay);
		delete globalElements.todayTooltip.aniDelay;
		globalElements.todayTooltip.removeAttr("style").hide();

		// CLEAR NEW TOOLTIP
		window.clearTimeout(globalElements.newTooltip.aniDelay);
		delete globalElements.newTooltip.aniDelay;
		globalElements.newTooltip.removeAttr("style").hide();

	}

}

function destroyAllGraphs() {

	'use strict';

	globalElements.pages.each(function () {
		destroyGraph($(this));
	});


}

function drawGraph(page) {


	'use strict';

	console.log("Graph Draw");

	var elements = {},

		arrPlots = [], // contains numerical values of x and y coordinates
		arrChartData = [], // contains arrays of graph plot points (x/y coordinates)
		arrTooltipData = [], // contains objects of data used in the graph tooltip

		previousPoint = null, // used to determine "dot hover event" during "graph hover event"

		yPlotFocus, // used to determine what data points should be plotted on the y axis
		pointOffset; // used to determine todays plot point so we know were to position the tooltips


	elements.statHolder = page.find(".chart");
	elements.chartDataTable = page.find(".chartData");
	elements.chartBubbleInfo = page.find(".chartBubbleInfo");


	yPlotFocus = elements.chartDataTable.attr("plot");


	// cycle the table and pull data for our graph
	elements.chartDataTable.find("tbody tr").each(function () {

		var rowCols = $(this).find("td"),
			xPlot = parseFloat(rowCols.filter(".timestamp").text()), // used to determine the horizontal axis data point
			yPlot, // used to determine the vertical axis data point
			data = {}; // used to store the data points

		rowCols.each(function () {
			var value = $(this).text();
			// convert strings that are numbers into floats
			if (!isNaN(value)) {
				value = parseFloat(value);
			}
			data[$(this).attr('class')] = value;
		});

		yPlot = data[yPlotFocus];

		arrTooltipData.push(data);
		arrPlots.push([xPlot, yPlot]);

	});

	if (arrPlots.length > 0) {
		arrChartData.push(arrPlots);
	}


	if (arrChartData.length > 0) {
		chart = $.plot(elements.statHolder, arrChartData, chartOptions);
	}



	pointOffset = getTodayPlotOffset(arrPlots);


	// MANAGE TOOLTIPS
	if (globalInfo.plotValueDiff > 0) {

		globalElements.newTooltip.repositionTooltip({
			offsetTop: pointOffset.top,
			offsetLeft: pointOffset.left
		}).fadeIn(500).find(".content").html(globalInfo.plotValueDiff + " NEW");

		globalElements.newTooltip.aniDelay = window.setTimeout(function () {

			window.clearTimeout(globalElements.newTooltip.aniDelay);
			delete globalElements.newTooltip.aniDelay;

			globalElements.newTooltip.fadeOut(500, function () {

				if (globalInfo.allowTodayTooltip) {
					globalElements.todayTooltip.repositionTooltip({
						offsetTop: pointOffset.top,
						offsetLeft: pointOffset.left
					}).fadeIn(500);
				}

			});

		}, 2000);

		delete globalInfo.plotValueDiff;

	} else {

		// CALCULATE TODAY BUBBLE
		if (globalInfo.allowTodayTooltip) {
			globalElements.todayTooltip.repositionTooltip({
				offsetTop: pointOffset.top,
				offsetLeft: pointOffset.left
			}).show();
		}

	}



	// MANAGE CHART HOVER EVENT AND TOOLTIP DISPLAY
	elements.statHolder.bind("plothover", function (event, pos, item) {

		var chartHolderOffset = $(this).offset();

		if (item) {

			if (previousPoint !== item.dataIndex) {

				previousPoint = item.dataIndex;

				// INSERT CONTENT TEMPLATE INTO TOOLTIP
				globalElements.statTooltip.find(".content").html(elements.chartBubbleInfo.html());

				// INSERT VALUES INTO OUR TOOLTIP CONTENT TEMPLATE
				$.each(arrTooltipData[item.dataIndex], function (index, value) {
					globalElements.statTooltip.find("[data='" + index + "']").append(value);
				});

				// POSITION THE STAT TOOLTIP AND DISPLAY IT
				window.clearTimeout(globalElements.statTooltip.aniDelay);
				delete globalElements.statTooltip.aniDelay;


				globalElements.statTooltip.repositionTooltip({
					offsetTop: item.pageY - chartHolderOffset.top,
					offsetLeft: item.pageX - chartHolderOffset.left,
					cornerRadius: 8,
					pointerHeight: 8,
					pointerWidth: 8,
					tooltipMarginY: 18 // offset from dot
				}).stop(true, true).fadeIn(500);


				// HIDE TODAY TOOLTIP
				if (globalElements.todayTooltip.aniDelay) {
					window.clearTimeout(globalElements.todayTooltip.aniDelay);
					delete globalElements.todayTooltip.aniDelay;
					globalElements.todayTooltip.stop(true, true).fadeOut(500);
				}

				// HIDE NEW TOOLTIP
				if (globalElements.newTooltip.aniDelay) {
					window.clearTimeout(globalElements.newTooltip.aniDelay);
					delete globalElements.newTooltip.aniDelay;
					globalElements.newTooltip.stop(true, true).fadeOut(500);
				}

			}

		} else {

			// HOVER OUT = SHOW DEFAULT TOOLTIP TODAY (IF ELIGIBLE)

			previousPoint = null;

			// prevent setting a million timeouts
			if (!globalElements.statTooltip.aniDelay) {
				globalElements.statTooltip.aniDelay = window.setTimeout(function () {
					globalElements.statTooltip.fadeOut(500);
				}, 400);
			}

			// prevent setting a million timeouts
			if (!globalElements.todayTooltip.aniDelay) {
				globalElements.todayTooltip.aniDelay = window.setTimeout(function () {
					if (globalInfo.allowTodayTooltip) {
						globalElements.todayTooltip.fadeIn(500);
					}
				}, 800);
			}

		}

	});




}


function clearReloadGraph() {

	'use strict';

	if (globalInfo.memindex) {
		window.clearTimeout(globalInfo.memindex);
		delete globalInfo.memindex;
	}
}

function setReloadGraph() {

	'use strict';

	if (reloadInterval > 0) {
		globalInfo.memindex = window.setTimeout(reloadGraph, reloadInterval);
	}
}

function getDataPointDiff(todaysDataObject) {

	'use strict';

	var yPlotFocus = globalElements.pages.filter(".active").find(".chartData").attr("plot"),
		currPlotValue = parseFloat(globalInfo.todaysDataObject[yPlotFocus]),
		newPlotValue = parseFloat(todaysDataObject[yPlotFocus]);

	// when the graph is redrawn, we use this value to determine if we show the new data tooltip or not
	globalInfo.plotValueDiff = (newPlotValue - currPlotValue);

	console.log(currPlotValue, newPlotValue, globalInfo.plotValueDiff);



}


function reloadPageVars(data) {

	'use strict';

	if (data) {

		var dataobj = json_parse(data),
			key,
			keys = [],
			todaysDataObject = dataobj[globalInfo.dateTodayFormatted];


		for (key in dataobj) {
			keys.push(key);
		}

		if (globalInfo.todaysDataObject && todaysDataObject) {
			getDataPointDiff(todaysDataObject);
		}

		globalInfo.todaysDataObject = todaysDataObject;


		// DETERMINE IF WE CAN SHOW THE TODAY TOOLTIP BASED ON NEW DATE TIMES
		globalInfo.dateFirstCalDay = new Date(keys[0]).getTime();
		globalInfo.dateLastCalDay = new Date(keys[keys.length - 1]).getTime();
		globalInfo.allowTodayTooltip = (globalInfo.dateToday > globalInfo.dateFirstCalDay && globalInfo.dateToday < globalInfo.dateLastCalDay);


		console.log(globalInfo.dateFirstCalDay, globalInfo.dateLastCalDay, globalInfo.dateToday);

	}


}





function reloadGraph(page) {

	'use strict';

	console.log("Reload Data");

	clearReloadGraph();

	$.get(datafiles.statsData + globalInfo.dateFilter, function (data) {

		var currPageIndex,
			newPageIndex,
			currPage,
			newPage;

		if (chartdata !== data) {

			chartdata = data;

			reloadPageVars(chartdata);

			// has any relevant data changed?
			if (globalInfo.plotValueDiff > 0) {

				$.post(datafiles.statsHtml, { stats: chartdata }, function (data) {

					currPageIndex = globalElements.pages.filter(".active").index();
					newPageIndex = (page) ? page.index() : currPageIndex;

					globalElements.contentpane.html(data).removeClass("loading");
					globalElements.pages = globalElements.contentpane.find(".page");

					currPage = globalElements.pages.eq(currPageIndex);
					newPage = globalElements.pages.eq(newPageIndex).addClass("active");

					destroyGraph(currPage);
					drawGraph(newPage);

				});

			}

		}

		setReloadGraph();

	});

}








$(document).ready(function () {

	'use strict';

	var clickMethod = (Modernizr.touch) ? "touchend" : "click";

	globalElements.statTooltip = $("#statTooltip");
	globalElements.todayTooltip = $("#todayTooltip");
	globalElements.newTooltip = $("#newTooltip");
	globalElements.contentpane = $("#contentpane");


	globalInfo.dateToday = parseFloat($("#globalChartInfo [name='dateToday']").val());
	globalInfo.dateTodayFormatted = $("#globalChartInfo [name='dateTodayFormatted']").val();
	globalInfo.dateFilter = "";

	// define tooltip background color
	globalElements.statTooltip.bgCanvasColor = "#12343E";
	globalElements.todayTooltip.bgCanvasColor = "#12343E";
	globalElements.newTooltip.bgCanvasColor = "#65af22";
	

	// STOP VIEWPORT FROM MOVING WHEN TOUCHED IN MOBILE DEVICE
	$("body").bind("touchmove", function () {
		return false;
	});

	$(window).resize(function () {

		var currPage = globalElements.pages.filter(".active");
		destroyGraph(currPage);
		drawGraph(currPage);

	});

	// DRAW SOME FANCY CANVAS BACKGROUNDS FOR OUR STAT NAV ON THE LEFT
	$("#statisticNav li").each(function () {

		var width = $(this).width(),
			height = $(this).height(),
			pointerWidth = 20,
			navBG = $('<span class="nav-bg"></span>').appendTo(this),
			pathData = "M 0 0 H " + width + " L " + (width + pointerWidth) + " " + (height / 2) + " L " + width + " " + height + " H 0 Z";

		new Raphael(navBG[0], width + pointerWidth, height).path(pathData).attr({
			"fill": "250-#53BEDE-#319CBC",
			"stroke": "none"
		});

		$(this).bind(clickMethod, function () {

			// set active states that will define our current visible chart
			$(this).addClass("active").siblings().removeClass("active");

			var currPage = globalElements.pages.filter(".active"),
				newPage = globalElements.pages.removeClass("active").filter("[page='" + $(this).attr("call") + "']").addClass("active");

			destroyGraph(currPage);
			drawGraph(newPage);

		});

	});

	// DATE FILTER CHANGE
	$("select[name='filterDate']").change(function () {
		globalInfo.dateFilter = "?date=" + $(this).val();
		globalElements.contentpane.addClass("loading");
		destroyAllGraphs();
		reloadGraph();
	});

	// RELOAD FILTER CHANGE
	$("select[name='filterReload']").change(function () {
		reloadInterval = $(this).val();
		clearReloadGraph();
		setReloadGraph();
	}).trigger("change");


	// INITIAL RUN
	$.get(datafiles.statsData + globalInfo.dateFilter, function (data) {

		chartdata = data;
		reloadPageVars(chartdata);

		$.post(datafiles.statsHtml, { stats: chartdata }, function (data) {

			globalElements.contentpane.html(data).removeClass("loading");
			globalElements.pages = globalElements.contentpane.find(".page");
			$("#statisticNav li:first").trigger(clickMethod);

			setReloadGraph();

		});



	});



});






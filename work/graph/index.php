<?php

require_once(dirname(__FILE__) . "/php/config.php");
require_once(dirname(__FILE__) . "/php/functions.php");

if (EMMA_DEVMODE) {
	header("content-type:text");
	exit;
}

?><!doctype html><html><head>
	
	<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style" content="default" />
	<meta name="viewport" content="width=device-width, minimum-scale=1, maximum-scale=1, user-scalable=no" />
	
	<title>Pinup Reports</title>
	
	<link href="<?php echo $BASEURL; ?>/images/favicon.ico" type="image/x-icon" rel="shortcut icon" />
	<link href="<?php echo $BASEURL; ?>/css/basic.css" type="text/css" rel="stylesheet" />
	<link href="<?php echo $BASEURL; ?>/css/charts.css" type="text/css" rel="stylesheet" />
	
	<script type="text/javascript" src="<?php echo $BASEURL; ?>/js/jquery.min.js"></script>
	<script type="text/javascript" src="<?php echo $BASEURL; ?>/js/raphael.min.js"></script>
	<script type="text/javascript" src="<?php echo $BASEURL; ?>/js/jquery.flot.min.js"></script>
	<script type="text/javascript" src="<?php echo $BASEURL; ?>/js/json_parse.js"></script>
	<script type="text/javascript" src="<?php echo $BASEURL; ?>/js/modernizr.custom.js"></script>
	<script type="text/javascript" src="<?php echo $BASEURL; ?>/js/components.js"></script>

	<!--[if lte IE 8]><script type="text/javascript" src="<?php echo $BASEURL; ?>/js/excanvas.min.js"></script><![endif]-->

</head><body>

<form id="globalChartInfo">
	<input type="text" name="dateToday" value="<?php echo strtotime("today") * 1000; ?>" />
	<input type="text" name="dateTodayFormatted" value="<?php echo date("m/d/Y"); ?>" />
</form>

<div id="statTooltip">
	<div class="content"></div>
	<div class="background"></div>
</div>

<div id="todayTooltip">
	<div class="content">TODAY</div>
	<div class="background"></div>
</div>

<div id="newTooltip">
	<div class="content">NEW</div>
	<div class="background"></div>
</div>

<div id="leftnav">
	<ul id="statisticNav">
		<li call="impressions"><span class="nav-label">Impressions</span></li>
		<li call="tags-created"><span class="nav-label">Tags Created</span></li>
		<li call="click-log"><span class="nav-label">Click Log</span></li>
		<li call="users-over-time"><span class="nav-label">Users Over Time</span></li>
		<li call="images-registered"><span class="nav-label">Images Registered</span></li>
	</ul>
</div>

<div id="chartOptions">
	
	<div class="chart-option">
		<form><label>SHOW MONTH: <select name="filterDate"><?php			
			$month = date('m');
			$year = date('Y');
			for ($i=-12; $i<1; $i++):
				$ts = mktime(0, 0, 0, $month-$i, 1, $year);
				$monthName = date('F', $ts);
				$monthNum = date('m', $ts);
				if ($monthNum == 12) $year -= 1;
				$filterDate = "{$monthNum}{$year}";
				$filterDateDsp = "{$monthName} {$year}";
				echo '<option value="' . $filterDate . '">' . $filterDateDsp . '</option>';
			endfor;
		?></select></label></form>
	</div>

	<div class="chart-option">
		<form><label>RELOAD EVERY: <select name="filterReload">
			<option value="0">never</option>
			<option value="1000" >1 second</option>
			<option value="5000">5 seconds</option>
			<option value="10000" selected="selected">10 seconds</option>
			<option value="20000">20 seconds</option>
			<option value="30000">30 seconds</option>
			<option value="60000">1 minute</option>
			<option value="300000">5 minutes</option>
			<option value="600000">10 minutes</option>
		</select></label></form>
	</div>

</div>

<div id="contentpane" class="loading"><?php if ($stats) echo $stats; ?></div>

</body></html>
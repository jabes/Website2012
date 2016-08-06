<?php 

require_once(dirname(__FILE__) . "/../php/config.php");
require_once(dirname(__FILE__) . "/../php/functions.php");



if ($_GET['date']) {
	$filterMonth = substr($_GET['date'], 0, 2);
	$filterYear = substr($_GET['date'], 2, 4);
} else {
	$filterMonth = date("m");
	$filterYear = date("Y");
	
}

$dateFilter = "{$filterMonth}{$filterYear}";


$clickLog = dbmulti("
	SELECT 
		DATE_FORMAT(clicklog.dateClicked, '%m/%d/%Y') AS currentDate,
		SUM(CASE WHEN sites.id = clicklog.nSiteClickedFromID THEN 1 ELSE 0 END) AS outboundClicks,
		SUM(CASE WHEN sites.id = clicklog.nSiteClickedToID THEN 1 ELSE 0 END) AS inboundClicks
	FROM clicklog
	LEFT JOIN sites ON sites.id = clicklog.nSiteClickedFromID
	WHERE DATE_FORMAT(clicklog.dateClicked, '%m%Y') = '{$dateFilter}'
	GROUP BY currentDate
	ORDER BY clicklog.dateClicked ASC
");

$accessTracker = dbmulti("
	SELECT 
		DATE_FORMAT(accesstracker.dateCreated, '%m/%d/%Y') AS currentDate,
		SUM(CASE WHEN accesstracker.nAccessType = 1 THEN 1 ELSE 0 END) AS impressions,
		SUM(CASE WHEN accesstracker.nAccessType = 2 THEN 1 ELSE 0 END) AS noTags,
		SUM(CASE WHEN accesstracker.nAccessType = 3 THEN 1 ELSE 0 END) AS tagsLoaded
	FROM accesstracker
	WHERE DATE_FORMAT(accesstracker.dateCreated, '%m%Y') = '{$dateFilter}'
	GROUP BY currentDate
	ORDER BY accesstracker.dateCreated ASC
");

$tags = dbmulti("
	SELECT 
		DATE_FORMAT(tags.dateCreated, '%m/%d/%Y') AS currentDate,
		COUNT(*) AS tagsCreated
	FROM tags
	WHERE DATE_FORMAT(tags.dateCreated, '%m%Y') = '{$dateFilter}'
	GROUP BY currentDate
	ORDER BY tags.dateCreated ASC
");

$users = dbmulti("
	SELECT 
		DATE_FORMAT(accounts.dateRegistered, '%m/%d/%Y') AS currentDate,
		COUNT(*) AS accountsCreated
	FROM accounts
	WHERE DATE_FORMAT(accounts.dateRegistered, '%m%Y') = '{$dateFilter}'
	GROUP BY currentDate
	ORDER BY accounts.dateRegistered ASC
");

$regimages = dbmulti("
	SELECT 
		DATE_FORMAT(regimage.dateCreated, '%m/%d/%Y') AS currentDate,
		COUNT(*) AS newImages
	FROM regimage
	WHERE DATE_FORMAT(regimage.dateCreated, '%m%Y') = '{$dateFilter}'
	GROUP BY currentDate
	ORDER BY regimage.dateCreated ASC
");




$arrStats = array();
$firstDayInMonth = "01";

// number of days in our target month
$numberOfDays = cal_days_in_month(CAL_GREGORIAN, $filterMonth, $filterYear);
// start with first day in target month
$currentDateStr = $filterMonth . "/" . $firstDayInMonth . "/" . $filterYear;






$emptySheet = array(
	'outboundClicks' => 0,
	'inboundClicks' => 0,
	'impressions' => 0,
	'tagsLoaded' => 0,
	'noTags' => 0,
	'tagsCreated' => 0,
	'accountsCreated' => 0,
	'newImages' => 0,
);


// keep track of our current data positions
$currClick = array_shift($clickLog);
$currTracker = array_shift($accessTracker);
$currTag = array_shift($tags);
$currUser = array_shift($users);
$currImage = array_shift($regimages);






for ($i=0, $ii=$numberOfDays; $i<$ii; $i+=1) {
	
	// start off with a normalized data sheet for this day
	$stat = $emptySheet;


	if ($currentDateStr === $currClick['currentDate']) {
		
		$stat['outboundClicks'] = $currClick['outboundClicks'];
		$stat['inboundClicks'] = $currClick['inboundClicks'];

		$currClick = array_shift($clickLog);
	}

	if ($currentDateStr === $currTracker['currentDate']) {

		$stat['impressions'] = ($currTracker['impressions']>15000)?15000:$currTracker['impressions'];
		$stat['tagsLoaded'] = $currTracker['tagsLoaded'];
		$stat['noTags'] = $currTracker['noTags'];

		$currTracker = array_shift($accessTracker);
	}

	if ($currentDateStr === $currTag['currentDate']) {

		$stat['tagsCreated'] = $currTag['tagsCreated'];

		$currTag = array_shift($tags);
	}

	if ($currentDateStr === $currUser['currentDate']) {

		$stat['accountsCreated'] = $currUser['accountsCreated'];

		$currUser = array_shift($users);
	}

	if ($currentDateStr === $currImage['currentDate']) {

		$stat['newImages'] = $currImage['newImages'];

		$currImage = array_shift($regimages);
	}
	
	$arrStats[$currentDateStr] = $stat;
	
	
	$currentDateStr = date("m/d/Y", strtotime("+1day", strtotime($currentDateStr)));

}


exit(json_encode($arrStats));





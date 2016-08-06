<?php

header("content-type:text/html");
require_once dirname(__FILE__) . "/php/header.php";

try {

	$connSlave = new Connection(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB);
	$urldata = Connection::cleanData($_REQUEST);

	if ($HUB_USER_TPID) {
		$user = new User($HUB_USER_TPID);
		$arrUser = $user->retrieveData(); // query user data
	}

	$arrTagInfo = o(new Query)->select("SELECT id, strWebLink, nSitesID FROM tags WHERE tags.strGUID = '" . $urldata['u'] . "'");
	if (!$arrTagInfo) Util::quit("Not a valid url, please reload the image and try again");
	
	// analyse the destination url and format it in a way that is query friendly
	$pwl = Util::parseUrl($arrTagInfo['strWebLink']);
	if (!empty($pwl['domain']) && !empty($pwl['extension'])) {
		$scheme = !empty($pwl['scheme']) ? $pwl['scheme'] : "http";
		$subdomain = !empty($pwl['subdomain']) ? $pwl['subdomain'] : "www";
		$urlDestination = $scheme . "://" . $subdomain . "." . $pwl['domain'] . $pwl['extension'];
	}
	
	// if we succeeded in building the query friendly url, then execute the query
	if (isset($urlDestination)) {
		// if the destination url exists in the sites table, try and find the account it belongs to
		$nSiteClickedToID = o(new Query)->select("SELECT id FROM sites WHERE strURL = '{$urlDestination}'");
	}
	
	Query::insert("clicklog", array(
		'nTagClickedID' => $arrTagInfo['id'],
		'strWebLink' => $arrTagInfo['strWebLink'],
		'strWebReferer' => $HUB_REFERER,
		'strClickerIP' => $HUB_USER_IP,
		'nUserAgentsID' => User::insertAgent($HUB_USER_AGENT),
		'nAccountsID' => isset($arrUser['id']) ? $arrUser['id'] : null,
		'nSiteClickedFromID' => $arrTagInfo['nSitesID'],
		'nSiteClickedToID' => $nSiteClickedToID,
		'dateClicked' => Query::sqlfn_now,
	));

} catch (CacheException $e) {
	if (DEVMODE) print_r($e); else echo $e->getMessage();
} catch (ConnectionException $e) {
	if (DEVMODE) print_r($e); else echo $e->getMessage();
} catch (QueryException $e) {
	if (DEVMODE) print_r($e); else echo $e->getMessage();
} catch (SiteException $e) {
	if (DEVMODE) print_r($e); else echo $e->getMessage();
} catch (TrackerException $e) {
	if (DEVMODE) print_r($e); else echo $e->getMessage();
} catch (UserException $e) {
	if (DEVMODE) print_r($e); else echo $e->getMessage();
} catch (UtilException $e) {
	if (DEVMODE) print_r($e); else echo $e->getMessage();
} catch (Exception $e) {
	if (DEVMODE) print_r($e); else echo $e->getMessage();
}

if (substr($arrTagInfo['strWebLink'], 0, 4) !== "http") $arrTagInfo['strWebLink'] = "http://" . $arrTagInfo['strWebLink'];

?><!DOCTYPE html>
<html>
<head><title>Redirecting...</title><meta http-equiv="refresh" content="0;url=<?=$arrTagInfo['strWebLink']?>"></head>
<body></body>
</html>
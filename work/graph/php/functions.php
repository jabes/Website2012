<?php


if (!function_exists('json_encode')) {
	require_once dirname(__FILE__) . "/../JSON/JSON.php";
	function json_encode($arg)
	{
		global $services_json;
		if (!isset($services_json)) {
			$services_json = new Services_JSON();
		}
		return $services_json->encode($arg);
	}
}

if (!function_exists('json_decode')) {
	require_once dirname(__FILE__) . "/../JSON/JSON.php";
	function json_decode($arg)
	{
		global $services_json;
		if (!isset($services_json)) {
			$services_json = new Services_JSON();
		}
		return $services_json->decode($arg);
	}
} 




function checkMem($name) {
	global $memcache;
	if ($memcache && $name) {
		$arrData = $memcache->get(md5($name));
		if ($arrData !== false) {
			return $arrData;
		}
	}
	return false;
}

function clearMem($name) {
	global $memcache;
	if ($memcache && $name) {
		$memcache->delete(md5($name));
	}
}

function printSQL($sql, $time, $cached) {
	var_dump(trim(preg_replace("/\t/",'',$sql)));
	echo "Executed in: ".$time." seconds.".PHP_EOL."Cached: ".($cached?"yes":"no").PHP_EOL.LINE_BREAK.PHP_EOL;
}

function dbdo($sql, $bCache=false, $expiration="", $bReset=false, $mcacheName="") {

	global $slave;
	global $memcache;

	if (EMMA_DEVMODE) $startTime = microtime(true);

	// used to check if the return data was cached
	$cacheResult = false; 
	// check sql string for query method ex: "SELECT" or "INSERT"
	$queryMethod = strtoupper(implode(' ',array_slice(str_word_count($sql,2),0,1)));
	// if method is select, then check cache and grab the query return
	if ($queryMethod === "SELECT") 
	{		
		// if the memcache connection does not exist then override the cache toggle
		if (!$memcache) $bCache = false;
		// check for cached data
		if ($bCache && !$bReset) {
			$memData = checkMem($mcacheName);
			if (is_array($memData)) {
				$arrData = $memData;
				$cacheResult = true;
			}
		}
		// if not data was found in cache then do a query
		if (!isset($arrData)) 
		{ 
			// execute select query
			$result = mysql_query($sql, $slave) or die(mysql_error());
			// we only allow one row (result) in this function
			// use "dbmulti" if you want multiple rows (results)
			if (mysql_num_rows($result) === 1)
			{	
				$assoc = mysql_fetch_assoc($result);
				if (count($assoc) === 1)
				{
					$item = array_values($assoc);
					$arrData = stripslashes($item[0]);
				} 
				else foreach ($assoc as $key => $value) $arrData[$key] = stripslashes($value);
			}
			// cache the result if needed
			if (isset($arrData) && $bCache) 
			{
				$cacheRecord = md5($mcacheName);
				$memcache->delete($cacheRecord);
				$memcache->add($cacheRecord, $arrData, false, strtotime_duration($expiration));
			}
		}
	// if method is not select then just execute the query without returning a result or caching
	} else mysql_query($sql, $slave) or die(mysql_error());

	if (EMMA_DEVMODE) printSQL($sql, (microtime(true) - $startTime), $cacheResult);
	
	return (isset($arrData)) ? $arrData : NULL;

}

function dbmulti($sql, $bCache=false, $expiration, $bReset=false, $mcacheName="") {

	global $slave;
	global $memcache;
	
	if (EMMA_DEVMODE) $startTime = microtime(true);

	// used to check if the return data was cached
	$cacheResult = false; 

	// if the memcache connection does not exist then override the cache toggle
	if (!$memcache) $bCache = false;
	// check for cached data
	if ($bCache && !$bReset) {
		$memData = checkMem($mcacheName);
		if (is_array($memData)) {
			$arrData = $memData;
			$cacheResult = true;
		}
	}

	// if not data was found in cache then do a query
	if (!isset($arrData)) 
	{ 
		$result = mysql_query($sql, $slave) or die(mysql_error());	
		while ($row = mysql_fetch_assoc($result)) $arrData[] = $row;

		// cache the result if needed
		if (isset($arrData) && $bCache) 
		{
			$cacheRecord = md5($mcacheName);
			$memcache->delete($cacheRecord);
			$memcache->add($cacheRecord, $arrData, false, strtotime_duration($expiration));
		}
	}

	if (EMMA_DEVMODE) printSQL($sql, (microtime(true) - $startTime), $cacheResult);
	
	return (isset($arrData)) ? $arrData : NULL;

}

function strtotime_duration($val) {
	if (is_string($val)) {
		return strtotime($val) - strtotime('NOW');
	}
	return $val;
}







function resize($imagePath,$opts=null){

	# start configuration
	
	$cacheFolder = './cache/'; # path to your cache folder, must be writeable by web server
	$remoteFolder = $cacheFolder.'remote/'; # path to the folder you wish to download remote images into
	$quality = 90; # image quality to use for ImageMagick (0 - 100)
	
	$cache_http_minutes = 20; 	# cache downloaded http images 20 minutes

	$path_to_convert = '/usr/bin/convert'; # this could be something like /usr/bin/convert or /opt/local/share/bin/convert
	
	## you shouldn't need to configure anything else beyond this point

	$purl = parse_url($imagePath);
	$finfo = pathinfo($imagePath);
	$ext = $finfo['extension'];

	# check for remote image..
	if(isset($purl['scheme']) && $purl['scheme'] == 'http'):
		# grab the image, and cache it so we have something to work with..
		list($filename) = explode('?',$finfo['basename']);
		$local_filepath = $remoteFolder.$filename;
		$download_image = true;
		if(file_exists($local_filepath)):
			if(filemtime($local_filepath) < strtotime('+'.$cache_http_minutes.' minutes')):
				$download_image = false;
			endif;
		endif;
		if($download_image == true):
			$img = file_get_contents($imagePath);
		#print "saving: $local_filepath, $img<br>";
			$success =file_put_contents($local_filepath,$img);
			#print "success: ".$success."<BR>";
		endif;
		$imagePath = $local_filepath;
	endif;

	if(file_exists($imagePath) == false):
		$imagePath = $_SERVER['DOCUMENT_ROOT'].$imagePath;
		if(file_exists($imagePath) == false):
			return 'image not found';
		endif;
	endif;

	if(isset($opts['w'])): $w = $opts['w']; endif;
	if(isset($opts['h'])): $h = $opts['h']; endif;

	global $guid;
	$filename = md5_file($imagePath);

	$string = explode('?', $ext);
	$ext = $string[0];
	$ext = ereg_replace("\?","",$ext);

	if(!empty($w) and !empty($h)):
		$newPath = $cacheFolder.$guid.$filename.'_w'.$w.'_h'.$h.(isset($opts['crop']) && $opts['crop'] == true ? "_cp" : "").(isset($opts['scale']) && $opts['scale'] == true ? "_sc" : "").'.'.$ext;
	elseif(!empty($w)):
		$newPath = $cacheFolder.$guid.$filename.'_w'.$w.'.'.$ext;	
	elseif(!empty($h)):
		$newPath = $cacheFolder.$guid.$filename.'_h'.$h.'.'.$ext;
	else:
		return false;
	endif;

	$create = true;

	if(file_exists($newPath) == true):
		$create = false;
		$origFileTime = date("YmdHis",filemtime($imagePath));
		$newFileTime = date("YmdHis",filemtime($newPath));
		if($newFileTime < $origFileTime):
			$create = true;
		endif;
	endif;

	if($create == true):
		if(!empty($w) and !empty($h)):

			list($width,$height) = getimagesize($imagePath);
			$resize = $w;
		
			if($width > $height):
				$resize = $w;
				if(isset($opts['crop']) && $opts['crop'] == true):
					$resize = "x".$h;				
				endif;
			else:
				$resize = "x".$h;
				if(isset($opts['crop']) && $opts['crop'] == true):
					$resize = $w;
				endif;
			endif;

			if(isset($opts['scale']) && $opts['scale'] == true):
				$cmd = $path_to_convert." ".$imagePath." -resize ".$resize." -quality ".$quality." ".$newPath;
			else:
				$cmd = $path_to_convert." ".$imagePath." -resize ".$resize." -size ".$w."x".$h." xc:".(isset($opts['canvas-color'])?$opts['canvas-color']:"transparent")." +swap -gravity center -composite -quality ".$quality." ".$newPath;
			endif;
						
		else:
			$cmd = $path_to_convert." ".$imagePath." -thumbnail ".(!empty($h) ? 'x':'').$w."".(isset($opts['maxOnly']) && $opts['maxOnly'] == true ? "\>" : "")." -quality ".$quality." ".$newPath;
		endif;

		$c = exec($cmd);
		
	endif;

	# return cache file path
	return str_replace($_SERVER['DOCUMENT_ROOT'],'',$newPath);
	
}



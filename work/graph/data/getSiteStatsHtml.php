<?php

require_once(dirname(__FILE__) . "/../php/functions.php");


if ($_POST['stats']) $arrStats = json_decode($_POST['stats']);
if (!$arrStats) exit;


$totalValues = array(
	'outboundClicks' => 0,
	'inboundClicks' => 0,
	'impressions' => 0,
	'tagsLoaded' => 0,
	'noTags' => 0,
	'tagsCreated' => 0,
	'accountsCreated' => 0,
	'newImages' => 0,
);



foreach ($arrStats as $stat) {	
	foreach ($stat as $key => $val) {
		$totalValues[$key] += intval($val);
	}
}



?>


<div class="page" page="impressions">
	
	<div class="chart"></div>
	<div class="infoarea">
		<h2>Total Impressions: <?php echo $totalValues['impressions']; ?></h2>
	</div>

	<div class="chartBubbleInfo">
		<div data="impressions" class="data"><span class="label">TOTAL IMPRESSIONS:</span></div>
		<div data="tagsLoaded" class="data"><span class="label">IMAGE LOADED:</span></div>
		<div data="noTags" class="data"><span class="label">LOADED BUT NO TAGS:</span></div>
		<div data="dateFormatted" class="dateFormatted"></div>
	</div>
	
	<table class="chartData" plot="impressions">
		<thead>
			<tr>
				<th class="timestamp">Timestamp</th>
				<th class="dateFormatted">Date</th>
				<th class="impressions">Total Impressions</th>
				<th class="tagsLoaded">Total Impressions With Tags</th>
				<th class="noTags">Total Impressions With No Tags</th>
			</tr>
		</thead>
		<tbody>
			<?php
			foreach($arrStats as $date => $stat):
				$t = strtotime($date);
				$today = (strtotime("today") == $t) ? ' class="today"' : '';
			?>
			<tr<?=$today?>>
				<td class="timestamp"><?=($t * 1000)?></td>
				<td class="dateFormatted"><?=strtoupper(date("F jS, Y", $t))?></td>
				<td class="impressions"><?=$stat->impressions?></td>
				<td class="tagsLoaded"><?=$stat->tagsLoaded?></td>
				<td class="noTags"><?=$stat->noTags?></td>
			</tr>
			<?php
			endforeach;
			?>
		</tbody>
	</table>

</div><!-- END PAGE -->

<div class="page" page="tags-created">

	<div class="chart"></div>
	<div class="infoarea">
		<h2>Total Tags Created: <?php echo $totalValues['tagsCreated']; ?></h2>
	</div>

	<div class="chartBubbleInfo">
		<div data="tagsCreated" class="data"><span class="label">TAGS CREATED:</span></div>
		<div data="dateFormatted" class="dateFormatted"></div>
	</div>

	<table class="chartData" plot="tagsCreated">
		<thead>
			<tr>
				<th class="timestamp">Timestamp</th>
				<th class="dateFormatted">Date</th>
				<th class="tagsCreated">Total Tags Created</th>
			</tr>
		</thead>
		<tbody>
			<?php
			foreach($arrStats as $date => $stat):
				$t = strtotime($date);
				$today = (strtotime("today") == $t) ? ' class="today"' : '';
			?>
			<tr<?=$today?>>
				<td class="timestamp"><?=($t * 1000)?></td>
				<td class="dateFormatted"><?=strtoupper(date("F jS, Y", $t))?></td>
				<td class="tagsCreated"><?=$stat->tagsCreated?></td>
			</tr>
			<?php
			endforeach;
			?>
		</tbody>
	</table>

</div><!-- END PAGE -->

<div class="page" page="click-log">

	<div class="chart"></div>
	<div class="infoarea">
		<h2>Total Outbound Clicks: <?php echo $totalValues['outboundClicks']; ?></h2>
	</div>


	<div class="chartBubbleInfo">
		<div data="inboundClicks" class="data"><span class="label">INBOUND CLICKS:</span></div>
		<div data="outboundClicks" class="data"><span class="label">OUTBOUND CLICKS:</span></div>
		<div data="dateFormatted" class="dateFormatted"></div>
	</div>

	<table class="chartData" plot="outboundClicks">
		<thead>
			<tr>
				<th class="timestamp">Timestamp</th>
				<th class="dateFormatted">Date</th>
				<th class="inboundClicks">Total Inbound Clicks</th>
				<th class="outboundClicks">Total Outbound Clicks</th>
			</tr>
		</thead>
		<tbody>
			<?php
			foreach($arrStats as $date => $stat):
				$t = strtotime($date);
				$today = (strtotime("today") == $t) ? ' class="today"' : '';
			?>
			<tr<?=$today?>>
				<td class="timestamp"><?=($t * 1000)?></td>
				<td class="dateFormatted"><?=strtoupper(date("F jS, Y", $t))?></td>
				<td class="inboundClicks"><?=$stat->inboundClicks?></td>
				<td class="outboundClicks"><?=$stat->outboundClicks?></td>
			</tr>
			<?php
			endforeach;
			?>
		</tbody>
	</table>

</div><!-- END PAGE -->

<div class="page" page="users-over-time">

	<div class="chart"></div>
	<div class="infoarea">
		<h2>Accounts Created: <?php echo $totalValues['accountsCreated']; ?></h2>
	</div>

	<div class="chartBubbleInfo">
		<div data="accountsCreated" class="data"><span class="label">ACCOUNTS CREATED:</span></div>
		<div data="dateFormatted" class="dateFormatted"></div>
	</div>

	<table class="chartData" plot="accountsCreated">
		<thead>
			<tr>
				<th class="timestamp">Timestamp</th>
				<th class="dateFormatted">Date</th>
				<th class="accountsCreated">Accounts Created</th>
			</tr>
		</thead>
		<tbody>
			<?php
			foreach($arrStats as $date => $stat):
				$t = strtotime($date);
				$today = (strtotime("today") == $t) ? ' class="today"' : '';
			?>
			<tr<?=$today?>>
				<td class="timestamp"><?=($t * 1000)?></td>
				<td class="dateFormatted"><?=strtoupper(date("F jS, Y", $t))?></td>
				<td class="accountsCreated"><?=$stat->accountsCreated?></td>
			</tr>
			<?php
			endforeach;
			?>
		</tbody>
	</table>

</div><!-- END PAGE -->

<div class="page" page="images-registered">

	<div class="chart"></div>
	<div class="infoarea">
		<h2>Images Registered: <?php echo $totalValues['newImages']; ?></h2>
	</div>

	<div class="chartBubbleInfo">
		<div data="newImages" class="data"><span class="label">IMAGES REGISTERED:</span></div>
		<div data="dateFormatted" class="dateFormatted"></div>
	</div>

	<table class="chartData" plot="newImages">
		<thead>
			<tr>
				<th class="timestamp">Timestamp</th>
				<th class="dateFormatted">Date</th>
				<th class="newImages">Images Registered</th>
			</tr>
		</thead>
		<tbody>
			<?php
			foreach($arrStats as $date => $stat):
				$t = strtotime($date);
				$today = (strtotime("today") == $t) ? ' class="today"' : '';
			?>
			<tr<?=$today?>>
				<td class="timestamp"><?=($t * 1000)?></td>
				<td class="dateFormatted"><?=strtoupper(date("F jS, Y", $t))?></td>
				<td class="newImages"><?=$stat->newImages?></td>
			</tr>
			<?php
			endforeach;
			?>
		</tbody>
	</table>

</div><!-- END PAGE -->

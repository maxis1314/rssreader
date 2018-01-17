<?php
/* 
 ======================================================================
 lastRSS usage DEMO 1
 ----------------------------------------------------------------------
 This example shows, how to
 	- create lastRSS object
	- set transparent cache
	- get RSS file from URL
	- show result in array structure
 ======================================================================
*/

// include lastRSS
include "./lastRSS.php";

// Create lastRSS object
$rss = new lastRSS;

// Set cache dir and cache time limit (1200 seconds)
// (don't forget to chmod cahce dir to 777 to allow writing)
$rss->cache_dir = '';
$rss->cache_time = 0;
$rss->cp = 'US-ASCII';
$rss->date_format = 'l';

// Try to load and parse RSS file of Slashdot.org
$rssurl = 'http://www.freshfolder.com/rss.php';
$db = get_db();
if ($rs = $rss->get($rssurl)) {
	foreach($rs['items'] as $one){
        echo $one["title"];
        echo $one["link"];
        echo $one["description"];
        echo $one["pubDate"];
        $db->save('rss',array(
            'title'=>$one["title"],
            'link'=>$one["link"],
            'description'=>$one["description"],
            'pubDate'=>$one["pubDate"],
        ));
    }
}else {
	echo "Error: It's not possible to get $rssurl...";
}

?>
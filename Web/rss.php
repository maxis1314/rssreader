<?php
 header("Content-Type: application/rss+xml; charset=utf8");  
 DEFINE ('DB_USER', 'root'); 
 DEFINE ('DB_PASSWORD', ''); 
 DEFINE ('DB_HOST', '127.0.0.1'); 
 DEFINE ('DB_NAME', 'eagle');  
 DEFINE ('TABLE_NAME', 'rss');
 
 $rssfeed = '<?xml version="1.0" encoding="utf8">';
 $rssfeed .= '<rss version="2.0">';
 $rssfeed .= '<channel>';
 $rssfeed .= '<title>My RSS feed</title>';
 $rssfeed .= '<link>http://www.mywebsite.com</link>';
 $rssfeed .= '<description>This is an example RSS feed</description>';
 $rssfeed .= '<language>en-us</language>';
 $rssfeed .= '<copyright>Copyright (C) 2009 mywebsite.com</copyright>';  
 $connection = @mysql_connect(DB_HOST, DB_USER, DB_PASSWORD) or die('Could not connect to database');
 mysql_select_db(DB_NAME) or die ('Could not select database');  
 $query = "SELECT * FROM ".TABLE_NAME." ORDER BY date DESC";
 $result = mysql_query($query) or die ("Could not execute query");  
 while($row = mysql_fetch_array($result)) {
     extract($row);  
     $rssfeed .= '<item>';
     $rssfeed .= '<title>' . $title . '</title>';
     $rssfeed .= '<description>' . $description . '</description>';
     $rssfeed .= '<link>' . $link . '</link>';
     $rssfeed .= '<pubDate>' . date("D, d M Y H:i:s O", strtotime($date)) . '</pubDate>';
     $rssfeed .= '</item>';
 }  
 $rssfeed .= '</channel>';
 $rssfeed .= '</rss>';  echo $rssfeed;
?>
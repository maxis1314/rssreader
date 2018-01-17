<?php
error_reporting(0);
require("data/MysqlDAO.php");
require("data/dbcenter.php");

//check_sign();

$uid = get("uid");

 header("Content-Type: application/rss+xml; charset=utf-8");  

 $db = get_db();
 $data = $db->get_list_h("select * from rss where uid='$uid'");
 
 $rssfeed = '<?xml version="1.0" encoding="utf-8"?>';
 $rssfeed .= '<rss version="2.0">';
 $rssfeed .= '<channel>';
 $rssfeed .= '<title>My RSS feed</title>';
 $rssfeed .= '<link>http://www.mywebsite.com</link>';
 $rssfeed .= '<description>This is an example RSS feed</description>';
 $rssfeed .= '<language>en-us</language>';
 $rssfeed .= '<copyright>Copyright (C) 2009 mywebsite.com</copyright>';  

 foreach($data as $one){
     extract($row);  
     $rssfeed .= '<item>';
     $rssfeed .= '<title>' . $one['title'] . '</title>';
     $rssfeed .= '<description>' . $one['description'] . '</description>';
     $rssfeed .= '<link>' . get_url() . "/review_detail.php?review_id=$one[id]</link>";
     $rssfeed .= '<pubDate>' . date("D, d M Y H:i:s O", strtotime($one['date'])) . '</pubDate>';
     $rssfeed .= '</item>';
 }  
 $rssfeed .= '</channel>';
 $rssfeed .= '</rss>';  echo $rssfeed;
?>
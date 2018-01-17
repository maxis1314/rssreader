<?php
error_reporting(0);
require("data/MysqlDAO.php");
require("data/dbcenter.php");

check_sign();

$id = get("review_id");

//header("Content-Type: application/rss+xml; charset=utf-8");  

 $db = get_db();
 $data = $db->get_one_h("select * from rss where id='$id'");
 
?>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
.ui-page .ui-header {
    background: #558C89 !important;
}
</style>

<link rel="stylesheet" href="jquery.mobile-1.3.2.min.css">
<script src="jquery-1.8.3.min.js"></script>
<script src="jquery.mobile-1.3.2.min.js"></script>
</head>
<body>

<div data-role="page">
  <div data-role="header">
    <h1><?php echo $data['title']; ?></h1>
  </div>

  <div data-role="content">
    <p><?php echo $data['description']; ?></p>
  </div>

 <!-- <div data-role="footer">
  <h1>页脚文本</h1>
  </div>-->
</div> 

</body>
</html>

<meta charset="utf-8">
<style>
table, td, th {
    border: 1px solid black;
}
 
</style>
<?php
error_reporting(0);
require("auth_simple.php");
require("header.php");
require("dbcenter.php");
$table_name = "rss";
$dbconfig = get_db_config();
require "auto_default.php";


require("footer.php");
<?php

function check_login2($name,$pass){
   $passmd5 = md5($pass);
   $inputpass= isset($_POST['gaga123']) ? $_POST['gaga123'] : "";
   if(isset($_COOKIE['gaga456']) || $inputpass){
	if(isset($_COOKIE['gaga456']) && $_COOKIE['gaga456'] == $passmd5){
		
	}else if($inputpass == $pass){
                setcookie("gaga456", $passmd5, time()+3600*24*30, "/");
	}else{
		echo "pls login";
		echo "<form method=POST><input type=password name='gaga123'><input type=submit></form>";
                exit();	    	
	}
   }else{
	echo "<form method=POST><input type=password name='gaga123'><input type=submit></form>";
	exit();
   }
}

check_login2("admin","eagle");



 
 
 
 






</div>

<div class="container-fluid">
    <hr>

        <p>&nbsp;</p>

</div>


<script src="pubic/static/bootstrap/js/bootstrap.min.js"></script>
<script src="pubic/static/bootstrap/js/jquery-ui-1.10.0.custom.min.js"></script>


<div style="display:none;" class="back-to" id="toolBackTop">
<a title="���ض���" onclick="window.scrollTo(0,0);return false;" href="#top" class="back-top">
���ض���</a>
</div>

<style>

.back-to {bottom: 35px;overflow:hidden;position:fixed;right:10px;width:50px;z-index:999;}
.back-to .back-top {background: url("pub/images/back-top.png") no-repeat scroll 0 0 transparent;display: block;float: right;height:50px;margin-left: 10px;outline: 0 none;text-indent: -9999em;width: 50px;}
#.back-to .back-top:hover {background-position: -50px 0;}
</style>
<script type="text/javascript">
$(document).ready(function () {
        var bt = $('#toolBackTop');
        var sw = $(document.body)[0].clientWidth;

        var limitsw = (sw - 1200) / 2 - 40;
        if (limitsw > 0){
                limitsw = parseInt(limitsw);
                bt.css("right",limitsw);
        }

        $(window).scroll(function() {
                var st = $(window).scrollTop();
                if(st > 30){
                        bt.show();
                }else{
                        bt.hide();
                }
        });
})
</script>

 
  </body>
</html>
 
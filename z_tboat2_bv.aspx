<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
            $(document).ready(function() {
                _q_boxClose();
                q_getId();
                q_gf('', 'z_tboat2_bv');
                
            });
            
            function q_gfPost() {
                $('#qReport').q_report({
                    fileName : 'z_tboat2_bv',
                    options : [{
                        type : '1',
                        name : 'xdate'
                    }, {
                        type : '2',
                        name : 'xcust',
                        dbf : 'cust',
                        index : 'noa,comp',
                        src : 'cust_b.aspx'
                    },{
                        type : '6',
                        name : 'bnoa'
                    }, {
                        type : '6',
                        name : 'enoa'
                    }]
                });
                
                q_getFormat();
                q_langShow();
                q_popAssign();
                
                $('#txtBnoa').mask('9999999999');
                $('#txtEnoa').mask('9999999999');
                $('#txtXdate1').mask('999/99/99');
                $('#txtXdate2').mask('999/99/99');
                
                $('.q_report .option div .c6').css('width','90px');
                
                var t_para = new Array();
	            try{
	            	t_para = JSON.parse(q_getId()[3]);
	            }catch(e){
	            }    
	            if(t_para.length==0 || t_para.bnoa==undefined || t_para.enoa==undefined || t_para.bnoa=='' || t_para.enoa==''){
	            	$('#un96code').text('轉聯運作業 無96編碼!!請手動輸入');
	            }else{
	            	$('#txtBnoa').val(t_para.bnoa);
                	$('#txtEnoa').val(t_para.enoa);
	            }
                
                $('.prt').hide();
                
                $('#txtBnoa').blur(function() {
                	if(!emp($(this).val())){
                		if(!((/^96[0-9]{8}$/g).test($(this).val())&&(dec($(this).val().substr(0,9))%7)==$(this).val().substr(-1)))
                			alert('請輸入正確的96條碼!!!');
                	}
				});
				
				$('#txtEnoa').blur(function() {
                	if(!emp($(this).val())){
                		if(!((/^96[0-9]{8}$/g).test($(this).val())&&(dec($(this).val().substr(0,9))%7)==$(this).val().substr(-1)))
                			alert('請輸入正確的96條碼!!!');
                	}
				});
                
                $('#btnDownloadPdf').click(function() {
                	if(!emp($('#txtBnoa').val())&&!emp($('#txtEnoa').val())){
                		if((/^96[0-9]{8}$/g).test($('#txtBnoa').val()) && (/^96[0-9]{8}$/g).test($('#txtEnoa').val()) &&
                		($('#txtBnoa').val().substr(0,9)%7)==$('#txtBnoa').val().substr(-1)&&($('#txtEnoa').val().substr(0,9)%7)==$('#txtEnoa').val().substr(-1)){
                			if(Math.abs(q_sub(dec($('#txtBnoa').val().substr(0,9)),dec($('#txtEnoa').val().substr(0,9))))<2000)
                				window.open("./pdf_barcode96.aspx?bno="+$('#txtBnoa').val()+"&eno="+$('#txtEnoa').val()+"&db="+q_db);
                			else
                				alert('條碼範圍不得超逾2000張!!!');
                		}else{
                			alert('請輸入正確的96條碼!!!');
                		}
                		$('#un96code').text('');
                	}else{
                		alert('請輸入96條碼!!!');
                	}
                	
				});
				
				$('#btnAuthority').click(function(e) {
					btnAuthority(q_name);
				});
				
				$('#qReport').click(function(){
					if($('#qReport').data('info').radioIndex==0){
						$('.prt').hide();
						$('.download').show();
					}else{
						$('.prt').show();
						$('.download').hide();
					}
				});
            }

            function q_boxClose(t_name) {
            }

            function q_gtPost(t_name) {
            }
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"> </div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="qReport"> </div>
			</div>
			<div class="download" style="float: left; width: 100%;">
				<p><a id='un96code' style="text-decoration:none;color:darkorange; font-size: 25px;  font-weight: bold;"> </a></p>
				<input class="btn" id="btnDownloadPdf" type="button" value='列印' style=" font-weight: bold;font-size: 16px;color: blue;" />
				<input class="btn" id="btnAuthority" type="button" value="權限" style=" font-weight: bold;font-size: 16px;color: blue;"/>
			</div>
			<div class="prt" style="margin-left: -40px;" >
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>
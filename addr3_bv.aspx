<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
    <head>
        <title> </title>
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
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}
			isEditTotal = false;
			q_tables = 's';
			var q_name = "addr3";
			var q_readonly = [];
			var q_readonlys = ['txtNoq'];
			var bbmNum = [];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'noa';
			
			brwCount2 = 8;
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
			}).mousedown(function(e) {
				if (!$('#div_row').is(':hidden')) {
					if (mouse_div) {
						$('#div_row').hide();
					}
					mouse_div = true;
				}
			});
			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(0);
			}
			function mainPost() {
				document.title='1.3發送所簡碼維護';
				$("#lblNoa").text('站所簡碼');
				$("#lblNamea").text('站所名稱');
				$("#lblCode").text('站所代號');
				q_getFormat();
				bbmMask = [['txtCode', '9999']];
				q_mask(bbmMask);
				
				$('#txtNoa').change(function(e) {
                 $(this).val($.trim($(this).val()).toUpperCase());
                 if ($(this).val().length > 0) {
                        //if((/^(\w+|\w+\u002D\w+)$/g).test($(this).val())){
                        t_where = "where=^^ noa='" + $(this).val() + "'^^";
                        q_gt('addr3', t_where, 0, 0, 0, "checkAddrno_change", r_accy);
                    }
                });
			}
			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}
			var isSearch = 0;
			var SearchStr = "";
			function q_gtPost(t_name) {
				switch (t_name) {
					case 'checkAddrno_change':
                        var as = _q_appendData("addr3", "", true);
                        if (as[0] != undefined) {
                            alert('已存在 ' + as[0].noa + ' ' + as[0].namea);
                        }
                        break;
                    case 'checkAddrno_btnOk':
                        var as = _q_appendData("addr3", "", true);
                        if (as[0] != undefined) {
                            alert('已存在 ' + as[0].noa + ' ' + as[0].namea);
                            Unlock();
                            return;
                        } else {
                            wrServer($('#txtNoa').val());
                        }
                        break;
				}
			}
			function btnOk() {
				Lock();
			 $('#txtNoa').val($.trim($('#txtNoa').val()));
			  if (q_cur == 1) {
                    t_where = "where=^^ noa='" + $('#txtNoa').val() + "'^^";
                    q_gt('addr3', t_where, 0, 0, 0, "checkAddrno_btnOk", r_accy);
                 }else {
                    wrServer($('#txtNoa').val());
                }
			}
			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
				Unlock();
			}
			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;
				q_box('addr3_bv_s.aspx', q_name + '_s', "500px", "250px", q_getMsg("popSeek"));
			}
			function bbsAssign() {
				for (var i = 0; i < q_bbsCount; i++) {
					$('#lblNo_' + i).text(i + 1);
					if (!$('#btnMinus_' + i).hasClass('isAssign')) {
						$('#btnMinus_' + i).bind('contextmenu',function(e) {
                            /*滑鼠右鍵*/
                            e.preventDefault();
							mouse_div = false;
							////////////控制顯示位置
							$('#div_row').css('top', e.pageY);
							$('#div_row').css('left', e.pageX);
							////////////
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							$('#div_row').show();
							row_b_seq = b_seq;
							row_bbsbbt = 'bbs';
						});
					}
				}
				_bbsAssign();
			}
			function btnIns() {
				_btnIns();
				$('#txtNamea').focus();
			}
			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				refreshBbm();
				$('#txtNamea').focus();
			}
			function btnPrint() {
				
			}
			function wrServer(key_value) {
				var i;
				$('#txtNoa').val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}
			function bbsSave(as) {
				if (!as['addrno']) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				as['noa'] = abbm2['noa'];
				return true;
			}
			function refresh(recno) {
				_refresh(recno);
				refreshBbm();
				if(isSearch==1){
					for(var k=0;k<q_bbsCount;k++){
						var thisAddrno = $.trim($('#txtAddrno_'+k).val());
						if(thisAddrno==SearchStr){
							$('#txtAddrno_'+k).focus();
							$('#txtAddrno_'+k).select();
							break;
						}
					}
					isSearch = 0;
				}
			}
			function refreshBbm() {
                if (q_cur == 1) {
                    $('#txtNoa').css('color', 'black').css('background', 'white').removeAttr('readonly');
                } else {
                    $('#txtNoa').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                }
            }
			function readonly(t_para, empty) {
				_readonly(t_para, empty);
			}
			function btnMinus(id) {
				_btnMinus(id);
			}
			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
			}
			function q_appendData(t_Table) {
				return _q_appendData(t_Table);
			}
			function btnSeek() {
				_btnSeek();
			}
			function btnTop() {
				_btnTop();
			}
			function btnPrev() {
				_btnPrev();
			}
			function btnPrevPage() {
				_btnPrevPage();
			}
			function btnNext() {
				_btnNext();
			}
			function btnNextPage() {
				_btnNextPage();
			}
			function btnBott() {
				_btnBott();
			}
			function q_brwAssign(s1) {
				_q_brwAssign(s1);
			}
			function btnDele() {
				_btnDele();
			}
			function btnCancel() {
				_btnCancel();
			}
        </script>
        <style type="text/css">
            #dmain {
                overflow: hidden;
            }
            .dview {
                float: left;
                width: 300px;
                border-width: 0px;
            }
            .tview {
                border: 5px solid gray;
                font-size: medium;
                background-color: black;
            }
            .tview tr {
                height: 30px;
            }
            .tview td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: #FFFF66;
                color: blue;
            }
            .dbbm {
                float: left;
                width: 500px;
                /*margin: -1px;
                 border: 1px black solid;*/
                border-radius: 5px;
            }
            .tbbm {
                padding: 0px;
                border: 1px white double;
                border-spacing: 0;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: #cad3ff;
                width: 100%;
            }
            .tbbm tr {
                height: 35px;
            }
            .tbbm tr td {
                width: 10%;
            }
            .tbbm .tr1 {
                background-color: #FFEC8B;
            }
            .tbbm .tdZ {
                width: 2%;
            }
            td .schema {
                display: block;
                width: 95%;
                height: 0px;
            }
            .tbbm tr td span {
                float: right;
                display: block;
                width: 5px;
                height: 10px;
            }
            .tbbm tr td .lbl {
                float: right;
                color: blue;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn {
                color: #4297D7;
                font-weight: bolder;
            }
            .tbbm tr td .lbl.btn:hover {
                color: #FF8F19;
            }
            .txt.c1 {
                width: 100%;
                float: left;
            }
            .txt.c2 {
                width: 40%;
                float: left;
            }
            .txt.c3 {
                width: 60%;
                float: left;
            }
            .txt.c4 {
                width: 50%;
                float: left;
            }
            .txt.num {
                text-align: right;
            }
            .tbbm td {
                margin: 0 -1px;
                padding: 0;
            }
            .tbbm td input[type="text"] {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                float: left;
            }
            .tbbm select {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                font-size: medium;
            }
            .dbbs {
                width: 950px;
            }
            .tbbs a {
                font-size: medium;
            }
            .num {
                text-align: right;
            }
            input[type="text"], input[type="button"], select {
                font-size: medium;
            }
            #div_row{
            display:none;
            width:750px;
            background-color: #ffffff;
            position: absolute;
            left: 20px;
            z-index: 50;
            }
            .table_row tr td .lbl.btn {
                color: #000000;
                font-weight: bolder;
                font-size: medium;
                cursor: pointer;
            }
            .table_row tr td .lbl.btn:hover {
                color: #FF8F19;
            }
        </style>
    </head>
    <body ondragstart="return false" draggable="false"
    ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
    ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
    ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
        <div id="div_row" style="position:absolute; top:300px; left:500px; display:none; width:150px; background-color: #ffffff; ">
            <table id="table_row"  class="table_row" style="width:100%;" border="1" cellpadding='1'  cellspacing='0'>
                <tr>
                    <td align="center" ><a id="lblTop_row" class="lbl btn">上方插入空白行</a></td>
                </tr>
                <tr>
                    <td align="center" ><a id="lblDown_row" class="lbl btn">下方插入空白行</a></td>
                </tr>
            </table>
        </div>
        <!--#include file="../inc/toolbar.inc"-->
        <div id='dmain' >
            <div class="dview" id="dview">
                <table class="tview" id="tview">
                    <tr>
                        <td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
                        <td align="center" style="width:130px; color:black;"><a > 站所代號</a></td>
                         <td align="center" style="width:130px; color:black;"><a> 站所名稱 </a></td>
                    </tr>
                    <tr>
                        <td>
                        <input id="chkBrow.*" type="checkbox" />
                        </td>
                        <td id="noa" style="text-align: center;">~noa</td>
                        <td id="namea" style="text-align: center;">~namea</td>
                    </tr>
                </table>
            </div>
            <div class='dbbm'>
                <table class="tbbm"  id="tbbm">
                    <tr style="height:1px;">
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td class="tdZ"> </td>
                    </tr>
                    <tr> </tr>
                    <tr>
                    	<td><span> </span><a id="lblNoa" class="lbl"> </a></td>
                    	<td><input id="txtNoa" type="text" class="txt c1"/></td>
                    </tr>
                    <tr>   
                        <td><span> </span><a id="lblNamea" class="lbl"> </a></td>
                        <td colspan="2"><input id="txtNamea" type="text"  class="txt c1"/></td> 
					</tr>
					<tr>   
                        <td><span> </span><a id="lblCode" class="lbl"> </a></td>
                        <td><input id="txtCode" type="text"  class="txt c1"/></td> 
					</tr>
                    <tr> </tr>
                </table>
            </div>
        </div>
        <div class='dbbs' style="display: none;">
            <table id="tbbs" class='tbbs'>
                <tr style='color:white; background:#003366;' >
                    <td  align="center" style="width:30px;">
                    <input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  />
                    </td>
                    <td align="center" style="width:20px;"> </td>
                    <td align="center" style="width:150px;">站所名稱</td>
                </tr>
                <tr  style='background:#cad3ff;'>
                    <td align="center">
                    <input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
                    <input id="txtNoq.*" type="text" style="display: none;" />
                    </td>
                    <td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
                    <td><input type="text" id="txtAddrno.*" style="width:95%;" />
                        <input type="text" id="txtAddr.*" style="display:none;" />
                    </td>
                </tr>
            </table>
        </div>
        <input id="q_sys" type="hidden" />
    </body>
</html>

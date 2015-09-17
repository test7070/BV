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
            var q_name = "transef";
            var q_readonly = ['txtNoa','txtMon','cmbCalctype','cmbCarno','txtTraceno','txtIo'];
            var bbmNum = [];
            var bbmMask = [];
            q_sqlCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'noa';
            q_desc = 1;
            //q_xchg = 1;
            brwCount = 6;
            brwCount2 = 10;
            
            aPop = new Array(
            	['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,tel,zip_comp,addr_comp,zip_fact', 'txtCustno,txtComp,txtNick,txtAtel,txtCaseend,txtAaddr,txtAccno', 'cust_b.aspx'], 
				['txtCaseend', 'lblCaseend', 'addr2', 'noa,siteno', 'txtCaseend,txtAccno', 'addr2_b.aspx']
			);
                
            $(document).ready(function() {
				bbmKey = ['noa'];
                q_brwCount();
                /*if(q_content!=""){
                	q_content="where=^^"+replaceAll(replaceAll(q_content,"where=^^",""),"^^","")+"and left(calctype,2)='手寫' "+"^^";
                }else
                	q_content = "where=^^left(calctype,2)='手寫'^^";*/
                q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
                
            });
            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainForm(0);
            }

            function mainPost() {
                bbmMask = [['txtDatea', r_picd],['txtTrandate', r_picd],['textBdate',r_picd],['textEdate',r_picd]];
                q_mask(bbmMask);
                
                document.title='託運單作業';
            	$("#lblCust").text('客戶');
            	$("#lblCaseend").text('郵遞區號');
            	
            	q_cmbParse("cmbCarno", "1,2,3");
            	q_cmbParse("cmbCalctype", "手寫託運單,edi託運單");
                q_modiDay= q_getPara('sys.modiday2');  /// 若未指定， d4=  q_getPara('sys.modiday'); 
                $('#textBdate').datepicker();
                $('#textEdate').datepicker();
                
                $('#btnIns').hide();
                $('#btnModi').hide();
                $('#btnDele').hide();
                $('#btnSeek').hide();
                $('#btnPrint').hide();
                $('#btnOk').hide();
                $('#btnCancel').hide();
            }
            function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                    case q_name + '_s':
                        q_boxClose2(s2);
                        break;
                }
            }
            function q_funcPost(t_func, result) {
                switch(t_func) {
                }
            }
            function q_gtPost(t_name) {
                switch (t_name) {
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                    default:
                       
                        break;
                }
            }
            function q_popPost(id) {
                switch(id) {
                    
                    default:
                        break;
                }
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)
                    return;
                //q_box('transef_bv_s.aspx', q_name + '_s', "500px", "530px", q_getMsg("popSeek"));
            }
            
            function btnIns() {
                
                _btnIns();

                $('#txtNoa').val('AUTO');
                $('#txtDatea').val(q_date());
                $('#txtNoq').val('001');

                $('#txtDatea').focus();
                
            }
            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
            }
            
            function btnPrint() {
                q_box("z_tranorde_bv.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + JSON.stringify({bnoa:trim($('#txtBoatname').val()),enoa:trim($('#txtBoatname').val())}) + ";" + r_accy + "_" + r_cno, 'transorde', "95%", "95%", m_print);
            }
            
            function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
				if(!emp($('#txtBoatname').val()))
                	q_func('qtxt.query.ordeused', 'tboat.txt,ordeused,' + encodeURI($('#txtBoatname').val()));
                Unlock(1);
            }
            
            function btnOk() {
                Lock(1,{opacity:0});
                
                var t_noa = trim($('#txtNoa').val());
                var t_date = trim($('#txtDatea').val());
                if (q_cur ==1)
                    q_gtnoa(q_name, replaceAll(q_getPara('sys.key_trans') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
                else
                    wrServer(t_noa);        
            }
            
            function wrServer(key_value) {
                var i;
                $('#txtNoa').val(key_value);
                _btnOk(key_value, bbmKey[0], '', '', 2);
            }

            function refresh(recno) {
                _refresh(recno);
            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
           		if (t_para) {
					$('#txtDatea').datepicker( 'destroy' );
					
				} else {
					$('#txtDatea').removeClass('hasDatepicker')
					$('#txtDatea').datepicker();
				}
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
                if (q_chkClose())
                        return;
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
                width: 1250px; 
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
                width: 1100px;
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
                width: 9%;
            }
            .tbbm .tdZ {
                width: 2%;
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
            }
            .tbbs input[type="text"] {
                width: 98%;
            }
            .tbbs a {
                font-size: medium;
            }
            .num {
                text-align: right;
            }
            .bbs {
                float: left;
            }
            input[type="text"], input[type="button"] {
                font-size: medium;
            }
            select {
                font-size: medium;
            }
        </style>
    </head>
    <body ondragstart="return false" draggable="false"
    ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
    ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
    ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
    >
        <!--#include file="../inc/toolbar.inc"-->
        <div id="dmain">
            <div class="dview" id="dview">
                <table class="tview" id="tview">
                    <tr>
                        <td align="center" style="width:20px; color:black;"><a id="vewChk"> </a></td>
                        <!--<td align="center" style="width:100px; color:black;">客戶代號</td>-->
                        <td align="center" style="width:100px; color:black;">客戶簡稱</td>
                        <td align="center" style="width:100px; color:black;">97條碼</td>
                        <td align="center" style="width:100px; color:black;">姓名</td>
                        <td align="center" style="width:100px; color:black;">電話</td>
                        <td align="center" style="width:100px; color:black;">郵遞區號</td>
                        <td align="center" style="width:140px; color:black;">地址</td>
                        <td align="center" style="width:80px; color:black;">速配袋號</td>
                        <td align="center" style="width:80px; color:black;">代收貨款</td>
                        <td align="center" style="width:140px; color:black;">商品內容</td>
                        <td align="center" style="width:180px; color:black;">備註</td>
                    </tr>
                    <tr>
                        <td ><input id="chkBrow.*" type="checkbox"/></td>
                        <!--<td id="custno" style="text-align: center;">~custno</td>-->
                        <td id="nick" style="text-align: center;">~nick</td>
                        <td id="boatname" style="text-align: center;">~boatname</td>
                        <td id="addressee" style="text-align: center;">~addressee</td>
                        <td id="atel" style="text-align: center;">~atel</td>
                        <td id="caseend" style="text-align: center;">~caseend</td>
                        <td id="aaddr" style="text-align: center;">~aaddr</td>
                        <td id="carno" style="text-align: center;">~carno</td>
                        <td id="price,0" style="text-align: right;">~price,0</td>
                        <td id="straddr" style="text-align: center;">~straddr</td>
                        <td id="endaddr" style="text-align: center;">~endaddr</td>
                    </tr>
                </table>
            </div>
            <div class="dbbm" style="display: none;">
                <table class="tbbm"  id="tbbm">
                    <tr style="height:1px;">
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td class="tdZ"> </td>
                    </tr>
                    <tr>
                    	<td><span> </span><a class="lbl"> 97條碼 </a></td>
						<td><input type="text" id="txtBoatname" class="txt c1" /></td>
						<td><span> </span><a class="lbl"> 96條碼 </a></td>
						<td ><input type="text" id="txtPo" class="txt c1" style="width:70%"/></td>
						<td><span> </span><a class="lbl">已傳入大貨追</a></td>
                        <td><input id="txtMon"  type="text" class="txt c1 "/></td>
					</tr>
					<tr> 
                        <td><span> </span><a id='lblCust' class="lbl btn"> </a></td>
						<td colspan="3">
							<input type="text" id="txtCustno" class="txt" style="width:20%;float: left; " />
							<input type="text" id="txtComp" class="txt" style="width:80%;float: left; " />
							<input type="text" id="txtNick" class="txt" style="display:none; " />
						</td> 
						<td><span> </span><a class="lbl">托運單</a></td>
						<td><input type="text" id="txtIo" class="txt c1" /></td>
                    </tr>
                    <tr>
                    	<td><span> </span><a class="lbl">發送日期</a></td>
                        <td><input id="txtDatea"  type="text" class="txt c1"/></td>
                        <td><span> </span><a class="lbl">配送日期</a></td>
                        <td><input id="txtTrandate"  type="text" class="txt c1"/></td>
                    </tr>
                    <tr>
                        <td><span> </span><a class="lbl">姓名</a></td>
                        <td><input id="txtAddressee"  type="text" class="txt c1"/></td>
                        <td><span> </span><a class="lbl">行動電話</a></td>
                        <td><input id="txtBoat"  type="text" class="txt c1"/></td>
                    </tr>
                    <tr>
                    	<td><span> </span><a id='lblCaseend' class="lbl"> </a></td>
                        <td><input id="txtCaseend"  type="text" class="txt c1 "/></td>
                        <td><span> </span><a class="lbl">地址</a></td>
                        <td colspan="3"><input id="txtAaddr"  type="text" class="txt c1"/></td>
                        <td><span> </span><a class="lbl">發送所</a></td>
                        <td><input id="txtAccno"  type="text" class="txt c1 "/></td>
                    </tr>
                    <tr>
                        <td><span> </span><a class="lbl">商品內容</a></td>
                        <td colspan="3"><input id="txtStraddr"  type="text" class="txt c1"/></td>
                        <td><span> </span><a class="lbl">備註</a></td>
                        <td colspan="3"><input id="txtEndaddr"  type="text" class="txt c1"/></td>
                    </tr>
                    <tr>
                        <td><span> </span><a class="lbl">件數</a></td>
                        <td><input id="txtMount"  type="text" class="txt c1"/></td>
                        <td><span> </span><a class="lbl">電話</a></td>
                        <td colspan="3"><input id="txtAtel"  type="text" class="txt c1"/></td>
                    </tr>
                    <tr>
                    	<td><span> </span><a class="lbl">重量</a></td>
                    	<td><input id="txtWeight"  type="text" class="txt c1"/></td>
                        <td><span> </span><a class="lbl">代收貨款</a></td>
                        <td><input id="txtPrice"  type="text" class="txt c1 num"/></td>
                        <td><span> </span><a class="lbl">審件等級</a></td>
                        <td><input id="txtUnit"  type="text" class="txt c1"/></td>
                    </tr>
                    <tr>
                    	<td><span> </span><a class="lbl"> 託運單形式 </a></td>
						<td><select id="cmbCalctype" class="txt c1"> </select></td>
                    	<td><span> </span><a class="lbl"> 速配袋號 </a></td>
						<td><select id="cmbCarno" class="txt c1"> </select></td>
						<td><span> </span><a class="lbl"> 單據編號 </a></td>
						<td>
							<input type="text" id="txtNoa" class="txt c1"/>
							<input id="txtNoq"  type="text" style="display:none;"/>
						</td>
					</tr>
                    <tr>
                        <td><span> </span><a class="lbl">來源表單編號</a></td>
                        <td><input id="txtSo"  type="text" class="txt c1"/></td>
                        <td><span> </span><a class="lbl">訂單編號</a></td>
                        <td><input id="txtTraceno"  type="text" class="txt c1"/></td>
                    </tr>	
                </table>
            </div>
        </div>
      <input id="q_sys" type="hidden" />
    </body>
</html>

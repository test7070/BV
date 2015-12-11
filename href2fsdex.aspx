<%@ Page Language="C#" Debug="true"%>
    <%@ Import Namespace="System.Security.Cryptography" %>
    <%@ Import Namespace="System.IO" %>
    <script language="c#" runat="server">     
        public void Page_Load()
        {
        	string estr = "";
        	estr = Request.QueryString["estr"];
        	
        	if( estr != "" && estr != null){
	        	 //字串
	            string str97 = estr;
	            str97 = str97.Substring(0, 6) + "H@" + str97.Substring(6, 4);
	            //金鑰
	            string strKey = DateTime.Now.AddDays(-65).ToString("yyyyMMdd");
	
	            //加密向量
	            string strIV = "WRPTLWRQ";
	
	            string str1 = str97 + strKey + strIV;
	
	            //轉BYTE UTF8編碼
	            byte[] bytestr1 = System.Text.Encoding.UTF8.GetBytes(str1);
	            MemoryStream ms = new MemoryStream();
	            DES des = new DESCryptoServiceProvider();
	
	
	            CryptoStream encStream = new CryptoStream(ms, des.CreateEncryptor(Encoding.UTF8.GetBytes(strKey), Encoding.UTF8.GetBytes(strIV)), CryptoStreamMode.Write);
	            encStream.Write(bytestr1, 0, bytestr1.Length);
	            encStream.FlushFinalBlock();
	
	            //字串轉為BASE-6
	            estr = Convert.ToBase64String(ms.ToArray()).Replace("+", "%");
	            
	            Response.Redirect("https://www.hct.com.tw/fsdex/search_goods_result.aspx?estr="+estr);
	            
        	}else{
                Response.Write("資料錯誤!!");
        	}
        }
    </script>

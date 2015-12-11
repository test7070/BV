<%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">     
        
        public class Para
        {
            public string date1, date2;
            public string s1;
            public float s2;//代收款
            public string s3;//到著站;
            public float weight, count;
            public string barcode96;
            public string addressee_line1, addressee_line2, addressee_line3;
            public string memo_line1, memo_line2, memo_line3;
            public string sender_line1, sender_line2, sender_line3;

            public string bag;
            public string barcode97;
        }
        
        System.IO.MemoryStream stream = new System.IO.MemoryStream();
        string connectionString = "";
        public void Page_Load()
        {
        	string db = "dc";
        	if(Request.QueryString["db"] !=null && Request.QueryString["db"].Length>0)
        		db= Request.QueryString["db"];
        	connectionString = "Data Source=127.0.0.1,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database="+db;
            //參數
            string bno = "", eno ="";
            int str = 0;
            if (Request.QueryString["bno"] != null && Request.QueryString["bno"].Length > 0)
            {
                bno = Request.QueryString["bno"];
            }
            if (Request.QueryString["eno"] != null && Request.QueryString["eno"].Length > 0)
            {
                eno = Request.QueryString["eno"];
            }
            if (Request.QueryString["str"] != null && Request.QueryString["str"].Length > 0)
            {
                str = Convert.ToInt32(Request.QueryString["str"]);
            }
            //資料
            System.Data.DataTable dt = new System.Data.DataTable();
            using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(connectionString))
            {
                System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
                connSource.Open();
                string queryString = @"select datea,trandate,'' --指定配送
	                                    ,isnull(price,0),accno,[weight],mount,po barcode96
	                                    ,addressee,atel+'  '+boat,caseend+aaddr --zipcode+addr
	                                    ,straddr,endaddr memo,sender
	                                    ,custno,comp,boatname barcode97,carno bag
                                    from view_transef
                                    where boatname between @bno and @eno
                                    
                                    declare @accy nvarchar(20)=isnull((select top 1 accy from view_transef  where boatname between @bno and @eno and isnull(accy,'')!='' order by accy desc),'')
					                if(@accy!='')
										EXEC('update transef'+@accy+' set io=''已列印'' where boatname between '''+@bno+''' and '''+@eno+'''')
                                    
                                    ";
                System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryString, connSource);
                cmd.Parameters.AddWithValue("@bno", bno);
                cmd.Parameters.AddWithValue("@eno", eno);
                adapter.SelectCommand = cmd;
                adapter.Fill(dt);
                connSource.Close();
            }
            ArrayList barcode = new ArrayList();
            foreach (System.Data.DataRow r in dt.Rows)
            {
                Para pa = new Para();
                pa.date1 = System.DBNull.Value.Equals(r.ItemArray[0]) ? "" : (System.String)r.ItemArray[0];
                pa.date2 = System.DBNull.Value.Equals(r.ItemArray[1]) ? "" : (System.String)r.ItemArray[1];
                pa.s1 = System.DBNull.Value.Equals(r.ItemArray[2]) ? "" : (System.String)r.ItemArray[2];
                pa.s2 = System.DBNull.Value.Equals(r.ItemArray[3]) ? 0 : (float)(System.Decimal)r.ItemArray[3];
                pa.s3 = System.DBNull.Value.Equals(r.ItemArray[4]) ? "" : (System.String)r.ItemArray[4];

                pa.weight = System.DBNull.Value.Equals(r.ItemArray[5]) ? 0 : (float)(System.Decimal)r.ItemArray[5];
                pa.count = System.DBNull.Value.Equals(r.ItemArray[6]) ? 0 : (float)(System.Decimal)r.ItemArray[6];

                pa.barcode96 = System.DBNull.Value.Equals(r.ItemArray[7]) ? "" : (System.String)r.ItemArray[7];

                pa.addressee_line1 = System.DBNull.Value.Equals(r.ItemArray[8]) ? "" : (System.String)r.ItemArray[8];
                pa.addressee_line2 = System.DBNull.Value.Equals(r.ItemArray[9]) ? "" : (System.String)r.ItemArray[9];
                pa.addressee_line3 = System.DBNull.Value.Equals(r.ItemArray[10]) ? "" : (System.String)r.ItemArray[10];

                pa.memo_line1 = System.DBNull.Value.Equals(r.ItemArray[11]) ? "" : (System.String)r.ItemArray[11];
                pa.memo_line2 = System.DBNull.Value.Equals(r.ItemArray[12]) ? "" : (System.String)r.ItemArray[12];
                pa.memo_line3 = System.DBNull.Value.Equals(r.ItemArray[13]) ? "" : (System.String)r.ItemArray[13];

                pa.sender_line1 = System.DBNull.Value.Equals(r.ItemArray[14]) ? "" : (System.String)r.ItemArray[14];
                pa.sender_line2 = System.DBNull.Value.Equals(r.ItemArray[15]) ? "" : (System.String)r.ItemArray[15];
                pa.barcode97 = System.DBNull.Value.Equals(r.ItemArray[16]) ? "" : (System.String)r.ItemArray[16];
                pa.bag = System.DBNull.Value.Equals(r.ItemArray[17]) ? "" : (System.String)r.ItemArray[17];
                barcode.Add(pa);
            }
            //-----PDF--------------------------------------------------------------------------------------------------
            int[,] positions = new int[6, 2] { { 0, 570 }, { 313, 570 }, { 0, 285 }, { 313, 285 }, { 0, 0 }, { 313, 0 } };

			//int[,] positions = new int[6, 2] { { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } };

            //紙張 19.9*27.6
            var doc1 = new iTextSharp.text.Document(new iTextSharp.text.Rectangle(625, 868), 0, 0, 0, 0);
            iTextSharp.text.pdf.PdfWriter pdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance(doc1, stream);
            
            //紙張 9.95*9.2
            // var doc1 = new iTextSharp.text.Document(new iTextSharp.text.Rectangle(313, 289), 5, 5, 0, 0);
            // iTextSharp.text.pdf.PdfWriter pdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance(doc1, stream);
            
            //font
            iTextSharp.text.pdf.BaseFont bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            iTextSharp.text.pdf.BaseFont bfNumber = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\ariblk.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            
            doc1.Open();
            iTextSharp.text.pdf.PdfContentByte cb = pdfWriter.DirectContent;
            if (barcode.Count == 0)
            {
                cb.SetColorFill(iTextSharp.text.BaseColor.RED);
                cb.BeginText();
                cb.SetFontAndSize(bfChinese, 50);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "無資料", 20, 500, 0);
                cb.EndText();
            }
            else
            {	int j = 0;//控制資料
            	int k = 0;
                for (int i = 0; i < barcode.Count * 2; i++)
                {	k = 0;
                    if ((str + i) != 0 && (str + i) % 6 == 0)
                    {
                        //Insert page
                        doc1.NewPage();
                    }
                    // if (i != 0)
                    // {
                        // //Insert page
                        // doc1.NewPage();
                    // }
                    
                    cb.SetColorStroke(iTextSharp.text.BaseColor.BLACK);
                    cb.SetLineWidth(1);
                    //橫線
                    if(i % 2 == 0){
                    	cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 245);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 316, positions[(str + i) % 6, 1] + 245);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 221);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 135, positions[(str + i) % 6, 1] + 221);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 197);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 135, positions[(str + i) % 6, 1] + 197);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 185);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 316, positions[(str + i) % 6, 1] + 185);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 153);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 316, positions[(str + i) % 6, 1] + 153);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 115);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 316, positions[(str + i) % 6, 1] + 115);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 77);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 316, positions[(str + i) % 6, 1] + 77);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 39);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 316, positions[(str + i) % 6, 1] + 39);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 7);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 316, positions[(str + i) % 6, 1] + 7);
	                    cb.Stroke();
                    }else{
                    	cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 245);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 300, positions[(str + i) % 6, 1] + 245);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 221);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 135, positions[(str + i) % 6, 1] + 221);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 197);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 135, positions[(str + i) % 6, 1] + 197);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 185);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 300, positions[(str + i) % 6, 1] + 185);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 153);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 300, positions[(str + i) % 6, 1] + 153);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 115);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 230, positions[(str + i) % 6, 1] + 115);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 77);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 230, positions[(str + i) % 6, 1] + 77);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 39);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 300, positions[(str + i) % 6, 1] + 39);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 7);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 300, positions[(str + i) % 6, 1] + 7);
	                    cb.Stroke();
                    }
                                    
                    //直線
                    cb.MoveTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 245);
                    cb.LineTo(positions[(str + i) % 6, 0] + 8, positions[(str + i) % 6, 1] + 7);
                    cb.Stroke();
                    cb.MoveTo(positions[(str + i) % 6, 0] + 80, positions[(str + i) % 6, 1] + 245);
                    cb.LineTo(positions[(str + i) % 6, 0] + 80, positions[(str + i) % 6, 1] + 153);
                    cb.Stroke();
                    cb.MoveTo(positions[(str + i) % 6, 0] + 135, positions[(str + i) % 6, 1] + 245);
                    cb.LineTo(positions[(str + i) % 6, 0] + 135, positions[(str + i) % 6, 1] + 153);
                    cb.Stroke();
                    cb.MoveTo(positions[(str + i) % 6, 0] + 22, positions[(str + i) % 6, 1] + 153);
                    cb.LineTo(positions[(str + i) % 6, 0] + 22, positions[(str + i) % 6, 1] + 39);
                    cb.Stroke();
                    cb.MoveTo(positions[(str + i) % 6, 0] + 80, positions[(str + i) % 6, 1] + 39);
                    cb.LineTo(positions[(str + i) % 6, 0] + 80, positions[(str + i) % 6, 1] + 7);
                    cb.Stroke();
                    if(i % 2 == 0){
                    	cb.MoveTo(positions[(str + i) % 6, 0] + 316, positions[(str + i) % 6, 1] + 245);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 316, positions[(str + i) % 6, 1] + 7);
	                    cb.Stroke();
                    }                    
                    else{                    	
                    	cb.MoveTo(positions[(str + i) % 6, 0] + 230, positions[(str + i) % 6, 1] + 153);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 230, positions[(str + i) % 6, 1] + 39);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 245, positions[(str + i) % 6, 1] + 153);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 245, positions[(str + i) % 6, 1] + 39);
	                    cb.Stroke();
	                    cb.MoveTo(positions[(str + i) % 6, 0] + 300, positions[(str + i) % 6, 1] + 245);
	                    cb.LineTo(positions[(str + i) % 6, 0] + 300, positions[(str + i) % 6, 1] + 7);
	                    cb.Stroke();
                    }
                    

                    //TEXT
                    cb.SetColorFill(iTextSharp.text.BaseColor.BLACK);
                    cb.BeginText();
                    cb.SetFontAndSize(bfChinese, 10);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "指         定", positions[(str + i) % 6, 0] + 22, positions[(str + i) % 6, 1] + 235, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "配         送", positions[(str + i) % 6, 0] + 22, positions[(str + i) % 6, 1] + 223, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "代         收", positions[(str + i) % 6, 0] + 22, positions[(str + i) % 6, 1] + 211, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "金         額", positions[(str + i) % 6, 0] + 22, positions[(str + i) % 6, 1] + 199, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "重         量", positions[(str + i) % 6, 0] + 22, positions[(str + i) % 6, 1] + 187, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "總  件  數", positions[(str + i) % 6, 0] + 87, positions[(str + i) % 6, 1] + 187, 0);

                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "收", positions[(str + i) % 6, 0] + 10, positions[(str + i) % 6, 1] + 142, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "貨", positions[(str + i) % 6, 0] + 10, positions[(str + i) % 6, 1] + 130, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "人", positions[(str + i) % 6, 0] + 10, positions[(str + i) % 6, 1] + 118, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "備", positions[(str + i) % 6, 0] + 10, positions[(str + i) % 6, 1] + 104, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "註", positions[(str + i) % 6, 0] + 10, positions[(str + i) % 6, 1] + 80, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "寄", positions[(str + i) % 6, 0] + 10, positions[(str + i) % 6, 1] + 66, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "貨", positions[(str + i) % 6, 0] + 10, positions[(str + i) % 6, 1] + 54, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "人", positions[(str + i) % 6, 0] + 10, positions[(str + i) % 6, 1] + 42, 0);
					
					if(i % 2 != 0){
						cb.SetFontAndSize(bfChinese, 12);
						cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "客", positions[(str + i) % 6, 0] + 231, positions[(str + i) % 6, 1] + 130, 0);
	                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "戶", positions[(str + i) % 6, 0] + 231, positions[(str + i) % 6, 1] + 110, 0);
	                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "簽", positions[(str + i) % 6, 0] + 231, positions[(str + i) % 6, 1] + 90, 0);
	                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "收", positions[(str + i) % 6, 0] + 231, positions[(str + i) % 6, 1] + 70, 0);
	                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "欄", positions[(str + i) % 6, 0] + 231, positions[(str + i) % 6, 1] + 50, 0);
					}
					
					//DATA
					if(i % 2 == 0) j = i / 2;
					if(i % 2 != 0) k = 8; 
					
                    cb.SetColorFill(iTextSharp.text.BaseColor.BLUE);
                    cb.SetFontAndSize(bfChinese, 10);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Para)barcode[j]).s2.ToString(), positions[(str + i) % 6, 0] + 132, positions[(str + i) % 6, 1] + 205, 0);
                    //cb.SetFontAndSize(bfChinese, 16);
                    //cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Para)barcode[i]).weight.ToString(), positions[(str + i) % 6, 0] + 38, positions[(str + i) % 6, 1] + 175, 0);
                    //cb.SetFontAndSize(bfChinese, 12);
                    //cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "KG", positions[(str + i) % 6, 0] + 55, positions[(str + i) % 6, 1] + 175, 0);
                    cb.SetFontAndSize(bfChinese, 12);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Para)barcode[j]).count.ToString(), positions[(str + i) % 6, 0] + 132, positions[(str + i) % 6, 1] + 165, 0);
                    cb.SetFontAndSize(bfNumber, 40);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, ((Para)barcode[j]).s3, positions[(str + i) % 6, 0] + 225 - k, positions[(str + i) % 6, 1] + 200, 0);
                    

                    cb.SetFontAndSize(bfChinese, 10);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[j]).addressee_line1, positions[(str + i) % 6, 0] + 26, positions[(str + i) % 6, 1] + 142, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[j]).addressee_line2, positions[(str + i) % 6, 0] + 26, positions[(str + i) % 6, 1] + 130, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[j]).addressee_line3, positions[(str + i) % 6, 0] + 26, positions[(str + i) % 6, 1] + 118, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[j]).memo_line1, positions[(str + i) % 6, 0] + 26, positions[(str + i) % 6, 1] + 104, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[j]).memo_line2, positions[(str + i) % 6, 0] + 26, positions[(str + i) % 6, 1] + 92, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[j]).memo_line3, positions[(str + i) % 6, 0] + 26, positions[(str + i) % 6, 1] + 80, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[j]).sender_line1, positions[(str + i) % 6, 0] + 26, positions[(str + i) % 6, 1] + 66, 0);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[j]).sender_line2, positions[(str + i) % 6, 0] + 26, positions[(str + i) % 6, 1] + 54, 0);

                    cb.SetFontAndSize(bfChinese, 16);
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, ((Para)barcode[j]).bag + " 號袋", positions[(str + i) % 6, 0] + 43, positions[(str + i) % 6, 1] + 16, 0);
                    cb.EndText();
                    System.IO.MemoryStream img_barcode = null;
                    iTextSharp.text.Image img = null;
                                 
                    cb.SetFontAndSize(bfChinese, 8);
                    //圖片 96
                    if(((Para)barcode[j]).barcode96.Length>0){
	                    img_barcode = new System.IO.MemoryStream();
	                    GetCode39(((Para)barcode[j]).barcode96).Save(img_barcode, System.Drawing.Imaging.ImageFormat.Bmp);
	                    img = iTextSharp.text.Image.GetInstance(img_barcode.ToArray());
	                    img.SetAbsolutePosition(positions[(str + i) % 6, 0] + 148 - k, positions[(str + i) % 6, 1] + 162);
	                    doc1.Add(img);
                   	}
                   	cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[j]).barcode96, positions[(str + i) % 6, 0] + 200 - k, positions[(str + i) % 6, 1] + 155, 0);                   
                    //圖片 97
                    if(((Para)barcode[j]).barcode97.Length>0){
	                    img_barcode = new System.IO.MemoryStream();
	                    GetCode39(((Para)barcode[j]).barcode97).Save(img_barcode, System.Drawing.Imaging.ImageFormat.Bmp);
	                    img = iTextSharp.text.Image.GetInstance(img_barcode.ToArray());
	                    img.SetAbsolutePosition(positions[(str + i) % 6, 0] + 120- k, positions[(str + i) % 6, 1] + 16);
	                    doc1.Add(img);
                    }  
                    cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Para)barcode[j]).barcode97, positions[(str + i) % 6, 0] + 172 - k, positions[(str + i) % 6, 1] + 9, 0);           
                }
            }
            doc1.Close();
            Response.ContentType = "application/octec-stream;";
            Response.AddHeader("Content-transfer-encoding", "binary");
            Response.AddHeader("Content-Disposition", "attachment;filename=edi.pdf");
            Response.BinaryWrite(stream.ToArray());
            Response.End();
        }

        public System.Drawing.Bitmap GetCode39(string strSource)
        {
            int x = 0; //左邊界
            int y = 0; //上邊界
            int WidLength = 2; //粗BarCode長度
            int NarrowLength = 1; //細BarCode長度
            int BarCodeHeight = 20; //BarCode高度
            int intSourceLength = strSource.Length;
            string strEncode = "010010100"; //編碼字串 初值為 起始符號 *

            string AlphaBet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*"; //Code39的字母

            string[] Code39 = //Code39的各字母對應碼
          {
               /* 0 */ "000110100",
               /* 1 */ "100100001",
               /* 2 */ "001100001",
               /* 3 */ "101100000",
               /* 4 */ "000110001",
               /* 5 */ "100110000",
               /* 6 */ "001110000",
               /* 7 */ "000100101",
               /* 8 */ "100100100",
               /* 9 */ "001100100",
               /* A */ "100001001",
               /* B */ "001001001",
               /* C */ "101001000",
               /* D */ "000011001",
               /* E */ "100011000",
               /* F */ "001011000",
               /* G */ "000001101",
               /* H */ "100001100",
               /* I */ "001001100",
               /* J */ "000011100",
               /* K */ "100000011",
               /* L */ "001000011",
               /* M */ "101000010",
               /* N */ "000010011",
               /* O */ "100010010",
               /* P */ "001010010",
               /* Q */ "000000111",
               /* R */ "100000110",
               /* S */ "001000110",
               /* T */ "000010110",
               /* U */ "110000001",
               /* V */ "011000001",
               /* W */ "111000000",
               /* X */ "010010001",
               /* Y */ "110010000",
               /* Z */ "011010000",
               /* - */ "010000101",
               /* . */ "110000100",
               /*' '*/ "011000100",
               /* $ */ "010101000",
               /* / */ "010100010",
               /* + */ "010001010",
               /* % */ "000101010",
               /* * */ "010010100"
          };


            strSource = strSource.ToUpper();

            //實作圖片
            System.Drawing.Bitmap objBitmap = new System.Drawing.Bitmap(
              ((WidLength * 3 + NarrowLength * 7) * (intSourceLength + 2)) + (x * 2),
              BarCodeHeight + (y * 2));

            System.Drawing.Graphics objGraphics = System.Drawing.Graphics.FromImage(objBitmap); //宣告GDI+繪圖介面
            //填上底色
            objGraphics.FillRectangle(System.Drawing.Brushes.White, 0, 0, objBitmap.Width, objBitmap.Height);

            for (int i = 0; i < intSourceLength; i++)
            {
                if (AlphaBet.IndexOf(strSource[i]) == -1 || strSource[i] == '*') //檢查是否有非法字元
                {
                    objGraphics.DrawString("含有非法字元", System.Drawing.SystemFonts.DefaultFont, System.Drawing.Brushes.Red, x, y);
                    return objBitmap;
                }
                //查表編碼
                strEncode = string.Format("{0}0{1}", strEncode, Code39[AlphaBet.IndexOf(strSource[i])]);
            }

            strEncode = string.Format("{0}0010010100", strEncode); //補上結束符號 *

            int intEncodeLength = strEncode.Length; //編碼後長度
            int intBarWidth;

            for (int i = 0; i < intEncodeLength; i++) //依碼畫出Code39 BarCode
            {
                intBarWidth = strEncode[i] == '1' ? WidLength : NarrowLength;
                objGraphics.FillRectangle(i % 2 == 0 ? System.Drawing.Brushes.Black : System.Drawing.Brushes.White,
                  x, y, intBarWidth, BarCodeHeight);
                x += intBarWidth;
            }
            return objBitmap;
        }
        
    </script>

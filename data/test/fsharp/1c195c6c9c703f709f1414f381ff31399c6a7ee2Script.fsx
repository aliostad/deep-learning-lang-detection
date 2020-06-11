#r @".\bin\Debug\ExcelTypeProvider.dll"
#r @"Microsoft.Office.Interop.Excel.dll"
#r @"office.dll"

open Microsoft.Office.Interop

let filename  = @"C:\Users\e021230\Documents\Visual Studio 11\Projects\exceltypeprovider\Library1\BookTest.xls"
type ExcelFileInternal(filename) =
      let data  = 
         let xlApp = new Excel.ApplicationClass()
         let xlWorkBookInput = xlApp.Workbooks.Open(filename)
         let xlWorkSheetInput = xlWorkBookInput.Worksheets.["Sheet1"] :?> Excel.Worksheet

         // Cache the sequence of all data lines (all lines but the first)
         let firstrow = xlWorkSheetInput.Range(xlWorkSheetInput.Range("A1"), xlWorkSheetInput.Range("A1").End(Excel.XlDirection.xlToRight))
         let rows = xlWorkSheetInput.Range(firstrow, firstrow.End(Excel.XlDirection.xlDown))
         let rows_data = seq { for row  in rows.Rows do 
                                 yield row :?> Excel.Range } |> Seq.skip 1
         let res = 
            seq { for line_data in rows_data do 
                  yield ( seq { for cell in line_data.Columns do
                                 yield (cell  :?> Excel.Range ).Value2} 
                           |> Seq.toArray
                        )
               }
               |> Seq.toArray
         xlWorkBookInput.Close()
         xlApp.Quit()
         res

      member __.Data = data

if false then
   // to kill excels
   //get-process | where-object { $_.name -eq "excel" } | sort-object -property "Starttime" -descending | select-object -skip 1 | foreach { taskkill /pid $_.id }
   let file = ExcelFileInternal(filename)
   printf "%A" file.Data
elif false then
   let file = Samples.FSharpPreviewRelease2011.ExcelProvider.ExcelFileInternal(filename, "Sheet1")
   printf "%A" file.Data
elif false then
   let file = new Samples.FSharpPreviewRelease2011.ExcelProvider.ExcelFile<"BookTest.xls", "Sheet1", true>()
   printf "\n****Using typeprovider***\n"
   printf "%A" file.Data
   let firstrow = file.Data |> Seq.head
   printfn " Field        :   Value in XL         :  Value throught TP"
   printfn " SEC          :   ASI                 :  %A  " firstrow.SEC          
   printfn " UNDERLYING   :   JPY-NIKKEI 225      :  %A  " firstrow.UNDERLYING      
   printfn " STRATEGY     :   DIV_SWAP            :  %A  " firstrow.STRATEGY     
   printfn " STYLE        :   A                   :  %A  " firstrow.STYLE           
   printfn " MATURITIES   :   01-DEC-89           :  %A  " firstrow.MATURITIES   
   printfn " STRIKE 1     :   0,00                :  %A  " firstrow.``STRIKE 1`` 
   printfn " STRIKE 2     :                       :  %A  " firstrow.``STRIKE 2`` 
   printfn " STRIKE 3     :                       :  %A  " firstrow.``STRIKE 3`` 
   printfn " RATIOS       :   -1                  :  %A  " firstrow.RATIOS          
   printfn " REF          :   8.460,76            :  %A  " firstrow.REF
   printfn " BID          :   -1,000              :  %A  " firstrow.BID         
   printfn " FAIR         :   0,000               :  %A  " firstrow.FAIR         
   printfn " OFFER        :   195,000             :  %A  " firstrow.OFFER         
   printfn " INTEREST     :   --                  :  %A  " firstrow.INTEREST         
   printfn " C/P          :   --                  :  %A  " firstrow.``C/P``         
   printfn " SPR(B)       :                       :  %A  " firstrow.``SPR(B)``         
   printfn " VOL          :                       :  %A  " firstrow.VOL         
   printfn " SPR(O)       :                       :  %A  " firstrow.``SPR(O)``         
   printfn " LAST UPDATE  :   21/12/11 01:18      :  %A  " firstrow.``LAST UPDATE``         
   printfn " BROKER       :   TFS Derivatives HK  :  %A  " firstrow.BROKER         
elif true then
   let file = new Samples.FSharpPreviewRelease2011.ExcelProvider.ExcelFile<"BookTest.xls", "ThisIsaRange", true>()
   printf "\n****Using typeprovide range***\n"
   printf "%A" file.Data
   let firstrow = file.Data |> Seq.head
   printfn " Field        :   Value in XL         :  Value throught TP"
   printfn " SEC          :   ASI                 :  %A  " firstrow.SEC          
   printfn " UNDERLYING   :   JPY-NIKKEI 225      :  %A  " firstrow.UNDERLYING      
   printfn " STRATEGY     :   DIV_SWAP            :  %A  " firstrow.STRATEGY     
   printfn " STYLE        :   A                   :  %A  " firstrow.STYLE           
   printfn " MATURITIES   :   01-DEC-89           :  %A  " firstrow.MATURITIES   
   printfn " STRIKE 1     :   0,00                :  %A  " firstrow.``STRIKE 1`` 
   printfn " STRIKE 2     :                       :  %A  " firstrow.``STRIKE 2`` 
   printfn " STRIKE 3     :                       :  %A  " firstrow.``STRIKE 3`` 
   printfn " RATIOS       :   -1                  :  %A  " firstrow.RATIOS          
   printfn " REF          :   8.460,76            :  %A  " firstrow.REF
   printfn " BID          :   -1,000              :  %A  " firstrow.BID         
   printfn " FAIR         :   0,000               :  %A  " firstrow.FAIR         
   printfn " OFFER        :   195,000             :  %A  " firstrow.OFFER         
   printfn " INTEREST     :   --                  :  %A  " firstrow.INTEREST         
   printfn " C/P          :   --                  :  %A  " firstrow.``C/P``         
   printfn " SPR(B)       :                       :  %A  " firstrow.``SPR(B)``         
   printfn " VOL          :                       :  %A  " firstrow.VOL         
   printfn " SPR(O)       :                       :  %A  " firstrow.``SPR(O)``         
   printfn " LAST UPDATE  :   21/12/11 01:18      :  %A  " firstrow.``LAST UPDATE``         
   printfn " BROKER       :   TFS Derivatives HK  :  %A  " firstrow.BROKER         
 elif false then  //ThisIsaRange
   let file = new Samples.FSharpPreviewRelease2011.ExcelProvider.ExcelFile<"BookTestBrokernet.xls", "Brokernet", true>()
   printf "\n****Using typeprovider with custom sheet name***\n"
   printf "%A" file.Data
else 
   let file = new Samples.FSharpPreviewRelease2011.ExcelProvider.ExcelFile<"BookTestBig.xls", "Sheet1", true>()
   printf "\n****Using typeprovider with BIG file - actually not so much but it is slow nonetheless... - ***\n"
   printf "%A" file.Data
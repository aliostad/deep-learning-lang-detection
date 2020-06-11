$VerbosePreference = 'continue'

# This is where you put your API key for Quandl
$API_Key = "{YourAPIKeyHere}"

function get-StockHistoryForCompany ($Ticker) 
{
    $i = 1;
    $DataAPI_URL = "https://www.quandl.com/api/v3/datasets/WIKI/$Ticker.csv?api_key=$API_Key";
    $WebRequest = Invoke-WebRequest $DataAPI_URL;

    write-verbose $DataAPI_URL;

    if(!$WebRequest)
    { 
        write-error "The webrequest made to gather stock information has failed for $Ticker";
        read-host "Hit any key to continue."
        return;
    }

    $webrequest = $WebRequest.Split("`n");
    $ubound = $WebRequest.Length;

    $List = @()

    foreach( $StocksForThisDay in $WebRequest[1..$ubound])
    {


        # Manage progress bar
        $Percent =  ($i / $ubound ) * 100 

        write-progress -activity "Search in Progress for $Ticker" `
                    -status "$Percent % Complete:" `
                    -percentcomplete $Percent;
        
        $i += 1;

        # Break data apart into object
        $ArrayItemsInRow = $stocksForThisDay.Split(",");

        if(!$ArrayItemsInRow)
        {
            continue;
        }

        [datetime]$Day = get-date $ArrayItemsInRow[0];
        $Open = $ArrayItemsInRow[1]
        $High = $ArrayItemsInRow[2]
        $Low = $ArrayItemsInRow[3]
        $Close = $ArrayItemsInRow[4]
        $volume =  $ArrayItemsInRow[5]
        

       $CollectionOFStocks = new-object PSCustomObject -Property  @{
       Ticker = $Ticker
        Day = $Day
        Open = $Open
        High = $High
        Low = $Low
        Close  = $Close
        volume = $volume
        DaysSinceHighest = ""
        }

        [array]$List += $CollectionOFStocks;

    }

    return $List
    
}


Function Gather-AllStockHistory 
{

PARAM ([array]$ListOfTickers)
BEGIN {
    $CompleteList = @()
}
PROCESS
{
    $Symbol = $_;
    Write-Verbose "$symbol"

    # Fetch all daily stock records for the given symbol / ticker ...
    $AllStocksCurCompany = get-StockHistoryForCompany $Symbol;

    $Highest = ($AllStocksCurCompany | measure-object -Maximum high).Maximum
    $Lowest = ($AllStocksCurCompany | measure-object -minimum low).Minimum
    
    write-host "Highest value for $Symbol was: $($Highest) "
    write-host "Lowest value for $Symbol was: $($Lowest) "

    [array]$CompleteList += $AllStocksCurCompany
    
}
END
{
    #Return the array which contains all requested data
    return $CompleteList;
}
}



# Array containing symbol of example companies of interest
$TickersToProcess = @("AAPL","TSLA","GOOG","MSFT", "FB","TWTR");

[array]$History = $TickersToProcess | Gather-AllStockHistory;


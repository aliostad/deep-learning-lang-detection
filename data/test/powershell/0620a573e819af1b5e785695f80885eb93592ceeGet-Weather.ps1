function Weather ($city){    
    $country = "us"
    $api = "692447105f67a34c06d1cbeab56b17c5"
    [xml]$wr = Invoke-WebRequest "api.openweathermap.org/data/2.5/weather?q=$City,$country&APPID=$api&mode=xml"
    $data = $wr.current
    $tempNOW = ([math]::Round(($data.temperature.min - 273.15)*9/5+32)) 
    $weather = [PSCustomObject]@{
                                City       =  $data.city.name + ","+ $data.city.country
                                Weather    =  $data.weather.value
                                TempNOW    =  $tempNOW
                                tempMAX    = ([math]::Round(($data.temperature.max - 273.15)*9/5+32))
                                TempMIN    = ([math]::Round(($data.temperature.min - 273.15)*9/5+32)) 
                                humidity   =  $data.humidity.value + $data.humidity.unit
                                Clouds     =  $data.clouds.name
                                Rain       =  $data.precipitation.mode
                                Wind       =  $data.wind.Value
                                pressure   =  $data.pressure.value
}
    return $weather
}
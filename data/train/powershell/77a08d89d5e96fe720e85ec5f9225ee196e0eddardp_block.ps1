# 이벤트로그를 사용하여 특정 회수 이상 로그인 실패 아이피에 대하여 
# MY BLACKLIST 방화벽 등록
# 2014.05.22 NDH
# version 1.1


###################### Config ###################### 
#regex2 부분이 영문 윈도우OS 같은 경우 source network address 인가로 바꿔주면 된다.
#MyIp 부분은 내 아이피를 등록하여 내꺼는 막히지 않도록 하는 부분이고,
#deny_count 는 5회이상 접속시도 실패 로그가 있을 시 방화벽에 차단 등록하는 변수이다.
#deny_rule_name 는 윈도우 방화벽에 차단하는 해당 룰 이름이 설정되어 있어야 한다. 

 #English versoin Windows
 #$regex2 = [regex] "Source Network Address:\t(\d+\.\d+\.\d+\.\d+)";
 #Korean version Windows
 $regex2 = [regex] "원본 네트워크 주소:\t(\d+\.\d+\.\d+\.\d+)";
 $MyIp = "222.122.20.*";
 $deny_count = 5;
 $deny_rule_name = "MY BLACKLIST"
###################### Config ###################### 


$fw=New-object -comObject HNetCfg.FwPolicy2; # http://blogs.technet.com/b/jamesone/archive/2009/02/18/how-to-manage-the-windows-firewall-settings-with-powershell.aspx 
$RuleCHK=$fw.rules | where-object {$_.name –eq $deny_rule_name}
if(!$RuleCHK){ $deny_rule_name + " rule does not generate."; exit; }


$blacklist = @();
$list ="";

$startTime = (get-date);

 "-----------------------------"
 "log searching Start : " + $startTime; 
 "-----------------------------"


$ips = get-eventlog Security  | Where-Object {$_.EventID -eq 4625 } | foreach {
$m = $regex2.Match($_.Message); $ip = $m.Groups[1].Value; $ip; } | Sort-Object | Tee-Object -Variable list | Get-Unique 


if($list.length -gt 0) {
    foreach ( $attack_ip in $list) 
    {
        if($attack_ip){
            $myrule = $fw.Rules | where {$_.Name -eq $deny_rule_name} | select -First 1; # Potential bug here? 
       
            if (-not ($blacklist -contains $attack_ip)) 
             {
                $attack_count = ($list | Select-String $attack_ip -SimpleMatch | Measure-Object).count; 
                if ($attack_count -ge $deny_count) {
                        if (-not ($myrule.RemoteAddresses -match $attack_ip) -and -not ($attack_ip -like  $MyIp)) 
                         {
                            "Found RDP attacking IP on 3389: " + $attack_ip + ", with count: " + $attack_count;                      
                            $blacklist = $blacklist + $attack_ip;
                            "Adding this IP into firewall blocklist: " + $attack_ip;  
                            #$myrule.RemoteAddresses+=(","+$attack_ip); 
                            netsh.exe advfirewall firewall add rule name="$deny_rule_name" dir=out action=block localip=any remoteip="$attack_ip" profile="any" interfacetype="any"
                            #echo $attack_ip >>  C:\BlackListIP.txt
                            
                         } else {
                             $attack_ip + " : Already registered IP"
                         }
                   }
             }
          }

    }

    $answer = read-host "`ndo you want delete security event log , yes or no"
    if ($answer -like "*y*" -and -not $Verbose) { 
        Clear-EventLog -LogName Security 
         cls 
         "Security event log has been deleted"
     }  
    else {
        # "`nScript terminated.`nPlease use your testing VM instead.`n" ; exit 
    } 

    
}else{
    "인증 실패 이벤트 로그가 없습니다."
}

$endTime = (get-date);



 "-----------------------------"
 " 총 걸린 시간 : " +   ($endTime - $startTime ) ;
 ".........실행 완료..........." 
 "-----------------------------"
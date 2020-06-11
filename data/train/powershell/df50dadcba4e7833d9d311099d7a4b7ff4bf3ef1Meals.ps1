## Step1: 把备选的餐厅添加到选项当中
$meals = @(
    "紫荆园 | Tel: 62771660 | 6:30-13:00，16:30-19:30";
    "桃李园 | 6:30-13:15, 16:50-19:30";
    "丁香园 | 7:00-9:00, 11:00-13:00, 17:00-19:00";
    "清青快餐 | Tel: 62782865 | 10:30-22:30")

## Step2: 随机选择一个餐厅
$choice = "懒人订餐： " + $meals[ (get-random) % ($meals.count) ]
echo $choice

## 导入UI库
function Show-MessageBox ([string]$message) { 
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null 
    [Windows.Forms.MessageBox]::Show($message) | Out-Null
}

## Step3: 告诉用户选择情况
Show-MessageBox $choice
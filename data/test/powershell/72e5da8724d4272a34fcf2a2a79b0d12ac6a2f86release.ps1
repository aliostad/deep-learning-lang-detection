#
# Copyright 2007
#     PYRASIS.COM,.  All rights reserved.
#
# http://www.pyrasis.com
#
# Author:
#     Lee Jae-Hong (pyrasis)
#

# release.ps1 <Release Path> <Source Path>

$release = $args[0]
$source = $args[1]
$logfile = "C:\Windows\temp\log.xml"

# $source 디렉토리의 마지막 커밋 로그를 $logfile로 저장
svn log $source -r COMMITTED > $logfile
$log = get-content -path $logfile

# trac에서 로그 메시지를 정상적으로 보여주기 위해 줄바꿈이 될 때 [[BR]] 추가.
# 단 ---는 통과
for ($i = 1; $i -lt 128; $i++)
{
	if ($log[$i] -match "---") {break}

	$message += "[[BR]]" + $log[$i]
}

# 로그 내용에서 " 과 ' 삭제
# 로그 내용에 " 과 '이 있으면 커맨드 라인에서는 경로로 인식하여 커밋이 정상적으로 되지 않음.
$message = $message.replace("`"", "")
$message = $message.replace("`'", "")

# 빌드된 파일을 추가한 뒤 커밋, 사용자명과 암호를 지정해야 함.
svn add $release --force
svn ci $release -m "$message" --username sampleuser --password abcd1234 --no-auth-cache

# 임시 저장한 로그 파일 삭제.
del $logfile

# $source 디렉토리를 원래대로 되돌림.
C:\tools\revert.ps1 $source

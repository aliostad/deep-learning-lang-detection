'ITG.WinAPI.UrlMon' `
| Import-Module;

function Invoke-REST {
	<#
		.Component
			ITG.Web.Rest.
		.Synopsis
		.Description
		.Outputs
			[xml] - Результат, возвращённый API.
	#>

	[CmdletBinding(
		SupportsShouldProcess=$true,
        ConfirmImpact="Medium"
	)]
    
    param (
		# метод API 
        [Parameter(
			Mandatory=$true
		)]
        [string]
		$method
	,
		# коллекция параметров метода API
		[System.Collections.IDictionary]
		$Params = @{}
	,
		# предикат успешного выполнения метода API
		[scriptblock]
		$IsSuccessPredicate = { [bool]$_.action.status.success }
	,
		# предикат ошибки при выполнении метода API. Если ни один из предикатов не вернёт $true - генерируем неизвестную ошибку
		[scriptblock]
		$IsFailurePredicate = { [bool]$_.action.status.error }
	,
		# фильтр обработки результата. Если фильтр не задан - функция не возвращает результат.
		[scriptblock]
		$ResultFilter = {}
	,
		# Шаблон сообщения об успешном выполнении API.
		[string]
		$SuccessMsg = "Метод API $method успешно выполнен для домена $DomainName."
	,
		# Шаблон сообщения об ошибке вызова API.
		[string]
		$FailureMsg = "Ошибка при вызове метода API $method для домена $DomainName"
	,
		# Фильтр обработки результата для выделения сообщения об ошибке.
		[scriptblock]
		$FailureMsgFilter = { $_.action.status.error.'#text' }
	,
		# Шаблон сообщения о недиагностируемой ошибке вызова API.
		[string]
		$UnknownErrorMsg = "Неизвестная ошибка при вызове метода API $method для домена $DomainName."
	)

<#
    $Params.Add( 'token', $Token );
	$Params.Add( 'domain', $DomainName );
	$escapedParams = (
		$Params.keys `
		| % { "$_=$([System.Uri]::EscapeDataString($Params.$_))" } `
	) -join '&';
	$apiURI = [System.Uri]"$APIRoot/$method.xml?$escapedParams";
	$wc = New-Object System.Net.WebClient;
	if ( $PSCmdlet.ShouldProcess( $DomainName, "Yandex.API.PDD::$method" ) ) {
		try {
			Write-Verbose "Вызов API $method для домена $($DomainName): $apiURI.";
			$res = ( [xml]$wc.DownloadString( $apiURI ) );
			Write-Debug "Ответ API $method: $($res.innerXml).";
		
			$_ = $res;
			if ( & $IsSuccessPredicate ) {
				Write-Verbose $SuccessMsg;
				& $ResultFilter;
			} elseif ( & $IsFailurePredicate ) {
				Write-Error `
					-Message "$FailureMsg - ($( & $FailureMsgFilter ))" `
					-Category CloseError `
					-CategoryActivity 'Yandex.API' `
					-RecommendedAction 'Проверьте правильность указания домена и Ваши права на домен.' `
				;
			} else { # недиагностируемая ошибка вызова API
				Write-Error `
					-Message $UnknownErrorMsg `
					-Category InvalidResult `
					-CategoryActivity 'Yandex.API' `
					-RecommendedAction 'Проверьте параметры.' `
				;
			};
		} catch [System.Management.Automation.MethodInvocationException] {
			Write-Error `
				-Message "$UnknownErrorMsg ($($_.Exception.Message))." `
				-Category InvalidOperation `
				-CategoryActivity 'Yandex.API' `
			;
		};
	};
#>
}  

Export-ModuleMember `
    Invoke-REST `
;

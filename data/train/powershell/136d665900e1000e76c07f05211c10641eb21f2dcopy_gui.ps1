function CopyContent {
    param([string]$source, [string]$target_dir)
	"Copying from $source to $target_dir"
	if (!($target_dir.endswith("\"))){$target_dir += "\"}
	if (!(test-path ($target_dir))){mkdir ($target_dir)}

	copy-Item $source $target_dir
}

function CopyContentRecursive {
    param([string]$source, [string]$target_dir)
	"Copying from $source to $target_dir"
	if (!($target_dir.endswith("\"))){$target_dir += "\"}
	if (!(test-path ($target_dir))){mkdir ($target_dir)}

	copy-Item $source $target_dir -recurse
}

function ConvertToTemplate {
	param([string]$path, [string]$patternToReplace = "vlko.web", [string]$replacement = "`$safeprojectname`$")
	"Templating folder $path"
	$files = gci $path | Where-Object {$_.PSIsContainer -eq $False}
	foreach ($file in $files){
		(Get-Content $file) | Foreach-Object { $_ -replace $patternToReplace, $replacement } | Set-Content $file
	}
}

function RegexReplace {
	param([string]$path, [string]$regexPattern, [string]$replacement)
	"Replacing $path for regex $regexPattern with replacement $replacement"
    $regex = new-object Text.RegularExpressions.Regex $regexPattern, ('singleline')
	$text = (Get-Content $path) -join "`n"
    $stripped = $regex.Replace($text ,$replacement)
	Set-Content $path $stripped
}

"starting"
remove-Item ".\lib\UI\" -recurse
# copy controllers
CopyContent "..\vlko.web\Controllers\AccountController.cs" ".\lib\UI\Controllers"
ConvertToTemplate  ".\lib\UI\Controllers\*.cs"
# copy view model
CopyContent "..\vlko.web\ViewModel\Account\*.cs" ".\lib\UI\ViewModel\Account"
ConvertToTemplate  ".\lib\UI\ViewModel\Account\*.cs"
# copy views
CopyContent "..\vlko.web\Views\Account\*.cshtml" ".\lib\UI\Views\Account"
ConvertToTemplate  ".\lib\UI\Views\Account\*.cshtml"
# copy gui base parts
CopyContent "..\vlko.web\Views\_ViewStart.cshtml" ".\lib\UI\Views"
CopyContent "..\vlko.web\Views\Web.config" ".\lib\UI\Views"
ConvertToTemplate  ".\lib\UI\Views\*"
# copy base views and convert default layout
CopyContent "..\vlko.web\Views\Shared\*.cshtml" ".\lib\UI\Views\Shared"
RegexReplace ".\lib\UI\Views\Shared\_Layout.cshtml" "<div\ id=`"search`">.*?\}\s" "<div id=`"search`">"
RegexReplace ".\lib\UI\Views\Shared\_Layout.cshtml" "<ul\ id=`"menu`">.*?\}\s" "<ul id=`"menu`">`n`t`t`t`t`t<li>@Html.Link(`"Home`", (object)Routes.IndexOfHome())</li>`n"
ConvertToTemplate  ".\lib\UI\Views\Shared\*"
# copy display templates
CopyContent "..\vlko.web\Views\Shared\DisplayTemplates\*" ".\lib\UI\Views\Shared\DisplayTemplates"
ConvertToTemplate  ".\lib\UI\Views\Shared\DisplayTemplates\*"
# copy editor templates
CopyContent "..\vlko.web\Views\Shared\EditorTemplates\*" ".\lib\UI\Views\Shared\EditorTemplates"
ConvertToTemplate  ".\lib\UI\Views\Shared\EditorTemplates\*"
# copy T4 templates
CopyContent "..\vlko.web\CodeTemplates\AddView\CSHTML\*.tt" ".\lib\UI\CodeTemplates\AddView\CSHTML"
# copy scripts
CopyContent "..\vlko.web\Scripts\Common.js" ".\lib\UI\Scripts"
CopyContent "..\vlko.web\Scripts\Grid.js" ".\lib\UI\Scripts"
CopyContent "..\vlko.web\Scripts\jquery.ba-bbq.js" ".\lib\UI\Scripts"
CopyContent "..\vlko.web\Scripts\jquery.ui.datepicker-sk.js" ".\lib\UI\Scripts"
CopyContent "..\vlko.web\Scripts\jquery.validate.unobtrusive.custom.js" ".\lib\UI\Scripts"
CopyContent "..\vlko.web\Scripts\Pager.js" ".\lib\UI\Scripts"
CopyContent "..\vlko.web\Scripts\Upload\ajaxupload.js" ".\lib\UI\Scripts\Upload"
CopyContentRecursive "..\vlko.web\Scripts\tiny_mce\*" ".\lib\UI\Scripts\tiny_mce"
# copy css
CopyContent "..\vlko.web\Content\*.scss" ".\lib\UI\Content"
CopyContent "..\vlko.web\Content\Site.css" ".\lib\UI\Content"
CopyContent "..\vlko.web\Content\jquery-ui.custom.css" ".\lib\UI\Content"
# copy images
CopyContent "..\vlko.web\Content\images\*" ".\lib\UI\Content\images"

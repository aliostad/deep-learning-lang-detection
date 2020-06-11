param($installPath, $toolsPath, $package, $project)

. (Join-Path $toolsPath common.ps1)

# Auto complete off (MVC 4)
Update-View $project "Account" "_ChangePasswordPartial.cshtml" "@Html\.PasswordFor\(m => m\.OldPassword\)" "@Html.PasswordFor(m => m.OldPassword, new { autocomplete = ""off"" })"
Update-View $project "Account" "_ChangePasswordPartial.cshtml" "@Html\.PasswordFor\(m => m\.NewPassword\)" "@Html.PasswordFor(m => m.NewPassword, new { autocomplete = ""off"" })"
Update-View $project "Account" "_ChangePasswordPartial.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword\)" "@Html.PasswordFor(m => m.ConfirmPassword, new { autocomplete = ""off"" })"
Update-View $project "Account" "Login.cshtml" "@Html\.TextBoxFor\(m => m\.UserName\)" "@Html.TextBoxFor(m => m.UserName, new { autocomplete = ""off"" })"
Update-View $project "Account" "Login.cshtml" "@Html\.PasswordFor\(m => m\.Password\)" "@Html.PasswordFor(m => m.Password, new { autocomplete = ""off"" })"
Update-View $project "Account" "Register.cshtml" "@Html\.TextBoxFor\(m => m\.UserName\)" "@Html.TextBoxFor(m => m.UserName, new { autocomplete = ""off"" })"
Update-View $project "Account" "Register.cshtml" "@Html\.PasswordFor\(m => m\.Password\)" "@Html.PasswordFor(m => m.Password, new { autocomplete = ""off"" })"
Update-View $project "Account" "Register.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword\)" "@Html.PasswordFor(m => m.ConfirmPassword, new { autocomplete = ""off"" })"

# Auto complete off (MVC > 4)
Update-View $project "Account" "Login.cshtml" "@Html\.TextBoxFor\(m => m\.Email, new \{ @class = ""form-control"" \}\)" "@Html.TextBoxFor(m => m.Email, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Account" "Login.cshtml" "@Html\.TextBoxFor\(m => m\.UserName, new \{ @class = ""form-control"" \}\)" "@Html.TextBoxFor(m => m.UserName, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Account" "Login.cshtml" "@Html\.PasswordFor\(m => m\.Password, new \{ @class = ""form-control"" \}\)" "@Html.PasswordFor(m => m.Password, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Account" "ForgotPassword.cshtml" "@Html\.TextBoxFor\(m => m\.Email, new \{ @class = ""form-control"" \}\)" "@Html.TextBoxFor(m => m.Email, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Account" "Register.cshtml" "@Html\.TextBoxFor\(m => m\.Email, new \{ @class = ""form-control"" \}\)" "@Html.TextBoxFor(m => m.Email, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Account" "Register.cshtml" "@Html\.TextBoxFor\(m => m\.UserName, new \{ @class = ""form-control"" \}\)" "@Html.TextBoxFor(m => m.UserName, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Account" "Register.cshtml" "@Html\.PasswordFor\(m => m\.Password, new \{ @class = ""form-control"" \}\)" "@Html.PasswordFor(m => m.Password, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Account" "Register.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword, new \{ @class = ""form-control"" \}\)" "@Html.PasswordFor(m => m.ConfirmPassword, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Account" "ResetPassword.cshtml" "@Html\.TextBoxFor\(m => m\.Email, new \{ @class = ""form-control"" \}\)" "@Html.TextBoxFor(m => m.Email, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Account" "ResetPassword.cshtml" "@Html\.PasswordFor\(m => m\.Password, new \{ @class = ""form-control"" \}\)" "@Html.PasswordFor(m => m.Password, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Account" "ResetPassword.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword, new \{ @class = ""form-control"" \}\)" "@Html.PasswordFor(m => m.ConfirmPassword, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Manage" "ChangePassword.cshtml" "@Html\.PasswordFor\(m => m\.OldPassword, new \{ @class = ""form-control"" \}\)" "@Html.PasswordFor(m => m.OldPassword, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Manage" "ChangePassword.cshtml" "@Html\.PasswordFor\(m => m\.NewPassword, new \{ @class = ""form-control"" \}\)" "@Html.PasswordFor(m => m.NewPassword, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Manage" "ChangePassword.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword, new \{ @class = ""form-control"" \}\)" "@Html.PasswordFor(m => m.ConfirmPassword, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Manage" "SetPassword.cshtml" "@Html\.PasswordFor\(m => m\.NewPassword, new \{ @class = ""form-control"" \}\)" "@Html.PasswordFor(m => m.NewPassword, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "Manage" "SetPassword.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword, new \{ @class = ""form-control"" \}\)" "@Html.PasswordFor(m => m.ConfirmPassword, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "UsersAdmin" "Create.cshtml" "@Html\.TextBoxFor\(m => m\.Email, new \{ @class = ""form-control"" \}\)" "@Html.TextBoxFor(m => m.Email, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "UsersAdmin" "Create.cshtml" "@Html\.PasswordFor\(m => m\.Password, new \{ @class = ""form-control"" \}\)" "@Html.PasswordFor(m => m.Password, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "UsersAdmin" "Create.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword, new \{ @class = ""form-control"" \}\)" "@Html.PasswordFor(m => m.ConfirmPassword, new { @class = ""form-control"", autocomplete = ""off"" })"
Update-View $project "UsersAdmin" "Edit.cshtml" "@Html\.TextBoxFor\(m => m\.Email, new \{ @class = ""form-control"" \}\)" "@Html.TextBoxFor(m => m.Email, new { @class = ""form-control"", autocomplete = ""off"" })"

# Mvc 1 & 2: open-redirection
Update-Controller $project "AccountController.cs" "if \(\!String\.IsNullOrEmpty\(returnUrl\)\)" "if (Url.IsLocalUrl(returnUrl))"


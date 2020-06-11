param($installPath, $toolsPath, $package, $project)

. (Join-Path $toolsPath common.ps1)

# Auto complete off (MVC 4)
Update-View $project "Account" "_ChangePasswordPartial.cshtml" "@Html\.PasswordFor\(m => m\.OldPassword, new \{ autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.OldPassword)"
Update-View $project "Account" "_ChangePasswordPartial.cshtml" "@Html\.PasswordFor\(m => m\.NewPassword, new \{ autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.NewPassword)"
Update-View $project "Account" "_ChangePasswordPartial.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword, new \{ autocomplete = ""off""\ }\)" "@Html.PasswordFor(m => m.ConfirmPassword)"
Update-View $project "Account" "Login.cshtml" "@Html\.TextBoxFor\(m => m\.UserName, new \{ autocomplete = ""off"" \}\)" "@Html.TextBoxFor(m => m.UserName)"
Update-View $project "Account" "Login.cshtml" "@Html\.PasswordFor\(m => m\.Password, new \{ autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.Password)"
Update-View $project "Account" "Register.cshtml" "@Html\.TextBoxFor\(m => m\.UserName, new \{ autocomplete = ""off"" \}\)" "@Html.TextBoxFor(m => m.UserName)"
Update-View $project "Account" "Register.cshtml" "@Html\.PasswordFor\(m => m\.Password, new \{ autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.Password)"
Update-View $project "Account" "Register.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword, new \{ autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.ConfirmPassword)"

# Auto complete off (MVC > 4)
Update-View $project "Account" "Login.cshtml" "@Html\.TextBoxFor\(m => m\.Email, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.TextBoxFor(m => m.Email, new { @class = ""form-control"" })"
Update-View $project "Account" "Login.cshtml" "@Html\.TextBoxFor\(m => m\.UserName, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.TextBoxFor(m => m.UserName, new { @class = ""form-control"" })"
Update-View $project "Account" "Login.cshtml" "@Html\.PasswordFor\(m => m\.Password, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.Password, new { @class = ""form-control"" })"
Update-View $project "Account" "ForgotPassword.cshtml" "@Html\.TextBoxFor\(m => m\.Email, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.TextBoxFor(m => m.Email, new { @class = ""form-control"" })"
Update-View $project "Account" "Register.cshtml" "@Html\.TextBoxFor\(m => m\.Email, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.TextBoxFor(m => m.Email, new { @class = ""form-control"" })"
Update-View $project "Account" "Register.cshtml" "@Html\.TextBoxFor\(m => m\.UserName, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.TextBoxFor(m => m.UserName, new { @class = ""form-control"" })"
Update-View $project "Account" "Register.cshtml" "@Html\.PasswordFor\(m => m\.Password, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.Password, new { @class = ""form-control"" })"
Update-View $project "Account" "Register.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.ConfirmPassword, new { @class = ""form-control"" })"
Update-View $project "Account" "ResetPassword.cshtml" "@Html\.TextBoxFor\(m => m\.Email, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.TextBoxFor(m => m.Email, new { @class = ""form-control"" })"
Update-View $project "Account" "ResetPassword.cshtml" "@Html\.PasswordFor\(m => m\.Password, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.Password, new { @class = ""form-control"" })"
Update-View $project "Account" "ResetPassword.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.ConfirmPassword, new { @class = ""form-control"" })"
Update-View $project "Manage" "ChangePassword.cshtml" "@Html\.PasswordFor\(m => m\.OldPassword, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.OldPassword, new { @class = ""form-control"" })"
Update-View $project "Manage" "ChangePassword.cshtml" "@Html\.PasswordFor\(m => m\.NewPassword, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.NewPassword, new { @class = ""form-control"" })"
Update-View $project "Manage" "ChangePassword.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.ConfirmPassword, new { @class = ""form-control"" })"
Update-View $project "Manage" "SetPassword.cshtml" "@Html\.PasswordFor\(m => m\.NewPassword, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.NewPassword, new { @class = ""form-control"" })"
Update-View $project "Manage" "SetPassword.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.ConfirmPassword, new { @class = ""form-control"" })"
Update-View $project "UsersAdmin" "Create.cshtml" "@Html\.TextBoxFor\(m => m\.Email, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.TextBoxFor(m => m.Email, new { @class = ""form-control"" })"
Update-View $project "UsersAdmin" "Create.cshtml" "@Html\.PasswordFor\(m => m\.Password, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.Password, new { @class = ""form-control"" })"
Update-View $project "UsersAdmin" "Create.cshtml" "@Html\.PasswordFor\(m => m\.ConfirmPassword, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.PasswordFor(m => m.ConfirmPassword, new { @class = ""form-control"" })"
Update-View $project "UsersAdmin" "Edit.cshtml" "@Html\.TextBoxFor\(m => m\.Email, new \{ @class = ""form-control"", autocomplete = ""off"" \}\)" "@Html.TextBoxFor(m => m.Email, new { @class = ""form-control"" })"

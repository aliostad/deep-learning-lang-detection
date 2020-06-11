$target = $args[0]        # ie "\\testserver\e$"
 
# if you need to authenticate
# net use $target "password" /USER:BuildServerUser
 
if (-not($target)) {
    Write-Output "You must provide a deployment location param as second item. Exiting!"
    Exit
}

Write-Output "Write this text as output"

Copy-Item 'MvcApplication1' "${target}\MvcApplication1\" -Force -Recurse

# Copy-Item 'SameWebsite\Content' "${target}\Websites\SampleWebsite\" -Force -Recurse
# Copy-Item 'SameWebsite\Scripts' "${target}\Websites\SampleWebsite\" -Force -Recurse
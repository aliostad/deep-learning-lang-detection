@{
    Question = "What is PowerShell Pipeworks?"
    Answer = "PowerShell Pipeworks is a framework for making Sites, Services, and Applications with PowerShell."
}, @{
    Question = "How Much Does PowerShell Pipeworks Cost?"
    Answer = "PowerShell Pipeworks is free to use.  The source code is released to the public domain.  It is privately developed by <a href='http://start-automating.com/'>Start-Automating</a>"
}, @{
    Question = "Who made PowerShell Pipeworks?"
    Answer = "PowerShell Pipeworks is developed by <a href='http://start-automating.com/'>Start-Automating</a>"   
}, @{
    Question = "What are the prerequesties for PowerShell Pipeworks?"
    Answer = "PowerShell Pipeworks will work anywhere that PowerShell 2.0 and ASP.NET are installed"
}, @{
    Question = "What 'brand name' hosts can support a PowerShell Pipeworks site?"
    Answer = "PowerShell Pipeworks will work anywhere that PowerShell 2.0 and ASP.NET are installed, and Windows PowerShell is a major component modern IIS automation.  Most hosts will have it installed by default.  PowerShellPipeworks.com is hosted on Windows Azure, but any WebMatrix Host will work, as will any Amazon EC2 Server 2008 R2 instances,  and web hosting companies Supporting IIS 7.5"
}, @{
    Question = "How do I put PowerShell inline within HTML?"
    Answer = "You can include Powershell inline by using &lt;| ... |&gt;.  If you prefer an XML tag, you can use &lt;psh&gt; ... &lt;/psh&gt; .  If you prefer a tag with a question mark, you can use &lt;?psh ... ?&gt;"
}, @{
    Question = "What does Out-HTML do?"
    Answer = "Out-HTML translated the PowerShell formatting engine into HTML, and is primarily used to create tables"
    
}, @{
    Question = "What's a Command Service?"
    Answer = "A command service is a REST web service surrounding a single PowerShell command.  <a href='AboutCommandServices.aspx'>Find out More about Command Services</a>"   
}, @{
    Question = "How do I secure a Command Service?"
    Answer = "A command service should be carefully threat modeled before it is deployed, and should always be run as a low-rights user.  <a href='AboutCommandServices.aspx#CommandServiceSecurity'>Find out More about Command Service Security</a>"   
},  @{
    Question = "What's a Module Service?"
    Answer = "A module service is a REST web service surrounding a PowerShell module.  It provides module metadata and discovery information, and helps manage the web site around the module.  <a href='AboutModuleServices.aspx'>Find out More about Module Services</a>"   
}
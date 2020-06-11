## http://ikarstein.wordpress.com/2011/09/20/powershell-tool-to-enumerate-the-content-type-usage-in-sharepoint-2010/

#region Init
    Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  | Out-Null
    cls
#endregion

#region Form
    $form = New-Object System.Windows.Forms.Form

    $button = New-Object System.Windows.Forms.Button
    $treeview = New-Object System.Windows.Forms.TreeView

    $form.SuspendLayout()

    $button.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $button.Dock = [System.Windows.Forms.DockStyle]::Bottom
    $button.Location = (new-object System.Drawing.Point(0, 250))
    $button.Name = "button1"
    $button.Size = (new-object System.Drawing.Size(292, 23))
    $button.TabIndex = 0
    $button.Text = "Close"
    $button.UseVisualStyleBackColor = $true

    $treeview.Dock = [System.Windows.Forms.DockStyle]::Fill
    $treeview.Location = (new-object System.Drawing.Point(0, 0))
    $treeview.Name = "treeView1"
    $treeview.Size = (new-object System.Drawing.Size(292, 250))
    $treeview.TabIndex = 1

    $form.AutoScaleDimensions = new-object System.Drawing.SizeF(6.0, 13.0)
    $form.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
    $form.ClientSize = (new-object System.Drawing.Size(292, 273))
    $form.Controls.Add($button)
    $form.Controls.Add($treeview)
    $form.Name = "Content Type Usage "
    $form.Text = "Content Type Usage / http://ikarstein.wordpress.com"
    $form.ResumeLayout($false)
#endregion

$list = @{}

$treeview.add_NodeMouseDoubleClick({
    param($sender, $eventArgs)
    if($eventArgs.Node.Tag -ne $null ) {
        [System.Diagnostics.Process]::Start($eventArgs.Node.Tag)
    }
});

function analyseWeb {
    param([Microsoft.SharePoint.SPWeb]$web) 

    $web.ContentTypes | % {
        $ct = $_
        $global:list += @{"$($ct.Id)"=$ct}
    }

    $web.lists | % {
        $_.ContentTypes | % {
            $ct = $_
            $global:list += @{"$($ct.Id)"=$ct}
        }
    }

    $web.Webs | % {
        analyseWeb -web $_
    }
}

function reorder {
    param([Microsoft.SharePoint.SPContentType]$p = $null, [int]$intend, [System.Windows.Forms.TreeNode]$parentNode)

    if( $p -eq $null ) {
        $ct = $list["0x"]

        $tn = New-Object System.Windows.Forms.TreeNode("System")
        $tn.ToolTipText = "0x"
        $parentNode.Nodes.Add($tn) | Out-Null

        reorder -p $ct -intend 0 -parentNode $tn
    } else {
        ($list.Values | ? {$_.Id.IsChildOf($p.Id) -and $_ -ne $p} | sort @{Expression={$_.Id.ToString().Length}}, $_.Id.ToString() ) | % {
            $ct = $_
            $type=""
            $url=""
            $tn = $null

            if( $ct.ParentList -ne $null ) {
                $type="(List) $($ct.Name) / List: $($ct.ParentList.Title) / Id: $($ct.Id.ToString())"
                $url = $ct.parentweb.url + "/_layouts/ManageContentType.aspx?ctype=" + $ct.Id.ToString()+"&List="+$ct.ParentList.Id.ToString()

                #http://<domain>/sites/<web>/_layouts/ManageContentType.aspx?List=%7B111963EB%2DF504%2D49EC%2DA21B%2D814319718684%7D&ctype=0x010100644EE9F5F657474B92A2716207BB5DE2

                $tn = New-Object System.Windows.Forms.TreeNode($type)
                $tn1 = New-Object System.Windows.Forms.TreeNode("_open management site")
                $tn1.Tag = $url
                $tn.Nodes.Add($tn1) | Out-Null

                $tn2 = New-Object System.Windows.Forms.TreeNode("_open list")
                $tn2.Tag = $ct.ParentWeb.Site.MakeFullUrl($ct.ParentList.DefaultViewUrl)
                $tn.Nodes.Add($tn2) | Out-Null
            }else {
                $type="(Web) $($ct.Name) / Id: $($ct.Id.ToString())"
                $url = $ct.parentweb.url + "/_layouts/ManageContentType.aspx?ctype=" + $ct.Id.ToString()

                #http://<domain>/sites/<web>/_layouts/ManageContentType.aspx?ctype=0x0100CF8FCF53E9FA451CB145093F830B1762
                $tn = New-Object System.Windows.Forms.TreeNode($type)
                $tn1 = New-Object System.Windows.Forms.TreeNode("_open management site")
                $tn1.Tag = $url

                $tn.Nodes.Add($tn1) | Out-Null
                $tn2 = New-Object System.Windows.Forms.TreeNode("_open web")
                $tn2.Tag = $ct.ParentWeb.Url
                $tn.Nodes.Add($tn2) | Out-Null
            }

            $parentNode.Nodes.Add($tn) | Out-Null

            reorder -p $ct -intend ($intend+1) -parentNode $tn
        }
    }
}

if($fileName -ne $null ) {
    Remove-Item -Path $fileName -Confirm:$false -ErrorAction SilentlyContinue
}

#you can filter the processed site collections in the following line
Get-SPSite -Limit all <#| select -first 1 -Skip 10#> | % {
    $site = $_
    $tn = New-Object System.Windows.Forms.TreeNode("Site: $($site.Url)")
    $treeview.Nodes.Add($tn)

    $rootWeb = $site.RootWeb

    analyseWeb -web $rootWeb

    reorder -parentNode $tn

    $rootWeb.Dispose()
    $site.Dispose()
}

$form.ShowDialog() | out-null


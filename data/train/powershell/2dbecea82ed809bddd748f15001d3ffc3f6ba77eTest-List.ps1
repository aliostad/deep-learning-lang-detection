import-module .\WordRef.psm1

# StopWordProcess
# $docFullPath = (dir "WordRef-AbsoluteRefMultiItems.docx").FullName
# $wordApp = SetupWordApp
# $doc = DocOpen $wordApp $docFullPath
# $doc.Fields | foreach {

# 	if($_.Type -eq 68){
# 		# $_.LinkFormat.SourceName
# 		$_.LinkFormat | gm
# 	}
# }

# $fieldList = ($doc.Shapes | where {$_.TextFrame.HasText} |
# 	foreach {$_.TextFrame.TextRange.Fields} ) 
# # $fieldList 

# $fieldList | foreach {

# 		$_.LinkFormat.SourceName
# 	}


# $docMultiRefName = "WordRef-AbsoluteRefMultiItems.docx"
# $docMultiRefPath = (Resolve-Path (".\$docMultiRefName")).Path
# # $refList = (dir ($docMultiRefName) | foreach {$_.FullName} | WordRef-List -inShapes)
# #     $refList.Length | Should be 4


# $refList = (dir ($docMultiRefName) | foreach {$_.FullName} | WordRef-List -inShapes -showFullAsPath)
#     # $refList.Length | Should be 4
# $refList

 (dir *.docx | foreach {$_.FullName} | 
    WordRef-List -inShapes -showAsFullPath -debug)



remove-module wordref
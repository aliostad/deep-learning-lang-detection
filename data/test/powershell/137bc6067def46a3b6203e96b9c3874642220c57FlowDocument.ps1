New-FlowDocumentReader -IsFindEnabled:$false -Document {
    New-FlowDocument {
        New-Paragraph -TextAlignment Right {
            New-Button -FontSize 20 "Add _Paragraph" -On_Click {
                $this.Parent.Parent.Parent.Blocks.Add(
                    (New-Paragraph { "Hello World" })
                )
                $this.Parent.Parent.Parent.Blocks.Add(
                    (New-Paragraph -BreakPageBefore -FontStyle Italic { "Hello World" })
                )
            }
        }
    }
} -show
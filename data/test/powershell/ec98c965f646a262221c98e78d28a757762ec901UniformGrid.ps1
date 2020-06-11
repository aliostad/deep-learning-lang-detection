Show-UI {
    UniformGrid  -Margin 5 -Background lightblue {
        Button -Margin 2 "A bed of clams" -FontFamily Consolas -FontSize 24 -FontWeight Bold
        Button -Margin 2 "A coalition of cheetas" -FontFamily Arial -FontSize 20 -FontStyle Italic
        Button -Margin 2 "A gulp of swallows" -FontFamily 'Segoe UI' -FontSize 18 -Foreground Crimson
    }
}

Show-UI {
   StackPanel -Margin 10 -Children {
      TextBlock "A Question" -FontSize 42 -FontWeight Bold -Foreground "#FF0088" 
      TextBlock -FontSize 24 -Inlines {
         Bold "Q. "
         "Are you starting to dig "
         Hyperlink "ShowUI?" -NavigateUri http://google.be/ `
                                 -On_RequestNavigate { [Diagnostics.Process]::Start( $this.NavigateUri.ToString() ) }
      }
      TextBlock -FontSize 16 -Inlines {
         Span -FontSize 24 -FontWeight Bold -Inlines "A. "
         "Leave me alone, I'm hacking here!"
      }
}
}
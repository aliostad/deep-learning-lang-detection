Package.describe({
  summary: "CodeMirror Markdown with own plugins"
});

Package.on_use(function (api) {
  
  api.use('templating', 'client');
  api.use('ui', 'client');
  api.use('deps', 'client');
  
  api.add_files("lib/codemirror.js", "client");
  api.add_files("lib/codemirror.css", "client");
  
  api.add_files("themes/monokai.css", "client");
  
  api.add_files("modes/markdown.js", "client");
  api.add_files("modes/javascript.js", "client");
  api.add_files("editorView.html", "client");
  api.add_files("editorView.js", "client");
  

  if (api.export) 
    api.export('CodeMirror');
});

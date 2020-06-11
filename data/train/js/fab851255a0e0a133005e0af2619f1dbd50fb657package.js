Package.describe({
    summary: "Elm is a functional language that compiles to HTML, CSS, and JavaScript. Designed for functional reactive programming, Elm makes it easy to create highly interactive applications."
});

Package.on_use(function (api, where) {
    api.export("Elm");
    api.export("F2");
    api.export("F3");
    api.export("F4");
    api.export("F5");
    api.export("F6");
    api.export("F7");
    api.export("F8");
    api.export("F9");
    api.export("A2");
    api.export("A3");
    api.export("A4");
    api.export("A5");
    api.export("A6");
    api.export("A7");
    api.export("A8");
    api.export("A9");
    api.add_files("lib/elm-runtime.js", "client");
});

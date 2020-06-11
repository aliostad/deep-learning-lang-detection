package workflow

var condCopyEqualsJson = `
{
    "processes": {
        "Equals": { "component": "Equals" },
        "Cond": { "component": "Cond" },
        "Copy": { "component": "Copy" }
    },
    "connections": [
        {
            "source": {
                "process": "Equals",
                "port": "Out"
            },
            "target": {
                "process": "Cond",
                "port": "Cond"
            }
        },
        {
            "source": {
                "process": "Cond",
                "port": "Out"
            },
            "target": {
                "process": "Copy",
                "port": "In"
            }
        }
    ]
}
`

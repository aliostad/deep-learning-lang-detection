using System;
using System.Collections.Generic;
using System.Text;

namespace CPCPacker
{
    static class Plugin
    {
        static private CPCPacker.Controller.Compiler controllerCompiler;
        static public CPCPacker.Controller.Compiler ControllerCompiler
        {
            get { return controllerCompiler; }
            set { controllerCompiler = value; }
        }
        
        static private CPCPacker.Controller.Editor controllerEditor;
        static public CPCPacker.Controller.Editor ControllerEditor
        {
            get { return controllerEditor; }
            set { controllerEditor = value; }
        }
    }
}

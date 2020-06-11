app.controller("DiagramCtrl",['$scope','DiagramService','RuntimeService',function ($scope,DiagramService,RuntimeService){

    DiagramService.Init();
    myDiagram = DiagramService.getDiagram();
    $$ = DiagramService.getGoMake();
    Init();

    function Init()
    {
        DiagramService.DefineUndoDiagram($$)
        DiagramService.LoadNodeTemplate($$)
        DiagramService.LoadLinkTemplate()
        DiagramService.LoadGroupTemlate()
        DiagramService.ContextMenu()
        DiagramService.LoadPalette()
        DiagramService.LoadSettings()
        undoDisplay = DiagramService.getUndoDisplay();
        DiagramService.ExternalObjectsDroppedListener(RuntimeService, myDiagram)
        DiagramService.addChangedListener(myDiagram,undoDisplay)
        DiagramService.mouseDrop(RuntimeService,myDiagram)
        DiagramService.mouseDragOver(RuntimeService,myDiagram)
        DiagramService.SetCustomLinkingTool()
        DiagramService.SetCustomPanningTool()

    }

    $scope.list = DiagramService.getNodeArray();

}])


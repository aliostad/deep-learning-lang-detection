namespace GoogleAppsScript
open System
open System.Text.RegularExpressions
open Fable.Core
open Fable.Import.JS

[<AutoOpen>]
    module UI =
        type [<AllowNullLiteral>] AbsolutePanel =
            abstract add: widget: Widget -> AbsolutePanel
            abstract add: widget: Widget * left: Integer * top: Integer -> AbsolutePanel
            abstract addStyleDependentName: styleName: string -> AbsolutePanel
            abstract addStyleName: styleName: string -> AbsolutePanel
            abstract clear: unit -> AbsolutePanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract remove: index: Integer -> AbsolutePanel
            abstract remove: widget: Widget -> AbsolutePanel
            abstract setHeight: height: string -> AbsolutePanel
            abstract setId: id: string -> AbsolutePanel
            abstract setLayoutData: layout: obj -> AbsolutePanel
            abstract setPixelSize: width: Integer * height: Integer -> AbsolutePanel
            abstract setSize: width: string * height: string -> AbsolutePanel
            abstract setStyleAttribute: attribute: string * value: string -> AbsolutePanel
            abstract setStyleAttributes: attributes: obj -> AbsolutePanel
            abstract setStyleName: styleName: string -> AbsolutePanel
            abstract setStylePrimaryName: styleName: string -> AbsolutePanel
            abstract setTag: tag: string -> AbsolutePanel
            abstract setTitle: title: string -> AbsolutePanel
            abstract setVisible: visible: bool -> AbsolutePanel
            abstract setWidgetPosition: widget: Widget * left: Integer * top: Integer -> AbsolutePanel
            abstract setWidth: width: string -> AbsolutePanel

        and [<AllowNullLiteral>] Anchor =
            abstract addBlurHandler: handler: Handler -> Anchor
            abstract addClickHandler: handler: Handler -> Anchor
            abstract addFocusHandler: handler: Handler -> Anchor
            abstract addKeyDownHandler: handler: Handler -> Anchor
            abstract addKeyPressHandler: handler: Handler -> Anchor
            abstract addKeyUpHandler: handler: Handler -> Anchor
            abstract addMouseDownHandler: handler: Handler -> Anchor
            abstract addMouseMoveHandler: handler: Handler -> Anchor
            abstract addMouseOutHandler: handler: Handler -> Anchor
            abstract addMouseOverHandler: handler: Handler -> Anchor
            abstract addMouseUpHandler: handler: Handler -> Anchor
            abstract addMouseWheelHandler: handler: Handler -> Anchor
            abstract addStyleDependentName: styleName: string -> Anchor
            abstract addStyleName: styleName: string -> Anchor
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> Anchor
            abstract setDirection: direction: Component -> Anchor
            abstract setEnabled: enabled: bool -> Anchor
            abstract setFocus: focus: bool -> Anchor
            abstract setHTML: html: string -> Anchor
            abstract setHeight: height: string -> Anchor
            abstract setHorizontalAlignment: horizontalAlignment: HorizontalAlignment -> Anchor
            abstract setHref: href: string -> Anchor
            abstract setId: id: string -> Anchor
            abstract setLayoutData: layout: obj -> Anchor
            abstract setName: name: string -> Anchor
            abstract setPixelSize: width: Integer * height: Integer -> Anchor
            abstract setSize: width: string * height: string -> Anchor
            abstract setStyleAttribute: attribute: string * value: string -> Anchor
            abstract setStyleAttributes: attributes: obj -> Anchor
            abstract setStyleName: styleName: string -> Anchor
            abstract setStylePrimaryName: styleName: string -> Anchor
            abstract setTabIndex: index: Integer -> Anchor
            abstract setTag: tag: string -> Anchor
            abstract setTarget: target: string -> Anchor
            abstract setText: text: string -> Anchor
            abstract setTitle: title: string -> Anchor
            abstract setVisible: visible: bool -> Anchor
            abstract setWidth: width: string -> Anchor
            abstract setWordWrap: wordWrap: bool -> Anchor

        and [<AllowNullLiteral>] Button =
            abstract addBlurHandler: handler: Handler -> Button
            abstract addClickHandler: handler: Handler -> Button
            abstract addFocusHandler: handler: Handler -> Button
            abstract addKeyDownHandler: handler: Handler -> Button
            abstract addKeyPressHandler: handler: Handler -> Button
            abstract addKeyUpHandler: handler: Handler -> Button
            abstract addMouseDownHandler: handler: Handler -> Button
            abstract addMouseMoveHandler: handler: Handler -> Button
            abstract addMouseOutHandler: handler: Handler -> Button
            abstract addMouseOverHandler: handler: Handler -> Button
            abstract addMouseUpHandler: handler: Handler -> Button
            abstract addMouseWheelHandler: handler: Handler -> Button
            abstract addStyleDependentName: styleName: string -> Button
            abstract addStyleName: styleName: string -> Button
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> Button
            abstract setEnabled: enabled: bool -> Button
            abstract setFocus: focus: bool -> Button
            abstract setHTML: html: string -> Button
            abstract setHeight: height: string -> Button
            abstract setId: id: string -> Button
            abstract setLayoutData: layout: obj -> Button
            abstract setPixelSize: width: Integer * height: Integer -> Button
            abstract setSize: width: string * height: string -> Button
            abstract setStyleAttribute: attribute: string * value: string -> Button
            abstract setStyleAttributes: attributes: obj -> Button
            abstract setStyleName: styleName: string -> Button
            abstract setStylePrimaryName: styleName: string -> Button
            abstract setTabIndex: index: Integer -> Button
            abstract setTag: tag: string -> Button
            abstract setText: text: string -> Button
            abstract setTitle: title: string -> Button
            abstract setVisible: visible: bool -> Button
            abstract setWidth: width: string -> Button

        and [<AllowNullLiteral>] CaptionPanel =
            abstract add: widget: Widget -> CaptionPanel
            abstract addStyleDependentName: styleName: string -> CaptionPanel
            abstract addStyleName: styleName: string -> CaptionPanel
            abstract clear: unit -> CaptionPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setCaptionText: text: string -> CaptionPanel
            abstract setContentWidget: widget: Widget -> CaptionPanel
            abstract setHeight: height: string -> CaptionPanel
            abstract setId: id: string -> CaptionPanel
            abstract setLayoutData: layout: obj -> CaptionPanel
            abstract setPixelSize: width: Integer * height: Integer -> CaptionPanel
            abstract setSize: width: string * height: string -> CaptionPanel
            abstract setStyleAttribute: attribute: string * value: string -> CaptionPanel
            abstract setStyleAttributes: attributes: obj -> CaptionPanel
            abstract setStyleName: styleName: string -> CaptionPanel
            abstract setStylePrimaryName: styleName: string -> CaptionPanel
            abstract setTag: tag: string -> CaptionPanel
            abstract setText: text: string -> CaptionPanel
            abstract setTitle: title: string -> CaptionPanel
            abstract setVisible: visible: bool -> CaptionPanel
            abstract setWidget: widget: Widget -> CaptionPanel
            abstract setWidth: width: string -> CaptionPanel

        and [<AllowNullLiteral>] CheckBox =
            abstract addBlurHandler: handler: Handler -> CheckBox
            abstract addClickHandler: handler: Handler -> CheckBox
            abstract addFocusHandler: handler: Handler -> CheckBox
            abstract addKeyDownHandler: handler: Handler -> CheckBox
            abstract addKeyPressHandler: handler: Handler -> CheckBox
            abstract addKeyUpHandler: handler: Handler -> CheckBox
            abstract addMouseDownHandler: handler: Handler -> CheckBox
            abstract addMouseMoveHandler: handler: Handler -> CheckBox
            abstract addMouseOutHandler: handler: Handler -> CheckBox
            abstract addMouseOverHandler: handler: Handler -> CheckBox
            abstract addMouseUpHandler: handler: Handler -> CheckBox
            abstract addMouseWheelHandler: handler: Handler -> CheckBox
            abstract addStyleDependentName: styleName: string -> CheckBox
            abstract addStyleName: styleName: string -> CheckBox
            abstract addValueChangeHandler: handler: Handler -> CheckBox
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> CheckBox
            abstract setEnabled: enabled: bool -> CheckBox
            abstract setFocus: focus: bool -> CheckBox
            abstract setFormValue: formValue: string -> CheckBox
            abstract setHTML: html: string -> CheckBox
            abstract setHeight: height: string -> CheckBox
            abstract setId: id: string -> CheckBox
            abstract setLayoutData: layout: obj -> CheckBox
            abstract setName: name: string -> CheckBox
            abstract setPixelSize: width: Integer * height: Integer -> CheckBox
            abstract setSize: width: string * height: string -> CheckBox
            abstract setStyleAttribute: attribute: string * value: string -> CheckBox
            abstract setStyleAttributes: attributes: obj -> CheckBox
            abstract setStyleName: styleName: string -> CheckBox
            abstract setStylePrimaryName: styleName: string -> CheckBox
            abstract setTabIndex: index: Integer -> CheckBox
            abstract setTag: tag: string -> CheckBox
            abstract setText: text: string -> CheckBox
            abstract setTitle: title: string -> CheckBox
            abstract setValue: value: bool -> CheckBox
            abstract setValue: value: bool * fireEvents: bool -> CheckBox
            abstract setVisible: visible: bool -> CheckBox
            abstract setWidth: width: string -> CheckBox

        and [<AllowNullLiteral>] ClientHandler =
            abstract forEventSource: unit -> ClientHandler
            abstract forTargets: [<ParamArray>] widgets: obj[] -> ClientHandler
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setEnabled: enabled: bool -> ClientHandler
            abstract setHTML: html: string -> ClientHandler
            abstract setId: id: string -> ClientHandler
            abstract setStyleAttribute: row: Integer * column: Integer * attribute: string * value: string -> ClientHandler
            abstract setStyleAttribute: attribute: string * value: string -> ClientHandler
            abstract setStyleAttributes: row: Integer * column: Integer * attributes: obj -> ClientHandler
            abstract setStyleAttributes: attributes: obj -> ClientHandler
            abstract setTag: tag: string -> ClientHandler
            abstract setText: text: string -> ClientHandler
            abstract setValue: value: bool -> ClientHandler
            abstract setVisible: visible: bool -> ClientHandler
            abstract validateEmail: widget: Widget -> ClientHandler
            abstract validateInteger: widget: Widget -> ClientHandler
            abstract validateLength: widget: Widget * min: Integer * max: Integer -> ClientHandler
            abstract validateMatches: widget: Widget * pattern: string -> ClientHandler
            abstract validateMatches: widget: Widget * pattern: string * flags: string -> ClientHandler
            abstract validateNotEmail: widget: Widget -> ClientHandler
            abstract validateNotInteger: widget: Widget -> ClientHandler
            abstract validateNotLength: widget: Widget * min: Integer * max: Integer -> ClientHandler
            abstract validateNotMatches: widget: Widget * pattern: string -> ClientHandler
            abstract validateNotMatches: widget: Widget * pattern: string * flags: string -> ClientHandler
            abstract validateNotNumber: widget: Widget -> ClientHandler
            abstract validateNotOptions: widget: Widget * options: ResizeArray<string> -> ClientHandler
            abstract validateNotRange: widget: Widget * min: float * max: float -> ClientHandler
            abstract validateNotSum: widgets: ResizeArray<Widget> * sum: Integer -> ClientHandler
            abstract validateNumber: widget: Widget -> ClientHandler
            abstract validateOptions: widget: Widget * options: ResizeArray<string> -> ClientHandler
            abstract validateRange: widget: Widget * min: float * max: float -> ClientHandler
            abstract validateSum: widgets: ResizeArray<Widget> * sum: Integer -> ClientHandler

        and [<AllowNullLiteral>] Component =
            abstract getId: unit -> string
            abstract getType: unit -> string

        and [<AllowNullLiteral>] DateBox =
            abstract addStyleDependentName: styleName: string -> DateBox
            abstract addStyleName: styleName: string -> DateBox
            abstract addValueChangeHandler: handler: Handler -> DateBox
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract hideDatePicker: unit -> DateBox
            abstract setAccessKey: accessKey: Char -> DateBox
            abstract setEnabled: enabled: bool -> DateBox
            abstract setFireEventsForInvalid: fireEvents: bool -> DateBox
            abstract setFocus: focus: bool -> DateBox
            abstract setFormat: dateTimeFormat: DateTimeFormat -> DateBox
            abstract setHeight: height: string -> DateBox
            abstract setId: id: string -> DateBox
            abstract setLayoutData: layout: obj -> DateBox
            abstract setName: name: string -> DateBox
            abstract setPixelSize: width: Integer * height: Integer -> DateBox
            abstract setSize: width: string * height: string -> DateBox
            abstract setStyleAttribute: attribute: string * value: string -> DateBox
            abstract setStyleAttributes: attributes: obj -> DateBox
            abstract setStyleName: styleName: string -> DateBox
            abstract setStylePrimaryName: styleName: string -> DateBox
            abstract setTabIndex: index: Integer -> DateBox
            abstract setTag: tag: string -> DateBox
            abstract setTitle: title: string -> DateBox
            abstract setValue: date: DateTime -> DateBox
            abstract setVisible: visible: bool -> DateBox
            abstract setWidth: width: string -> DateBox
            abstract showDatePicker: unit -> DateBox

        and [<AllowNullLiteral>] DatePicker =
            abstract addStyleDependentName: styleName: string -> DatePicker
            abstract addStyleName: styleName: string -> DatePicker
            abstract addValueChangeHandler: handler: Handler -> DatePicker
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setCurrentMonth: date: DateTime -> DatePicker
            abstract setHeight: height: string -> DatePicker
            abstract setId: id: string -> DatePicker
            abstract setLayoutData: layout: obj -> DatePicker
            abstract setName: name: string -> DatePicker
            abstract setPixelSize: width: Integer * height: Integer -> DatePicker
            abstract setSize: width: string * height: string -> DatePicker
            abstract setStyleAttribute: attribute: string * value: string -> DatePicker
            abstract setStyleAttributes: attributes: obj -> DatePicker
            abstract setStyleName: styleName: string -> DatePicker
            abstract setStylePrimaryName: styleName: string -> DatePicker
            abstract setTag: tag: string -> DatePicker
            abstract setTitle: title: string -> DatePicker
            abstract setValue: date: DateTime -> DatePicker
            abstract setVisible: visible: bool -> DatePicker
            abstract setWidth: width: string -> DatePicker

        and DateTimeFormat =
            | ISO_8601 = 0
            | RFC_2822 = 1
            | DATE_FULL = 2
            | DATE_LONG = 3
            | DATE_MEDIUM = 4
            | DATE_SHORT = 5
            | TIME_FULL = 6
            | TIME_LONG = 7
            | TIME_MEDIUM = 8
            | TIME_SHORT = 9
            | DATE_TIME_FULL = 10
            | DATE_TIME_LONG = 11
            | DATE_TIME_MEDIUM = 12
            | DATE_TIME_SHORT = 13
            | DAY = 14
            | HOUR_MINUTE = 15
            | HOUR_MINUTE_SECOND = 16
            | HOUR24_MINUTE = 17
            | HOUR24_MINUTE_SECOND = 18
            | MINUTE_SECOND = 19
            | MONTH = 20
            | MONTH_ABBR = 21
            | MONTH_ABBR_DAY = 22
            | MONTH_DAY = 23
            | MONTH_NUM_DAY = 24
            | MONTH_WEEKDAY_DAY = 25
            | YEAR = 26
            | YEAR_MONTH = 27
            | YEAR_MONTH_ABBR = 28
            | YEAR_MONTH_ABBR_DAY = 29
            | YEAR_MONTH_DAY = 30
            | YEAR_MONTH_NUM = 31
            | YEAR_MONTH_NUM_DAY = 32
            | YEAR_MONTH_WEEKDAY_DAY = 33
            | YEAR_QUARTER = 34
            | YEAR_QUARTER_ABBR = 35

        and [<AllowNullLiteral>] DecoratedStackPanel =
            abstract add: widget: Widget -> DecoratedStackPanel
            abstract add: widget: Widget * text: string -> DecoratedStackPanel
            abstract add: widget: Widget * text: string * asHtml: bool -> DecoratedStackPanel
            abstract addStyleDependentName: styleName: string -> DecoratedStackPanel
            abstract addStyleName: styleName: string -> DecoratedStackPanel
            abstract clear: unit -> DecoratedStackPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract remove: index: Integer -> DecoratedStackPanel
            abstract remove: widget: Widget -> DecoratedStackPanel
            abstract setHeight: height: string -> DecoratedStackPanel
            abstract setId: id: string -> DecoratedStackPanel
            abstract setLayoutData: layout: obj -> DecoratedStackPanel
            abstract setPixelSize: width: Integer * height: Integer -> DecoratedStackPanel
            abstract setSize: width: string * height: string -> DecoratedStackPanel
            abstract setStackText: index: Integer * text: string -> DecoratedStackPanel
            abstract setStackText: index: Integer * text: string * asHtml: bool -> DecoratedStackPanel
            abstract setStyleAttribute: attribute: string * value: string -> DecoratedStackPanel
            abstract setStyleAttributes: attributes: obj -> DecoratedStackPanel
            abstract setStyleName: styleName: string -> DecoratedStackPanel
            abstract setStylePrimaryName: styleName: string -> DecoratedStackPanel
            abstract setTag: tag: string -> DecoratedStackPanel
            abstract setTitle: title: string -> DecoratedStackPanel
            abstract setVisible: visible: bool -> DecoratedStackPanel
            abstract setWidth: width: string -> DecoratedStackPanel

        and [<AllowNullLiteral>] DecoratedTabBar =
            abstract addBeforeSelectionHandler: handler: Handler -> DecoratedTabBar
            abstract addSelectionHandler: handler: Handler -> DecoratedTabBar
            abstract addStyleDependentName: styleName: string -> DecoratedTabBar
            abstract addStyleName: styleName: string -> DecoratedTabBar
            abstract addTab: title: string -> DecoratedTabBar
            abstract addTab: title: string * asHtml: bool -> DecoratedTabBar
            abstract addTab: widget: Widget -> DecoratedTabBar
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract selectTab: index: Integer -> DecoratedTabBar
            abstract setHeight: height: string -> DecoratedTabBar
            abstract setId: id: string -> DecoratedTabBar
            abstract setLayoutData: layout: obj -> DecoratedTabBar
            abstract setPixelSize: width: Integer * height: Integer -> DecoratedTabBar
            abstract setSize: width: string * height: string -> DecoratedTabBar
            abstract setStyleAttribute: attribute: string * value: string -> DecoratedTabBar
            abstract setStyleAttributes: attributes: obj -> DecoratedTabBar
            abstract setStyleName: styleName: string -> DecoratedTabBar
            abstract setStylePrimaryName: styleName: string -> DecoratedTabBar
            abstract setTabEnabled: index: Integer * enabled: bool -> DecoratedTabBar
            abstract setTabText: index: Integer * text: string -> DecoratedTabBar
            abstract setTag: tag: string -> DecoratedTabBar
            abstract setTitle: title: string -> DecoratedTabBar
            abstract setVisible: visible: bool -> DecoratedTabBar
            abstract setWidth: width: string -> DecoratedTabBar

        and [<AllowNullLiteral>] DecoratedTabPanel =
            abstract add: widget: Widget -> DecoratedTabPanel
            abstract add: widget: Widget * text: string -> DecoratedTabPanel
            abstract add: widget: Widget * text: string * asHtml: bool -> DecoratedTabPanel
            abstract add: widget: Widget * tabWidget: Widget -> DecoratedTabPanel
            abstract addBeforeSelectionHandler: handler: Handler -> DecoratedTabPanel
            abstract addSelectionHandler: handler: Handler -> DecoratedTabPanel
            abstract addStyleDependentName: styleName: string -> DecoratedTabPanel
            abstract addStyleName: styleName: string -> DecoratedTabPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract selectTab: index: Integer -> DecoratedTabPanel
            abstract setAnimationEnabled: animationEnabled: bool -> DecoratedTabPanel
            abstract setHeight: height: string -> DecoratedTabPanel
            abstract setId: id: string -> DecoratedTabPanel
            abstract setLayoutData: layout: obj -> DecoratedTabPanel
            abstract setPixelSize: width: Integer * height: Integer -> DecoratedTabPanel
            abstract setSize: width: string * height: string -> DecoratedTabPanel
            abstract setStyleAttribute: attribute: string * value: string -> DecoratedTabPanel
            abstract setStyleAttributes: attributes: obj -> DecoratedTabPanel
            abstract setStyleName: styleName: string -> DecoratedTabPanel
            abstract setStylePrimaryName: styleName: string -> DecoratedTabPanel
            abstract setTag: tag: string -> DecoratedTabPanel
            abstract setTitle: title: string -> DecoratedTabPanel
            abstract setVisible: visible: bool -> DecoratedTabPanel
            abstract setWidth: width: string -> DecoratedTabPanel

        and [<AllowNullLiteral>] DecoratorPanel =
            abstract add: widget: Widget -> DecoratorPanel
            abstract addStyleDependentName: styleName: string -> DecoratorPanel
            abstract addStyleName: styleName: string -> DecoratorPanel
            abstract clear: unit -> DecoratorPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setHeight: height: string -> DecoratorPanel
            abstract setId: id: string -> DecoratorPanel
            abstract setLayoutData: layout: obj -> DecoratorPanel
            abstract setPixelSize: width: Integer * height: Integer -> DecoratorPanel
            abstract setSize: width: string * height: string -> DecoratorPanel
            abstract setStyleAttribute: attribute: string * value: string -> DecoratorPanel
            abstract setStyleAttributes: attributes: obj -> DecoratorPanel
            abstract setStyleName: styleName: string -> DecoratorPanel
            abstract setStylePrimaryName: styleName: string -> DecoratorPanel
            abstract setTag: tag: string -> DecoratorPanel
            abstract setTitle: title: string -> DecoratorPanel
            abstract setVisible: visible: bool -> DecoratorPanel
            abstract setWidget: widget: Widget -> DecoratorPanel
            abstract setWidth: width: string -> DecoratorPanel

        and [<AllowNullLiteral>] DialogBox =
            abstract add: widget: Widget -> DialogBox
            abstract addAutoHidePartner: partner: Component -> DialogBox
            abstract addCloseHandler: handler: Handler -> DialogBox
            abstract addStyleDependentName: styleName: string -> DialogBox
            abstract addStyleName: styleName: string -> DialogBox
            abstract clear: unit -> DialogBox
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract hide: unit -> DialogBox
            abstract setAnimationEnabled: animationEnabled: bool -> DialogBox
            abstract setAutoHideEnabled: enabled: bool -> DialogBox
            abstract setGlassEnabled: enabled: bool -> DialogBox
            abstract setGlassStyleName: styleName: string -> DialogBox
            abstract setHTML: html: string -> DialogBox
            abstract setHeight: height: string -> DialogBox
            abstract setId: id: string -> DialogBox
            abstract setLayoutData: layout: obj -> DialogBox
            abstract setModal: modal: bool -> DialogBox
            abstract setPixelSize: width: Integer * height: Integer -> DialogBox
            abstract setPopupPosition: left: Integer * top: Integer -> DialogBox
            abstract setPopupPositionAndShow: a: Component -> DialogBox
            abstract setPreviewingAllNativeEvents: previewing: bool -> DialogBox
            abstract setSize: width: string * height: string -> DialogBox
            abstract setStyleAttribute: attribute: string * value: string -> DialogBox
            abstract setStyleAttributes: attributes: obj -> DialogBox
            abstract setStyleName: styleName: string -> DialogBox
            abstract setStylePrimaryName: styleName: string -> DialogBox
            abstract setTag: tag: string -> DialogBox
            abstract setText: text: string -> DialogBox
            abstract setTitle: title: string -> DialogBox
            abstract setVisible: visible: bool -> DialogBox
            abstract setWidget: widget: Widget -> DialogBox
            abstract setWidth: width: string -> DialogBox
            abstract show: unit -> DialogBox

        and [<AllowNullLiteral>] DocsListDialog =
            abstract addCloseHandler: handler: Handler -> DocsListDialog
            abstract addSelectionHandler: handler: Handler -> DocsListDialog
            abstract addView: fileType: FileType -> DocsListDialog
            abstract getId: unit -> string
            abstract getType: unit -> string
            abstract setDialogTitle: title: string -> DocsListDialog
            abstract setHeight: height: Integer -> DocsListDialog
            abstract setInitialView: fileType: FileType -> DocsListDialog
            abstract setMultiSelectEnabled: multiSelectEnabled: bool -> DocsListDialog
            abstract setOAuthToken: oAuthToken: string -> DocsListDialog
            abstract setWidth: width: Integer -> DocsListDialog
            abstract showDocsPicker: unit -> DocsListDialog

        and FileType =
            | ALL = 0
            | ALL_DOCS = 1
            | DRAWINGS = 2
            | DOCUMENTS = 3
            | SPREADSHEETS = 4
            | FOLDERS = 5
            | RECENTLY_PICKED = 6
            | PRESENTATIONS = 7
            | FORMS = 8
            | PHOTOS = 9
            | PHOTO_ALBUMS = 10
            | PDFS = 11

        and [<AllowNullLiteral>] FileUpload =
            abstract addChangeHandler: handler: Handler -> FileUpload
            abstract addStyleDependentName: styleName: string -> FileUpload
            abstract addStyleName: styleName: string -> FileUpload
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setEnabled: enabled: bool -> FileUpload
            abstract setHeight: height: string -> FileUpload
            abstract setId: id: string -> FileUpload
            abstract setLayoutData: layout: obj -> FileUpload
            abstract setName: name: string -> FileUpload
            abstract setPixelSize: width: Integer * height: Integer -> FileUpload
            abstract setSize: width: string * height: string -> FileUpload
            abstract setStyleAttribute: attribute: string * value: string -> FileUpload
            abstract setStyleAttributes: attributes: obj -> FileUpload
            abstract setStyleName: styleName: string -> FileUpload
            abstract setStylePrimaryName: styleName: string -> FileUpload
            abstract setTag: tag: string -> FileUpload
            abstract setTitle: title: string -> FileUpload
            abstract setVisible: visible: bool -> FileUpload
            abstract setWidth: width: string -> FileUpload

        and [<AllowNullLiteral>] FlexTable =
            abstract addCell: row: Integer -> FlexTable
            abstract addClickHandler: handler: Handler -> FlexTable
            abstract addStyleDependentName: styleName: string -> FlexTable
            abstract addStyleName: styleName: string -> FlexTable
            abstract clear: unit -> FlexTable
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract insertCell: beforeRow: Integer * beforeColumn: Integer -> FlexTable
            abstract insertRow: beforeRow: Integer -> FlexTable
            abstract removeCell: row: Integer * column: Integer -> FlexTable
            abstract removeCells: row: Integer * column: Integer * num: Integer -> FlexTable
            abstract removeRow: row: Integer -> FlexTable
            abstract setBorderWidth: width: Integer -> FlexTable
            abstract setCellPadding: padding: Integer -> FlexTable
            abstract setCellSpacing: spacing: Integer -> FlexTable
            abstract setColumnStyleAttribute: column: Integer * attribute: string * value: string -> FlexTable
            abstract setColumnStyleAttributes: column: Integer * attributes: obj -> FlexTable
            abstract setHeight: height: string -> FlexTable
            abstract setId: id: string -> FlexTable
            abstract setLayoutData: layout: obj -> FlexTable
            abstract setPixelSize: width: Integer * height: Integer -> FlexTable
            abstract setRowStyleAttribute: row: Integer * attribute: string * value: string -> FlexTable
            abstract setRowStyleAttributes: row: Integer * attributes: obj -> FlexTable
            abstract setSize: width: string * height: string -> FlexTable
            abstract setStyleAttribute: row: Integer * column: Integer * attribute: string * value: string -> FlexTable
            abstract setStyleAttribute: attribute: string * value: string -> FlexTable
            abstract setStyleAttributes: row: Integer * column: Integer * attributes: obj -> FlexTable
            abstract setStyleAttributes: attributes: obj -> FlexTable
            abstract setStyleName: styleName: string -> FlexTable
            abstract setStylePrimaryName: styleName: string -> FlexTable
            abstract setTag: tag: string -> FlexTable
            abstract setText: row: Integer * column: Integer * text: string -> FlexTable
            abstract setTitle: title: string -> FlexTable
            abstract setVisible: visible: bool -> FlexTable
            abstract setWidget: row: Integer * column: Integer * widget: Widget -> FlexTable
            abstract setWidth: width: string -> FlexTable

        and [<AllowNullLiteral>] FlowPanel =
            abstract add: widget: Widget -> FlowPanel
            abstract addStyleDependentName: styleName: string -> FlowPanel
            abstract addStyleName: styleName: string -> FlowPanel
            abstract clear: unit -> FlowPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract insert: widget: Widget * beforeIndex: Integer -> FlowPanel
            abstract remove: index: Integer -> FlowPanel
            abstract remove: widget: Widget -> FlowPanel
            abstract setHeight: height: string -> FlowPanel
            abstract setId: id: string -> FlowPanel
            abstract setLayoutData: layout: obj -> FlowPanel
            abstract setPixelSize: width: Integer * height: Integer -> FlowPanel
            abstract setSize: width: string * height: string -> FlowPanel
            abstract setStyleAttribute: attribute: string * value: string -> FlowPanel
            abstract setStyleAttributes: attributes: obj -> FlowPanel
            abstract setStyleName: styleName: string -> FlowPanel
            abstract setStylePrimaryName: styleName: string -> FlowPanel
            abstract setTag: tag: string -> FlowPanel
            abstract setTitle: title: string -> FlowPanel
            abstract setVisible: visible: bool -> FlowPanel
            abstract setWidth: width: string -> FlowPanel

        and [<AllowNullLiteral>] FocusPanel =
            abstract add: widget: Widget -> FocusPanel
            abstract addBlurHandler: handler: Handler -> FocusPanel
            abstract addClickHandler: handler: Handler -> FocusPanel
            abstract addFocusHandler: handler: Handler -> FocusPanel
            abstract addKeyDownHandler: handler: Handler -> FocusPanel
            abstract addKeyPressHandler: handler: Handler -> FocusPanel
            abstract addKeyUpHandler: handler: Handler -> FocusPanel
            abstract addMouseDownHandler: handler: Handler -> FocusPanel
            abstract addMouseMoveHandler: handler: Handler -> FocusPanel
            abstract addMouseOutHandler: handler: Handler -> FocusPanel
            abstract addMouseOverHandler: handler: Handler -> FocusPanel
            abstract addMouseUpHandler: handler: Handler -> FocusPanel
            abstract addMouseWheelHandler: handler: Handler -> FocusPanel
            abstract addStyleDependentName: styleName: string -> FocusPanel
            abstract addStyleName: styleName: string -> FocusPanel
            abstract clear: unit -> FocusPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> FocusPanel
            abstract setFocus: focus: bool -> FocusPanel
            abstract setHeight: height: string -> FocusPanel
            abstract setId: id: string -> FocusPanel
            abstract setLayoutData: layout: obj -> FocusPanel
            abstract setPixelSize: width: Integer * height: Integer -> FocusPanel
            abstract setSize: width: string * height: string -> FocusPanel
            abstract setStyleAttribute: attribute: string * value: string -> FocusPanel
            abstract setStyleAttributes: attributes: obj -> FocusPanel
            abstract setStyleName: styleName: string -> FocusPanel
            abstract setStylePrimaryName: styleName: string -> FocusPanel
            abstract setTabIndex: index: Integer -> FocusPanel
            abstract setTag: tag: string -> FocusPanel
            abstract setTitle: title: string -> FocusPanel
            abstract setVisible: visible: bool -> FocusPanel
            abstract setWidget: widget: Widget -> FocusPanel
            abstract setWidth: width: string -> FocusPanel

        and [<AllowNullLiteral>] FormPanel =
            abstract add: widget: Widget -> FormPanel
            abstract addStyleDependentName: styleName: string -> FormPanel
            abstract addStyleName: styleName: string -> FormPanel
            abstract addSubmitCompleteHandler: handler: Handler -> FormPanel
            abstract addSubmitHandler: handler: Handler -> FormPanel
            abstract clear: unit -> FormPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAction: action: string -> FormPanel
            abstract setEncoding: encoding: string -> FormPanel
            abstract setHeight: height: string -> FormPanel
            abstract setId: id: string -> FormPanel
            abstract setLayoutData: layout: obj -> FormPanel
            abstract setMethod: ``method``: string -> FormPanel
            abstract setPixelSize: width: Integer * height: Integer -> FormPanel
            abstract setSize: width: string * height: string -> FormPanel
            abstract setStyleAttribute: attribute: string * value: string -> FormPanel
            abstract setStyleAttributes: attributes: obj -> FormPanel
            abstract setStyleName: styleName: string -> FormPanel
            abstract setStylePrimaryName: styleName: string -> FormPanel
            abstract setTag: tag: string -> FormPanel
            abstract setTitle: title: string -> FormPanel
            abstract setVisible: visible: bool -> FormPanel
            abstract setWidget: widget: Widget -> FormPanel
            abstract setWidth: width: string -> FormPanel

        and [<AllowNullLiteral>] Grid =
            abstract addClickHandler: handler: Handler -> Grid
            abstract addStyleDependentName: styleName: string -> Grid
            abstract addStyleName: styleName: string -> Grid
            abstract clear: unit -> Grid
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract resize: rows: Integer * columns: Integer -> Grid
            abstract setBorderWidth: width: Integer -> Grid
            abstract setCellPadding: padding: Integer -> Grid
            abstract setCellSpacing: spacing: Integer -> Grid
            abstract setColumnStyleAttribute: column: Integer * attribute: string * value: string -> Grid
            abstract setColumnStyleAttributes: column: Integer * attributes: obj -> Grid
            abstract setHeight: height: string -> Grid
            abstract setId: id: string -> Grid
            abstract setLayoutData: layout: obj -> Grid
            abstract setPixelSize: width: Integer * height: Integer -> Grid
            abstract setRowStyleAttribute: row: Integer * attribute: string * value: string -> Grid
            abstract setRowStyleAttributes: row: Integer * attributes: obj -> Grid
            abstract setSize: width: string * height: string -> Grid
            abstract setStyleAttribute: row: Integer * column: Integer * attribute: string * value: string -> Grid
            abstract setStyleAttribute: attribute: string * value: string -> Grid
            abstract setStyleAttributes: row: Integer * column: Integer * attributes: obj -> Grid
            abstract setStyleAttributes: attributes: obj -> Grid
            abstract setStyleName: styleName: string -> Grid
            abstract setStylePrimaryName: styleName: string -> Grid
            abstract setTag: tag: string -> Grid
            abstract setText: row: Integer * column: Integer * text: string -> Grid
            abstract setTitle: title: string -> Grid
            abstract setVisible: visible: bool -> Grid
            abstract setWidget: row: Integer * column: Integer * widget: Widget -> Grid
            abstract setWidth: width: string -> Grid

        and [<AllowNullLiteral>] HTML =
            abstract addClickHandler: handler: Handler -> HTML
            abstract addMouseDownHandler: handler: Handler -> HTML
            abstract addMouseMoveHandler: handler: Handler -> HTML
            abstract addMouseOutHandler: handler: Handler -> HTML
            abstract addMouseOverHandler: handler: Handler -> HTML
            abstract addMouseUpHandler: handler: Handler -> HTML
            abstract addMouseWheelHandler: handler: Handler -> HTML
            abstract addStyleDependentName: styleName: string -> HTML
            abstract addStyleName: styleName: string -> HTML
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setDirection: direction: Component -> HTML
            abstract setHTML: html: string -> HTML
            abstract setHeight: height: string -> HTML
            abstract setHorizontalAlignment: horizontalAlignment: HorizontalAlignment -> HTML
            abstract setId: id: string -> HTML
            abstract setLayoutData: layout: obj -> HTML
            abstract setPixelSize: width: Integer * height: Integer -> HTML
            abstract setSize: width: string * height: string -> HTML
            abstract setStyleAttribute: attribute: string * value: string -> HTML
            abstract setStyleAttributes: attributes: obj -> HTML
            abstract setStyleName: styleName: string -> HTML
            abstract setStylePrimaryName: styleName: string -> HTML
            abstract setTag: tag: string -> HTML
            abstract setText: text: string -> HTML
            abstract setTitle: title: string -> HTML
            abstract setVisible: visible: bool -> HTML
            abstract setWidth: width: string -> HTML
            abstract setWordWrap: wordWrap: bool -> HTML

        and [<AllowNullLiteral>] Handler =
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setId: id: string -> Handler
            abstract setTag: tag: string -> Handler
            abstract validateEmail: widget: Widget -> Handler
            abstract validateInteger: widget: Widget -> Handler
            abstract validateLength: widget: Widget * min: Integer * max: Integer -> Handler
            abstract validateMatches: widget: Widget * pattern: string -> Handler
            abstract validateMatches: widget: Widget * pattern: string * flags: string -> Handler
            abstract validateNotEmail: widget: Widget -> Handler
            abstract validateNotInteger: widget: Widget -> Handler
            abstract validateNotLength: widget: Widget * min: Integer * max: Integer -> Handler
            abstract validateNotMatches: widget: Widget * pattern: string -> Handler
            abstract validateNotMatches: widget: Widget * pattern: string * flags: string -> Handler
            abstract validateNotNumber: widget: Widget -> Handler
            abstract validateNotOptions: widget: Widget * options: ResizeArray<string> -> Handler
            abstract validateNotRange: widget: Widget * min: float * max: float -> Handler
            abstract validateNotSum: widgets: ResizeArray<Widget> * sum: Integer -> Handler
            abstract validateNumber: widget: Widget -> Handler
            abstract validateOptions: widget: Widget * options: ResizeArray<string> -> Handler
            abstract validateRange: widget: Widget * min: float * max: float -> Handler
            abstract validateSum: widgets: ResizeArray<Widget> * sum: Integer -> Handler

        and [<AllowNullLiteral>] Hidden =
            abstract addStyleDependentName: styleName: string -> Hidden
            abstract addStyleName: styleName: string -> Hidden
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setDefaultValue: value: string -> Hidden
            abstract setHeight: height: string -> Hidden
            abstract setID: id: string -> Hidden
            abstract setId: id: string -> Hidden
            abstract setLayoutData: layout: obj -> Hidden
            abstract setName: name: string -> Hidden
            abstract setPixelSize: width: Integer * height: Integer -> Hidden
            abstract setSize: width: string * height: string -> Hidden
            abstract setStyleAttribute: attribute: string * value: string -> Hidden
            abstract setStyleAttributes: attributes: obj -> Hidden
            abstract setStyleName: styleName: string -> Hidden
            abstract setStylePrimaryName: styleName: string -> Hidden
            abstract setTag: tag: string -> Hidden
            abstract setTitle: title: string -> Hidden
            abstract setValue: value: string -> Hidden
            abstract setVisible: visible: bool -> Hidden
            abstract setWidth: width: string -> Hidden

        and HorizontalAlignment =
            | LEFT = 0
            | RIGHT = 1
            | CENTER = 2
            | DEFAULT = 3
            | JUSTIFY = 4
            | LOCALE_START = 5
            | LOCALE_END = 6

        and [<AllowNullLiteral>] HorizontalPanel =
            abstract add: widget: Widget -> HorizontalPanel
            abstract addStyleDependentName: styleName: string -> HorizontalPanel
            abstract addStyleName: styleName: string -> HorizontalPanel
            abstract clear: unit -> HorizontalPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract remove: index: Integer -> HorizontalPanel
            abstract remove: widget: Widget -> HorizontalPanel
            abstract setBorderWidth: width: Integer -> HorizontalPanel
            abstract setCellHeight: widget: Widget * height: string -> HorizontalPanel
            abstract setCellHorizontalAlignment: widget: Widget * horizontalAlignment: HorizontalAlignment -> HorizontalPanel
            abstract setCellVerticalAlignment: widget: Widget * verticalAlignment: VerticalAlignment -> HorizontalPanel
            abstract setCellWidth: widget: Widget * width: string -> HorizontalPanel
            abstract setHeight: height: string -> HorizontalPanel
            abstract setHorizontalAlignment: horizontalAlignment: HorizontalAlignment -> HorizontalPanel
            abstract setId: id: string -> HorizontalPanel
            abstract setLayoutData: layout: obj -> HorizontalPanel
            abstract setPixelSize: width: Integer * height: Integer -> HorizontalPanel
            abstract setSize: width: string * height: string -> HorizontalPanel
            abstract setSpacing: spacing: Integer -> HorizontalPanel
            abstract setStyleAttribute: attribute: string * value: string -> HorizontalPanel
            abstract setStyleAttributes: attributes: obj -> HorizontalPanel
            abstract setStyleName: styleName: string -> HorizontalPanel
            abstract setStylePrimaryName: styleName: string -> HorizontalPanel
            abstract setTag: tag: string -> HorizontalPanel
            abstract setTitle: title: string -> HorizontalPanel
            abstract setVerticalAlignment: verticalAlignment: VerticalAlignment -> HorizontalPanel
            abstract setVisible: visible: bool -> HorizontalPanel
            abstract setWidth: width: string -> HorizontalPanel

        and [<AllowNullLiteral>] Image =
            abstract addClickHandler: handler: Handler -> Image
            abstract addErrorHandler: handler: Handler -> Image
            abstract addLoadHandler: handler: Handler -> Image
            abstract addMouseDownHandler: handler: Handler -> Image
            abstract addMouseMoveHandler: handler: Handler -> Image
            abstract addMouseOutHandler: handler: Handler -> Image
            abstract addMouseOverHandler: handler: Handler -> Image
            abstract addMouseUpHandler: handler: Handler -> Image
            abstract addMouseWheelHandler: handler: Handler -> Image
            abstract addStyleDependentName: styleName: string -> Image
            abstract addStyleName: styleName: string -> Image
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setHeight: height: string -> Image
            abstract setId: id: string -> Image
            abstract setLayoutData: layout: obj -> Image
            abstract setPixelSize: width: Integer * height: Integer -> Image
            abstract setResource: resource: Component -> Image
            abstract setSize: width: string * height: string -> Image
            abstract setStyleAttribute: attribute: string * value: string -> Image
            abstract setStyleAttributes: attributes: obj -> Image
            abstract setStyleName: styleName: string -> Image
            abstract setStylePrimaryName: styleName: string -> Image
            abstract setTag: tag: string -> Image
            abstract setTitle: title: string -> Image
            abstract setUrl: url: string -> Image
            abstract setUrlAndVisibleRect: url: string * left: Integer * top: Integer * width: Integer * height: Integer -> Image
            abstract setVisible: visible: bool -> Image
            abstract setVisibleRect: left: Integer * top: Integer * width: Integer * height: Integer -> Image
            abstract setWidth: width: string -> Image

        and [<AllowNullLiteral>] InlineLabel =
            abstract addClickHandler: handler: Handler -> InlineLabel
            abstract addMouseDownHandler: handler: Handler -> InlineLabel
            abstract addMouseMoveHandler: handler: Handler -> InlineLabel
            abstract addMouseOutHandler: handler: Handler -> InlineLabel
            abstract addMouseOverHandler: handler: Handler -> InlineLabel
            abstract addMouseUpHandler: handler: Handler -> InlineLabel
            abstract addMouseWheelHandler: handler: Handler -> InlineLabel
            abstract addStyleDependentName: styleName: string -> InlineLabel
            abstract addStyleName: styleName: string -> InlineLabel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setDirection: direction: Component -> InlineLabel
            abstract setHeight: height: string -> InlineLabel
            abstract setHorizontalAlignment: horizontalAlignment: HorizontalAlignment -> InlineLabel
            abstract setId: id: string -> InlineLabel
            abstract setLayoutData: layout: obj -> InlineLabel
            abstract setPixelSize: width: Integer * height: Integer -> InlineLabel
            abstract setSize: width: string * height: string -> InlineLabel
            abstract setStyleAttribute: attribute: string * value: string -> InlineLabel
            abstract setStyleAttributes: attributes: obj -> InlineLabel
            abstract setStyleName: styleName: string -> InlineLabel
            abstract setStylePrimaryName: styleName: string -> InlineLabel
            abstract setTag: tag: string -> InlineLabel
            abstract setText: text: string -> InlineLabel
            abstract setTitle: title: string -> InlineLabel
            abstract setVisible: visible: bool -> InlineLabel
            abstract setWidth: width: string -> InlineLabel
            abstract setWordWrap: wordWrap: bool -> InlineLabel

        and [<AllowNullLiteral>] Label =
            abstract addClickHandler: handler: Handler -> Label
            abstract addMouseDownHandler: handler: Handler -> Label
            abstract addMouseMoveHandler: handler: Handler -> Label
            abstract addMouseOutHandler: handler: Handler -> Label
            abstract addMouseOverHandler: handler: Handler -> Label
            abstract addMouseUpHandler: handler: Handler -> Label
            abstract addMouseWheelHandler: handler: Handler -> Label
            abstract addStyleDependentName: styleName: string -> Label
            abstract addStyleName: styleName: string -> Label
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setDirection: direction: Component -> Label
            abstract setHeight: height: string -> Label
            abstract setHorizontalAlignment: horizontalAlignment: HorizontalAlignment -> Label
            abstract setId: id: string -> Label
            abstract setLayoutData: layout: obj -> Label
            abstract setPixelSize: width: Integer * height: Integer -> Label
            abstract setSize: width: string * height: string -> Label
            abstract setStyleAttribute: attribute: string * value: string -> Label
            abstract setStyleAttributes: attributes: obj -> Label
            abstract setStyleName: styleName: string -> Label
            abstract setStylePrimaryName: styleName: string -> Label
            abstract setTag: tag: string -> Label
            abstract setText: text: string -> Label
            abstract setTitle: title: string -> Label
            abstract setVisible: visible: bool -> Label
            abstract setWidth: width: string -> Label
            abstract setWordWrap: wordWrap: bool -> Label

        and [<AllowNullLiteral>] ListBox =
            abstract addBlurHandler: handler: Handler -> ListBox
            abstract addChangeHandler: handler: Handler -> ListBox
            abstract addClickHandler: handler: Handler -> ListBox
            abstract addFocusHandler: handler: Handler -> ListBox
            abstract addItem: text: string -> ListBox
            abstract addItem: text: string * value: string -> ListBox
            abstract addKeyDownHandler: handler: Handler -> ListBox
            abstract addKeyPressHandler: handler: Handler -> ListBox
            abstract addKeyUpHandler: handler: Handler -> ListBox
            abstract addMouseDownHandler: handler: Handler -> ListBox
            abstract addMouseMoveHandler: handler: Handler -> ListBox
            abstract addMouseOutHandler: handler: Handler -> ListBox
            abstract addMouseOverHandler: handler: Handler -> ListBox
            abstract addMouseUpHandler: handler: Handler -> ListBox
            abstract addMouseWheelHandler: handler: Handler -> ListBox
            abstract addStyleDependentName: styleName: string -> ListBox
            abstract addStyleName: styleName: string -> ListBox
            abstract clear: unit -> ListBox
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract removeItem: index: Integer -> ListBox
            abstract setAccessKey: accessKey: Char -> ListBox
            abstract setEnabled: enabled: bool -> ListBox
            abstract setFocus: focus: bool -> ListBox
            abstract setHeight: height: string -> ListBox
            abstract setId: id: string -> ListBox
            abstract setItemSelected: index: Integer * selected: bool -> ListBox
            abstract setItemText: index: Integer * text: string -> ListBox
            abstract setLayoutData: layout: obj -> ListBox
            abstract setName: name: string -> ListBox
            abstract setPixelSize: width: Integer * height: Integer -> ListBox
            abstract setSelectedIndex: index: Integer -> ListBox
            abstract setSize: width: string * height: string -> ListBox
            abstract setStyleAttribute: attribute: string * value: string -> ListBox
            abstract setStyleAttributes: attributes: obj -> ListBox
            abstract setStyleName: styleName: string -> ListBox
            abstract setStylePrimaryName: styleName: string -> ListBox
            abstract setTabIndex: index: Integer -> ListBox
            abstract setTag: tag: string -> ListBox
            abstract setTitle: title: string -> ListBox
            abstract setValue: index: Integer * value: string -> ListBox
            abstract setVisible: visible: bool -> ListBox
            abstract setVisibleItemCount: count: Integer -> ListBox
            abstract setWidth: width: string -> ListBox

        and [<AllowNullLiteral>] MenuBar =
            abstract addCloseHandler: handler: Handler -> MenuBar
            abstract addItem: item: MenuItem -> MenuBar
            abstract addItem: text: string * asHtml: bool * command: Handler -> MenuBar
            abstract addItem: text: string * asHtml: bool * subMenu: MenuBar -> MenuBar
            abstract addItem: text: string * command: Handler -> MenuBar
            abstract addItem: text: string * subMenu: MenuBar -> MenuBar
            abstract addSeparator: unit -> MenuBar
            abstract addSeparator: separator: MenuItemSeparator -> MenuBar
            abstract addStyleDependentName: styleName: string -> MenuBar
            abstract addStyleName: styleName: string -> MenuBar
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAnimationEnabled: animationEnabled: bool -> MenuBar
            abstract setAutoOpen: autoOpen: bool -> MenuBar
            abstract setHeight: height: string -> MenuBar
            abstract setId: id: string -> MenuBar
            abstract setLayoutData: layout: obj -> MenuBar
            abstract setPixelSize: width: Integer * height: Integer -> MenuBar
            abstract setSize: width: string * height: string -> MenuBar
            abstract setStyleAttribute: attribute: string * value: string -> MenuBar
            abstract setStyleAttributes: attributes: obj -> MenuBar
            abstract setStyleName: styleName: string -> MenuBar
            abstract setStylePrimaryName: styleName: string -> MenuBar
            abstract setTag: tag: string -> MenuBar
            abstract setTitle: title: string -> MenuBar
            abstract setVisible: visible: bool -> MenuBar
            abstract setWidth: width: string -> MenuBar

        and [<AllowNullLiteral>] MenuItem =
            abstract addStyleDependentName: styleName: string -> MenuItem
            abstract addStyleName: styleName: string -> MenuItem
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setCommand: handler: Handler -> MenuItem
            abstract setHTML: html: string -> MenuItem
            abstract setHeight: height: string -> MenuItem
            abstract setId: id: string -> MenuItem
            abstract setPixelSize: width: Integer * height: Integer -> MenuItem
            abstract setSize: width: string * height: string -> MenuItem
            abstract setStyleAttribute: attribute: string * value: string -> MenuItem
            abstract setStyleAttributes: attributes: obj -> MenuItem
            abstract setStyleName: styleName: string -> MenuItem
            abstract setStylePrimaryName: styleName: string -> MenuItem
            abstract setSubMenu: subMenu: MenuBar -> MenuItem
            abstract setTag: tag: string -> MenuItem
            abstract setText: text: string -> MenuItem
            abstract setTitle: title: string -> MenuItem
            abstract setVisible: visible: bool -> MenuItem
            abstract setWidth: width: string -> MenuItem

        and [<AllowNullLiteral>] MenuItemSeparator =
            abstract addStyleDependentName: styleName: string -> MenuItemSeparator
            abstract addStyleName: styleName: string -> MenuItemSeparator
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setHeight: height: string -> MenuItemSeparator
            abstract setId: id: string -> MenuItemSeparator
            abstract setPixelSize: width: Integer * height: Integer -> MenuItemSeparator
            abstract setSize: width: string * height: string -> MenuItemSeparator
            abstract setStyleAttribute: attribute: string * value: string -> MenuItemSeparator
            abstract setStyleAttributes: attributes: obj -> MenuItemSeparator
            abstract setStyleName: styleName: string -> MenuItemSeparator
            abstract setStylePrimaryName: styleName: string -> MenuItemSeparator
            abstract setTag: tag: string -> MenuItemSeparator
            abstract setTitle: title: string -> MenuItemSeparator
            abstract setVisible: visible: bool -> MenuItemSeparator
            abstract setWidth: width: string -> MenuItemSeparator

        and [<AllowNullLiteral>] PasswordTextBox =
            abstract addBlurHandler: handler: Handler -> PasswordTextBox
            abstract addChangeHandler: handler: Handler -> PasswordTextBox
            abstract addClickHandler: handler: Handler -> PasswordTextBox
            abstract addFocusHandler: handler: Handler -> PasswordTextBox
            abstract addKeyDownHandler: handler: Handler -> PasswordTextBox
            abstract addKeyPressHandler: handler: Handler -> PasswordTextBox
            abstract addKeyUpHandler: handler: Handler -> PasswordTextBox
            abstract addMouseDownHandler: handler: Handler -> PasswordTextBox
            abstract addMouseMoveHandler: handler: Handler -> PasswordTextBox
            abstract addMouseOutHandler: handler: Handler -> PasswordTextBox
            abstract addMouseOverHandler: handler: Handler -> PasswordTextBox
            abstract addMouseUpHandler: handler: Handler -> PasswordTextBox
            abstract addMouseWheelHandler: handler: Handler -> PasswordTextBox
            abstract addStyleDependentName: styleName: string -> PasswordTextBox
            abstract addStyleName: styleName: string -> PasswordTextBox
            abstract addValueChangeHandler: handler: Handler -> PasswordTextBox
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> PasswordTextBox
            abstract setCursorPos: position: Integer -> PasswordTextBox
            abstract setDirection: direction: Component -> PasswordTextBox
            abstract setEnabled: enabled: bool -> PasswordTextBox
            abstract setFocus: focus: bool -> PasswordTextBox
            abstract setHeight: height: string -> PasswordTextBox
            abstract setId: id: string -> PasswordTextBox
            abstract setLayoutData: layout: obj -> PasswordTextBox
            abstract setMaxLength: length: Integer -> PasswordTextBox
            abstract setName: name: string -> PasswordTextBox
            abstract setPixelSize: width: Integer * height: Integer -> PasswordTextBox
            abstract setReadOnly: readOnly: bool -> PasswordTextBox
            abstract setSelectionRange: position: Integer * length: Integer -> PasswordTextBox
            abstract setSize: width: string * height: string -> PasswordTextBox
            abstract setStyleAttribute: attribute: string * value: string -> PasswordTextBox
            abstract setStyleAttributes: attributes: obj -> PasswordTextBox
            abstract setStyleName: styleName: string -> PasswordTextBox
            abstract setStylePrimaryName: styleName: string -> PasswordTextBox
            abstract setTabIndex: index: Integer -> PasswordTextBox
            abstract setTag: tag: string -> PasswordTextBox
            abstract setText: text: string -> PasswordTextBox
            abstract setTextAlignment: textAlign: Component -> PasswordTextBox
            abstract setTitle: title: string -> PasswordTextBox
            abstract setValue: value: string -> PasswordTextBox
            abstract setValue: value: string * fireEvents: bool -> PasswordTextBox
            abstract setVisible: visible: bool -> PasswordTextBox
            abstract setVisibleLength: length: Integer -> PasswordTextBox
            abstract setWidth: width: string -> PasswordTextBox

        and [<AllowNullLiteral>] PopupPanel =
            abstract add: widget: Widget -> PopupPanel
            abstract addAutoHidePartner: partner: Component -> PopupPanel
            abstract addCloseHandler: handler: Handler -> PopupPanel
            abstract addStyleDependentName: styleName: string -> PopupPanel
            abstract addStyleName: styleName: string -> PopupPanel
            abstract clear: unit -> PopupPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract hide: unit -> PopupPanel
            abstract setAnimationEnabled: animationEnabled: bool -> PopupPanel
            abstract setAutoHideEnabled: enabled: bool -> PopupPanel
            abstract setGlassEnabled: enabled: bool -> PopupPanel
            abstract setGlassStyleName: styleName: string -> PopupPanel
            abstract setHeight: height: string -> PopupPanel
            abstract setId: id: string -> PopupPanel
            abstract setLayoutData: layout: obj -> PopupPanel
            abstract setModal: modal: bool -> PopupPanel
            abstract setPixelSize: width: Integer * height: Integer -> PopupPanel
            abstract setPopupPosition: left: Integer * top: Integer -> PopupPanel
            abstract setPopupPositionAndShow: a: Component -> PopupPanel
            abstract setPreviewingAllNativeEvents: previewing: bool -> PopupPanel
            abstract setSize: width: string * height: string -> PopupPanel
            abstract setStyleAttribute: attribute: string * value: string -> PopupPanel
            abstract setStyleAttributes: attributes: obj -> PopupPanel
            abstract setStyleName: styleName: string -> PopupPanel
            abstract setStylePrimaryName: styleName: string -> PopupPanel
            abstract setTag: tag: string -> PopupPanel
            abstract setTitle: title: string -> PopupPanel
            abstract setVisible: visible: bool -> PopupPanel
            abstract setWidget: widget: Widget -> PopupPanel
            abstract setWidth: width: string -> PopupPanel
            abstract show: unit -> PopupPanel

        and [<AllowNullLiteral>] PushButton =
            abstract addBlurHandler: handler: Handler -> PushButton
            abstract addClickHandler: handler: Handler -> PushButton
            abstract addFocusHandler: handler: Handler -> PushButton
            abstract addKeyDownHandler: handler: Handler -> PushButton
            abstract addKeyPressHandler: handler: Handler -> PushButton
            abstract addKeyUpHandler: handler: Handler -> PushButton
            abstract addMouseDownHandler: handler: Handler -> PushButton
            abstract addMouseMoveHandler: handler: Handler -> PushButton
            abstract addMouseOutHandler: handler: Handler -> PushButton
            abstract addMouseOverHandler: handler: Handler -> PushButton
            abstract addMouseUpHandler: handler: Handler -> PushButton
            abstract addMouseWheelHandler: handler: Handler -> PushButton
            abstract addStyleDependentName: styleName: string -> PushButton
            abstract addStyleName: styleName: string -> PushButton
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> PushButton
            abstract setEnabled: enabled: bool -> PushButton
            abstract setFocus: focus: bool -> PushButton
            abstract setHTML: html: string -> PushButton
            abstract setHeight: height: string -> PushButton
            abstract setId: id: string -> PushButton
            abstract setLayoutData: layout: obj -> PushButton
            abstract setPixelSize: width: Integer * height: Integer -> PushButton
            abstract setSize: width: string * height: string -> PushButton
            abstract setStyleAttribute: attribute: string * value: string -> PushButton
            abstract setStyleAttributes: attributes: obj -> PushButton
            abstract setStyleName: styleName: string -> PushButton
            abstract setStylePrimaryName: styleName: string -> PushButton
            abstract setTabIndex: index: Integer -> PushButton
            abstract setTag: tag: string -> PushButton
            abstract setText: text: string -> PushButton
            abstract setTitle: title: string -> PushButton
            abstract setVisible: visible: bool -> PushButton
            abstract setWidth: width: string -> PushButton

        and [<AllowNullLiteral>] RadioButton =
            abstract addBlurHandler: handler: Handler -> RadioButton
            abstract addClickHandler: handler: Handler -> RadioButton
            abstract addFocusHandler: handler: Handler -> RadioButton
            abstract addKeyDownHandler: handler: Handler -> RadioButton
            abstract addKeyPressHandler: handler: Handler -> RadioButton
            abstract addKeyUpHandler: handler: Handler -> RadioButton
            abstract addMouseDownHandler: handler: Handler -> RadioButton
            abstract addMouseMoveHandler: handler: Handler -> RadioButton
            abstract addMouseOutHandler: handler: Handler -> RadioButton
            abstract addMouseOverHandler: handler: Handler -> RadioButton
            abstract addMouseUpHandler: handler: Handler -> RadioButton
            abstract addMouseWheelHandler: handler: Handler -> RadioButton
            abstract addStyleDependentName: styleName: string -> RadioButton
            abstract addStyleName: styleName: string -> RadioButton
            abstract addValueChangeHandler: handler: Handler -> RadioButton
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> RadioButton
            abstract setEnabled: enabled: bool -> RadioButton
            abstract setFocus: focus: bool -> RadioButton
            abstract setFormValue: formValue: string -> RadioButton
            abstract setHTML: html: string -> RadioButton
            abstract setHeight: height: string -> RadioButton
            abstract setId: id: string -> RadioButton
            abstract setLayoutData: layout: obj -> RadioButton
            abstract setName: name: string -> RadioButton
            abstract setPixelSize: width: Integer * height: Integer -> RadioButton
            abstract setSize: width: string * height: string -> RadioButton
            abstract setStyleAttribute: attribute: string * value: string -> RadioButton
            abstract setStyleAttributes: attributes: obj -> RadioButton
            abstract setStyleName: styleName: string -> RadioButton
            abstract setStylePrimaryName: styleName: string -> RadioButton
            abstract setTabIndex: index: Integer -> RadioButton
            abstract setTag: tag: string -> RadioButton
            abstract setText: text: string -> RadioButton
            abstract setTitle: title: string -> RadioButton
            abstract setValue: value: bool -> RadioButton
            abstract setValue: value: bool * fireEvents: bool -> RadioButton
            abstract setVisible: visible: bool -> RadioButton
            abstract setWidth: width: string -> RadioButton

        and [<AllowNullLiteral>] ResetButton =
            abstract addBlurHandler: handler: Handler -> ResetButton
            abstract addClickHandler: handler: Handler -> ResetButton
            abstract addFocusHandler: handler: Handler -> ResetButton
            abstract addKeyDownHandler: handler: Handler -> ResetButton
            abstract addKeyPressHandler: handler: Handler -> ResetButton
            abstract addKeyUpHandler: handler: Handler -> ResetButton
            abstract addMouseDownHandler: handler: Handler -> ResetButton
            abstract addMouseMoveHandler: handler: Handler -> ResetButton
            abstract addMouseOutHandler: handler: Handler -> ResetButton
            abstract addMouseOverHandler: handler: Handler -> ResetButton
            abstract addMouseUpHandler: handler: Handler -> ResetButton
            abstract addMouseWheelHandler: handler: Handler -> ResetButton
            abstract addStyleDependentName: styleName: string -> ResetButton
            abstract addStyleName: styleName: string -> ResetButton
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> ResetButton
            abstract setEnabled: enabled: bool -> ResetButton
            abstract setFocus: focus: bool -> ResetButton
            abstract setHTML: html: string -> ResetButton
            abstract setHeight: height: string -> ResetButton
            abstract setId: id: string -> ResetButton
            abstract setLayoutData: layout: obj -> ResetButton
            abstract setPixelSize: width: Integer * height: Integer -> ResetButton
            abstract setSize: width: string * height: string -> ResetButton
            abstract setStyleAttribute: attribute: string * value: string -> ResetButton
            abstract setStyleAttributes: attributes: obj -> ResetButton
            abstract setStyleName: styleName: string -> ResetButton
            abstract setStylePrimaryName: styleName: string -> ResetButton
            abstract setTabIndex: index: Integer -> ResetButton
            abstract setTag: tag: string -> ResetButton
            abstract setText: text: string -> ResetButton
            abstract setTitle: title: string -> ResetButton
            abstract setVisible: visible: bool -> ResetButton
            abstract setWidth: width: string -> ResetButton

        and [<AllowNullLiteral>] ScrollPanel =
            abstract add: widget: Widget -> ScrollPanel
            abstract addScrollHandler: handler: Handler -> ScrollPanel
            abstract addStyleDependentName: styleName: string -> ScrollPanel
            abstract addStyleName: styleName: string -> ScrollPanel
            abstract clear: unit -> ScrollPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAlwaysShowScrollBars: alwaysShow: bool -> ScrollPanel
            abstract setHeight: height: string -> ScrollPanel
            abstract setHorizontalScrollPosition: position: Integer -> ScrollPanel
            abstract setId: id: string -> ScrollPanel
            abstract setLayoutData: layout: obj -> ScrollPanel
            abstract setPixelSize: width: Integer * height: Integer -> ScrollPanel
            abstract setScrollPosition: position: Integer -> ScrollPanel
            abstract setSize: width: string * height: string -> ScrollPanel
            abstract setStyleAttribute: attribute: string * value: string -> ScrollPanel
            abstract setStyleAttributes: attributes: obj -> ScrollPanel
            abstract setStyleName: styleName: string -> ScrollPanel
            abstract setStylePrimaryName: styleName: string -> ScrollPanel
            abstract setTag: tag: string -> ScrollPanel
            abstract setTitle: title: string -> ScrollPanel
            abstract setVisible: visible: bool -> ScrollPanel
            abstract setWidget: widget: Widget -> ScrollPanel
            abstract setWidth: width: string -> ScrollPanel

        and [<AllowNullLiteral>] ServerHandler =
            abstract addCallbackElement: widget: Widget -> ServerHandler
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setCallbackFunction: functionToInvoke: string -> ServerHandler
            abstract setId: id: string -> ServerHandler
            abstract setTag: tag: string -> ServerHandler
            abstract validateEmail: widget: Widget -> ServerHandler
            abstract validateInteger: widget: Widget -> ServerHandler
            abstract validateLength: widget: Widget * min: Integer * max: Integer -> ServerHandler
            abstract validateMatches: widget: Widget * pattern: string -> ServerHandler
            abstract validateMatches: widget: Widget * pattern: string * flags: string -> ServerHandler
            abstract validateNotEmail: widget: Widget -> ServerHandler
            abstract validateNotInteger: widget: Widget -> ServerHandler
            abstract validateNotLength: widget: Widget * min: Integer * max: Integer -> ServerHandler
            abstract validateNotMatches: widget: Widget * pattern: string -> ServerHandler
            abstract validateNotMatches: widget: Widget * pattern: string * flags: string -> ServerHandler
            abstract validateNotNumber: widget: Widget -> ServerHandler
            abstract validateNotOptions: widget: Widget * options: ResizeArray<string> -> ServerHandler
            abstract validateNotRange: widget: Widget * min: float * max: float -> ServerHandler
            abstract validateNotSum: widgets: ResizeArray<Widget> * sum: Integer -> ServerHandler
            abstract validateNumber: widget: Widget -> ServerHandler
            abstract validateOptions: widget: Widget * options: ResizeArray<string> -> ServerHandler
            abstract validateRange: widget: Widget * min: float * max: float -> ServerHandler
            abstract validateSum: widgets: ResizeArray<Widget> * sum: Integer -> ServerHandler

        and [<AllowNullLiteral>] SimpleCheckBox =
            abstract addBlurHandler: handler: Handler -> SimpleCheckBox
            abstract addClickHandler: handler: Handler -> SimpleCheckBox
            abstract addFocusHandler: handler: Handler -> SimpleCheckBox
            abstract addKeyDownHandler: handler: Handler -> SimpleCheckBox
            abstract addKeyPressHandler: handler: Handler -> SimpleCheckBox
            abstract addKeyUpHandler: handler: Handler -> SimpleCheckBox
            abstract addMouseDownHandler: handler: Handler -> SimpleCheckBox
            abstract addMouseMoveHandler: handler: Handler -> SimpleCheckBox
            abstract addMouseOutHandler: handler: Handler -> SimpleCheckBox
            abstract addMouseOverHandler: handler: Handler -> SimpleCheckBox
            abstract addMouseUpHandler: handler: Handler -> SimpleCheckBox
            abstract addMouseWheelHandler: handler: Handler -> SimpleCheckBox
            abstract addStyleDependentName: styleName: string -> SimpleCheckBox
            abstract addStyleName: styleName: string -> SimpleCheckBox
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> SimpleCheckBox
            abstract setChecked: ``checked``: bool -> SimpleCheckBox
            abstract setEnabled: enabled: bool -> SimpleCheckBox
            abstract setFocus: focus: bool -> SimpleCheckBox
            abstract setHeight: height: string -> SimpleCheckBox
            abstract setId: id: string -> SimpleCheckBox
            abstract setLayoutData: layout: obj -> SimpleCheckBox
            abstract setName: name: string -> SimpleCheckBox
            abstract setPixelSize: width: Integer * height: Integer -> SimpleCheckBox
            abstract setSize: width: string * height: string -> SimpleCheckBox
            abstract setStyleAttribute: attribute: string * value: string -> SimpleCheckBox
            abstract setStyleAttributes: attributes: obj -> SimpleCheckBox
            abstract setStyleName: styleName: string -> SimpleCheckBox
            abstract setStylePrimaryName: styleName: string -> SimpleCheckBox
            abstract setTabIndex: index: Integer -> SimpleCheckBox
            abstract setTag: tag: string -> SimpleCheckBox
            abstract setTitle: title: string -> SimpleCheckBox
            abstract setVisible: visible: bool -> SimpleCheckBox
            abstract setWidth: width: string -> SimpleCheckBox

        and [<AllowNullLiteral>] SimplePanel =
            abstract add: widget: Widget -> SimplePanel
            abstract addStyleDependentName: styleName: string -> SimplePanel
            abstract addStyleName: styleName: string -> SimplePanel
            abstract clear: unit -> SimplePanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setHeight: height: string -> SimplePanel
            abstract setId: id: string -> SimplePanel
            abstract setLayoutData: layout: obj -> SimplePanel
            abstract setPixelSize: width: Integer * height: Integer -> SimplePanel
            abstract setSize: width: string * height: string -> SimplePanel
            abstract setStyleAttribute: attribute: string * value: string -> SimplePanel
            abstract setStyleAttributes: attributes: obj -> SimplePanel
            abstract setStyleName: styleName: string -> SimplePanel
            abstract setStylePrimaryName: styleName: string -> SimplePanel
            abstract setTag: tag: string -> SimplePanel
            abstract setTitle: title: string -> SimplePanel
            abstract setVisible: visible: bool -> SimplePanel
            abstract setWidget: widget: Widget -> SimplePanel
            abstract setWidth: width: string -> SimplePanel

        and [<AllowNullLiteral>] SimpleRadioButton =
            abstract addBlurHandler: handler: Handler -> SimpleRadioButton
            abstract addClickHandler: handler: Handler -> SimpleRadioButton
            abstract addFocusHandler: handler: Handler -> SimpleRadioButton
            abstract addKeyDownHandler: handler: Handler -> SimpleRadioButton
            abstract addKeyPressHandler: handler: Handler -> SimpleRadioButton
            abstract addKeyUpHandler: handler: Handler -> SimpleRadioButton
            abstract addMouseDownHandler: handler: Handler -> SimpleRadioButton
            abstract addMouseMoveHandler: handler: Handler -> SimpleRadioButton
            abstract addMouseOutHandler: handler: Handler -> SimpleRadioButton
            abstract addMouseOverHandler: handler: Handler -> SimpleRadioButton
            abstract addMouseUpHandler: handler: Handler -> SimpleRadioButton
            abstract addMouseWheelHandler: handler: Handler -> SimpleRadioButton
            abstract addStyleDependentName: styleName: string -> SimpleRadioButton
            abstract addStyleName: styleName: string -> SimpleRadioButton
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> SimpleRadioButton
            abstract setChecked: ``checked``: bool -> SimpleRadioButton
            abstract setEnabled: enabled: bool -> SimpleRadioButton
            abstract setFocus: focus: bool -> SimpleRadioButton
            abstract setHeight: height: string -> SimpleRadioButton
            abstract setId: id: string -> SimpleRadioButton
            abstract setLayoutData: layout: obj -> SimpleRadioButton
            abstract setName: name: string -> SimpleRadioButton
            abstract setPixelSize: width: Integer * height: Integer -> SimpleRadioButton
            abstract setSize: width: string * height: string -> SimpleRadioButton
            abstract setStyleAttribute: attribute: string * value: string -> SimpleRadioButton
            abstract setStyleAttributes: attributes: obj -> SimpleRadioButton
            abstract setStyleName: styleName: string -> SimpleRadioButton
            abstract setStylePrimaryName: styleName: string -> SimpleRadioButton
            abstract setTabIndex: index: Integer -> SimpleRadioButton
            abstract setTag: tag: string -> SimpleRadioButton
            abstract setTitle: title: string -> SimpleRadioButton
            abstract setVisible: visible: bool -> SimpleRadioButton
            abstract setWidth: width: string -> SimpleRadioButton

        and [<AllowNullLiteral>] SplitLayoutPanel =
            abstract add: widget: Widget -> SplitLayoutPanel
            abstract addEast: widget: Widget * width: float -> SplitLayoutPanel
            abstract addNorth: widget: Widget * height: float -> SplitLayoutPanel
            abstract addSouth: widget: Widget * height: float -> SplitLayoutPanel
            abstract addStyleDependentName: styleName: string -> SplitLayoutPanel
            abstract addStyleName: styleName: string -> SplitLayoutPanel
            abstract addWest: widget: Widget * width: float -> SplitLayoutPanel
            abstract clear: unit -> SplitLayoutPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract remove: index: Integer -> SplitLayoutPanel
            abstract remove: widget: Widget -> SplitLayoutPanel
            abstract setHeight: height: string -> SplitLayoutPanel
            abstract setId: id: string -> SplitLayoutPanel
            abstract setLayoutData: layout: obj -> SplitLayoutPanel
            abstract setPixelSize: width: Integer * height: Integer -> SplitLayoutPanel
            abstract setSize: width: string * height: string -> SplitLayoutPanel
            abstract setStyleAttribute: attribute: string * value: string -> SplitLayoutPanel
            abstract setStyleAttributes: attributes: obj -> SplitLayoutPanel
            abstract setStyleName: styleName: string -> SplitLayoutPanel
            abstract setStylePrimaryName: styleName: string -> SplitLayoutPanel
            abstract setTag: tag: string -> SplitLayoutPanel
            abstract setTitle: title: string -> SplitLayoutPanel
            abstract setVisible: visible: bool -> SplitLayoutPanel
            abstract setWidgetMinSize: widget: Widget * minSize: Integer -> SplitLayoutPanel
            abstract setWidth: width: string -> SplitLayoutPanel

        and [<AllowNullLiteral>] StackPanel =
            abstract add: widget: Widget -> StackPanel
            abstract add: widget: Widget * text: string -> StackPanel
            abstract add: widget: Widget * text: string * asHtml: bool -> StackPanel
            abstract addStyleDependentName: styleName: string -> StackPanel
            abstract addStyleName: styleName: string -> StackPanel
            abstract clear: unit -> StackPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract remove: index: Integer -> StackPanel
            abstract remove: widget: Widget -> StackPanel
            abstract setHeight: height: string -> StackPanel
            abstract setId: id: string -> StackPanel
            abstract setLayoutData: layout: obj -> StackPanel
            abstract setPixelSize: width: Integer * height: Integer -> StackPanel
            abstract setSize: width: string * height: string -> StackPanel
            abstract setStackText: index: Integer * text: string -> StackPanel
            abstract setStackText: index: Integer * text: string * asHtml: bool -> StackPanel
            abstract setStyleAttribute: attribute: string * value: string -> StackPanel
            abstract setStyleAttributes: attributes: obj -> StackPanel
            abstract setStyleName: styleName: string -> StackPanel
            abstract setStylePrimaryName: styleName: string -> StackPanel
            abstract setTag: tag: string -> StackPanel
            abstract setTitle: title: string -> StackPanel
            abstract setVisible: visible: bool -> StackPanel
            abstract setWidth: width: string -> StackPanel

        and [<AllowNullLiteral>] SubmitButton =
            abstract addBlurHandler: handler: Handler -> SubmitButton
            abstract addClickHandler: handler: Handler -> SubmitButton
            abstract addFocusHandler: handler: Handler -> SubmitButton
            abstract addKeyDownHandler: handler: Handler -> SubmitButton
            abstract addKeyPressHandler: handler: Handler -> SubmitButton
            abstract addKeyUpHandler: handler: Handler -> SubmitButton
            abstract addMouseDownHandler: handler: Handler -> SubmitButton
            abstract addMouseMoveHandler: handler: Handler -> SubmitButton
            abstract addMouseOutHandler: handler: Handler -> SubmitButton
            abstract addMouseOverHandler: handler: Handler -> SubmitButton
            abstract addMouseUpHandler: handler: Handler -> SubmitButton
            abstract addMouseWheelHandler: handler: Handler -> SubmitButton
            abstract addStyleDependentName: styleName: string -> SubmitButton
            abstract addStyleName: styleName: string -> SubmitButton
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> SubmitButton
            abstract setEnabled: enabled: bool -> SubmitButton
            abstract setFocus: focus: bool -> SubmitButton
            abstract setHTML: html: string -> SubmitButton
            abstract setHeight: height: string -> SubmitButton
            abstract setId: id: string -> SubmitButton
            abstract setLayoutData: layout: obj -> SubmitButton
            abstract setPixelSize: width: Integer * height: Integer -> SubmitButton
            abstract setSize: width: string * height: string -> SubmitButton
            abstract setStyleAttribute: attribute: string * value: string -> SubmitButton
            abstract setStyleAttributes: attributes: obj -> SubmitButton
            abstract setStyleName: styleName: string -> SubmitButton
            abstract setStylePrimaryName: styleName: string -> SubmitButton
            abstract setTabIndex: index: Integer -> SubmitButton
            abstract setTag: tag: string -> SubmitButton
            abstract setText: text: string -> SubmitButton
            abstract setTitle: title: string -> SubmitButton
            abstract setVisible: visible: bool -> SubmitButton
            abstract setWidth: width: string -> SubmitButton

        and [<AllowNullLiteral>] SuggestBox =
            abstract addKeyDownHandler: handler: Handler -> SuggestBox
            abstract addKeyPressHandler: handler: Handler -> SuggestBox
            abstract addKeyUpHandler: handler: Handler -> SuggestBox
            abstract addSelectionHandler: handler: Handler -> SuggestBox
            abstract addStyleDependentName: styleName: string -> SuggestBox
            abstract addStyleName: styleName: string -> SuggestBox
            abstract addValueChangeHandler: handler: Handler -> SuggestBox
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> SuggestBox
            abstract setAnimationEnabled: animationEnabled: bool -> SuggestBox
            abstract setAutoSelectEnabled: autoSelectEnabled: bool -> SuggestBox
            abstract setFocus: focus: bool -> SuggestBox
            abstract setHeight: height: string -> SuggestBox
            abstract setId: id: string -> SuggestBox
            abstract setLayoutData: layout: obj -> SuggestBox
            abstract setLimit: limit: Integer -> SuggestBox
            abstract setPixelSize: width: Integer * height: Integer -> SuggestBox
            abstract setPopupStyleName: styleName: string -> SuggestBox
            abstract setSize: width: string * height: string -> SuggestBox
            abstract setStyleAttribute: attribute: string * value: string -> SuggestBox
            abstract setStyleAttributes: attributes: obj -> SuggestBox
            abstract setStyleName: styleName: string -> SuggestBox
            abstract setStylePrimaryName: styleName: string -> SuggestBox
            abstract setTabIndex: index: Integer -> SuggestBox
            abstract setTag: tag: string -> SuggestBox
            abstract setText: text: string -> SuggestBox
            abstract setTitle: title: string -> SuggestBox
            abstract setValue: value: string -> SuggestBox
            abstract setValue: value: string * fireEvents: bool -> SuggestBox
            abstract setVisible: visible: bool -> SuggestBox
            abstract setWidth: width: string -> SuggestBox

        and [<AllowNullLiteral>] TabBar =
            abstract addBeforeSelectionHandler: handler: Handler -> TabBar
            abstract addSelectionHandler: handler: Handler -> TabBar
            abstract addStyleDependentName: styleName: string -> TabBar
            abstract addStyleName: styleName: string -> TabBar
            abstract addTab: title: string -> TabBar
            abstract addTab: title: string * asHtml: bool -> TabBar
            abstract addTab: widget: Widget -> TabBar
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract selectTab: index: Integer -> TabBar
            abstract setHeight: height: string -> TabBar
            abstract setId: id: string -> TabBar
            abstract setLayoutData: layout: obj -> TabBar
            abstract setPixelSize: width: Integer * height: Integer -> TabBar
            abstract setSize: width: string * height: string -> TabBar
            abstract setStyleAttribute: attribute: string * value: string -> TabBar
            abstract setStyleAttributes: attributes: obj -> TabBar
            abstract setStyleName: styleName: string -> TabBar
            abstract setStylePrimaryName: styleName: string -> TabBar
            abstract setTabEnabled: index: Integer * enabled: bool -> TabBar
            abstract setTabText: index: Integer * text: string -> TabBar
            abstract setTag: tag: string -> TabBar
            abstract setTitle: title: string -> TabBar
            abstract setVisible: visible: bool -> TabBar
            abstract setWidth: width: string -> TabBar

        and [<AllowNullLiteral>] TabPanel =
            abstract add: widget: Widget -> TabPanel
            abstract add: widget: Widget * text: string -> TabPanel
            abstract add: widget: Widget * text: string * asHtml: bool -> TabPanel
            abstract add: widget: Widget * tabWidget: Widget -> TabPanel
            abstract addBeforeSelectionHandler: handler: Handler -> TabPanel
            abstract addSelectionHandler: handler: Handler -> TabPanel
            abstract addStyleDependentName: styleName: string -> TabPanel
            abstract addStyleName: styleName: string -> TabPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract selectTab: index: Integer -> TabPanel
            abstract setAnimationEnabled: animationEnabled: bool -> TabPanel
            abstract setHeight: height: string -> TabPanel
            abstract setId: id: string -> TabPanel
            abstract setLayoutData: layout: obj -> TabPanel
            abstract setPixelSize: width: Integer * height: Integer -> TabPanel
            abstract setSize: width: string * height: string -> TabPanel
            abstract setStyleAttribute: attribute: string * value: string -> TabPanel
            abstract setStyleAttributes: attributes: obj -> TabPanel
            abstract setStyleName: styleName: string -> TabPanel
            abstract setStylePrimaryName: styleName: string -> TabPanel
            abstract setTag: tag: string -> TabPanel
            abstract setTitle: title: string -> TabPanel
            abstract setVisible: visible: bool -> TabPanel
            abstract setWidth: width: string -> TabPanel

        and [<AllowNullLiteral>] TextArea =
            abstract addBlurHandler: handler: Handler -> TextArea
            abstract addChangeHandler: handler: Handler -> TextArea
            abstract addClickHandler: handler: Handler -> TextArea
            abstract addFocusHandler: handler: Handler -> TextArea
            abstract addKeyDownHandler: handler: Handler -> TextArea
            abstract addKeyPressHandler: handler: Handler -> TextArea
            abstract addKeyUpHandler: handler: Handler -> TextArea
            abstract addMouseDownHandler: handler: Handler -> TextArea
            abstract addMouseMoveHandler: handler: Handler -> TextArea
            abstract addMouseOutHandler: handler: Handler -> TextArea
            abstract addMouseOverHandler: handler: Handler -> TextArea
            abstract addMouseUpHandler: handler: Handler -> TextArea
            abstract addMouseWheelHandler: handler: Handler -> TextArea
            abstract addStyleDependentName: styleName: string -> TextArea
            abstract addStyleName: styleName: string -> TextArea
            abstract addValueChangeHandler: handler: Handler -> TextArea
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> TextArea
            abstract setCharacterWidth: width: Integer -> TextArea
            abstract setCursorPos: position: Integer -> TextArea
            abstract setDirection: direction: Component -> TextArea
            abstract setEnabled: enabled: bool -> TextArea
            abstract setFocus: focus: bool -> TextArea
            abstract setHeight: height: string -> TextArea
            abstract setId: id: string -> TextArea
            abstract setLayoutData: layout: obj -> TextArea
            abstract setName: name: string -> TextArea
            abstract setPixelSize: width: Integer * height: Integer -> TextArea
            abstract setReadOnly: readOnly: bool -> TextArea
            abstract setSelectionRange: position: Integer * length: Integer -> TextArea
            abstract setSize: width: string * height: string -> TextArea
            abstract setStyleAttribute: attribute: string * value: string -> TextArea
            abstract setStyleAttributes: attributes: obj -> TextArea
            abstract setStyleName: styleName: string -> TextArea
            abstract setStylePrimaryName: styleName: string -> TextArea
            abstract setTabIndex: index: Integer -> TextArea
            abstract setTag: tag: string -> TextArea
            abstract setText: text: string -> TextArea
            abstract setTextAlignment: textAlign: Component -> TextArea
            abstract setTitle: title: string -> TextArea
            abstract setValue: value: string -> TextArea
            abstract setValue: value: string * fireEvents: bool -> TextArea
            abstract setVisible: visible: bool -> TextArea
            abstract setVisibleLines: lines: Integer -> TextArea
            abstract setWidth: width: string -> TextArea

        and [<AllowNullLiteral>] TextBox =
            abstract addBlurHandler: handler: Handler -> TextBox
            abstract addChangeHandler: handler: Handler -> TextBox
            abstract addClickHandler: handler: Handler -> TextBox
            abstract addFocusHandler: handler: Handler -> TextBox
            abstract addKeyDownHandler: handler: Handler -> TextBox
            abstract addKeyPressHandler: handler: Handler -> TextBox
            abstract addKeyUpHandler: handler: Handler -> TextBox
            abstract addMouseDownHandler: handler: Handler -> TextBox
            abstract addMouseMoveHandler: handler: Handler -> TextBox
            abstract addMouseOutHandler: handler: Handler -> TextBox
            abstract addMouseOverHandler: handler: Handler -> TextBox
            abstract addMouseUpHandler: handler: Handler -> TextBox
            abstract addMouseWheelHandler: handler: Handler -> TextBox
            abstract addStyleDependentName: styleName: string -> TextBox
            abstract addStyleName: styleName: string -> TextBox
            abstract addValueChangeHandler: handler: Handler -> TextBox
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> TextBox
            abstract setCursorPos: position: Integer -> TextBox
            abstract setDirection: direction: Component -> TextBox
            abstract setEnabled: enabled: bool -> TextBox
            abstract setFocus: focus: bool -> TextBox
            abstract setHeight: height: string -> TextBox
            abstract setId: id: string -> TextBox
            abstract setLayoutData: layout: obj -> TextBox
            abstract setMaxLength: length: Integer -> TextBox
            abstract setName: name: string -> TextBox
            abstract setPixelSize: width: Integer * height: Integer -> TextBox
            abstract setReadOnly: readOnly: bool -> TextBox
            abstract setSelectionRange: position: Integer * length: Integer -> TextBox
            abstract setSize: width: string * height: string -> TextBox
            abstract setStyleAttribute: attribute: string * value: string -> TextBox
            abstract setStyleAttributes: attributes: obj -> TextBox
            abstract setStyleName: styleName: string -> TextBox
            abstract setStylePrimaryName: styleName: string -> TextBox
            abstract setTabIndex: index: Integer -> TextBox
            abstract setTag: tag: string -> TextBox
            abstract setText: text: string -> TextBox
            abstract setTextAlignment: textAlign: Component -> TextBox
            abstract setTitle: title: string -> TextBox
            abstract setValue: value: string -> TextBox
            abstract setValue: value: string * fireEvents: bool -> TextBox
            abstract setVisible: visible: bool -> TextBox
            abstract setVisibleLength: length: Integer -> TextBox
            abstract setWidth: width: string -> TextBox

        and [<AllowNullLiteral>] ToggleButton =
            abstract addBlurHandler: handler: Handler -> ToggleButton
            abstract addClickHandler: handler: Handler -> ToggleButton
            abstract addFocusHandler: handler: Handler -> ToggleButton
            abstract addKeyDownHandler: handler: Handler -> ToggleButton
            abstract addKeyPressHandler: handler: Handler -> ToggleButton
            abstract addKeyUpHandler: handler: Handler -> ToggleButton
            abstract addMouseDownHandler: handler: Handler -> ToggleButton
            abstract addMouseMoveHandler: handler: Handler -> ToggleButton
            abstract addMouseOutHandler: handler: Handler -> ToggleButton
            abstract addMouseOverHandler: handler: Handler -> ToggleButton
            abstract addMouseUpHandler: handler: Handler -> ToggleButton
            abstract addMouseWheelHandler: handler: Handler -> ToggleButton
            abstract addStyleDependentName: styleName: string -> ToggleButton
            abstract addStyleName: styleName: string -> ToggleButton
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> ToggleButton
            abstract setDown: down: bool -> ToggleButton
            abstract setEnabled: enabled: bool -> ToggleButton
            abstract setFocus: focus: bool -> ToggleButton
            abstract setHTML: html: string -> ToggleButton
            abstract setHeight: height: string -> ToggleButton
            abstract setId: id: string -> ToggleButton
            abstract setLayoutData: layout: obj -> ToggleButton
            abstract setPixelSize: width: Integer * height: Integer -> ToggleButton
            abstract setSize: width: string * height: string -> ToggleButton
            abstract setStyleAttribute: attribute: string * value: string -> ToggleButton
            abstract setStyleAttributes: attributes: obj -> ToggleButton
            abstract setStyleName: styleName: string -> ToggleButton
            abstract setStylePrimaryName: styleName: string -> ToggleButton
            abstract setTabIndex: index: Integer -> ToggleButton
            abstract setTag: tag: string -> ToggleButton
            abstract setText: text: string -> ToggleButton
            abstract setTitle: title: string -> ToggleButton
            abstract setVisible: visible: bool -> ToggleButton
            abstract setWidth: width: string -> ToggleButton

        and [<AllowNullLiteral>] Tree =
            abstract add: widget: Widget -> Tree
            abstract addBlurHandler: handler: Handler -> Tree
            abstract addCloseHandler: handler: Handler -> Tree
            abstract addFocusHandler: handler: Handler -> Tree
            abstract addItem: text: string -> Tree
            abstract addItem: item: TreeItem -> Tree
            abstract addItem: widget: Widget -> Tree
            abstract addKeyDownHandler: handler: Handler -> Tree
            abstract addKeyPressHandler: handler: Handler -> Tree
            abstract addKeyUpHandler: handler: Handler -> Tree
            abstract addMouseDownHandler: handler: Handler -> Tree
            abstract addMouseMoveHandler: handler: Handler -> Tree
            abstract addMouseOutHandler: handler: Handler -> Tree
            abstract addMouseOverHandler: handler: Handler -> Tree
            abstract addMouseUpHandler: handler: Handler -> Tree
            abstract addMouseWheelHandler: handler: Handler -> Tree
            abstract addOpenHandler: handler: Handler -> Tree
            abstract addSelectionHandler: handler: Handler -> Tree
            abstract addStyleDependentName: styleName: string -> Tree
            abstract addStyleName: styleName: string -> Tree
            abstract clear: unit -> Tree
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setAccessKey: accessKey: Char -> Tree
            abstract setAnimationEnabled: animationEnabled: bool -> Tree
            abstract setFocus: focus: bool -> Tree
            abstract setHeight: height: string -> Tree
            abstract setId: id: string -> Tree
            abstract setLayoutData: layout: obj -> Tree
            abstract setPixelSize: width: Integer * height: Integer -> Tree
            abstract setSelectedItem: item: TreeItem -> Tree
            abstract setSelectedItem: item: TreeItem * fireEvents: bool -> Tree
            abstract setSize: width: string * height: string -> Tree
            abstract setStyleAttribute: attribute: string * value: string -> Tree
            abstract setStyleAttributes: attributes: obj -> Tree
            abstract setStyleName: styleName: string -> Tree
            abstract setStylePrimaryName: styleName: string -> Tree
            abstract setTabIndex: index: Integer -> Tree
            abstract setTag: tag: string -> Tree
            abstract setTitle: title: string -> Tree
            abstract setVisible: visible: bool -> Tree
            abstract setWidth: width: string -> Tree

        and [<AllowNullLiteral>] TreeItem =
            abstract addItem: text: string -> TreeItem
            abstract addItem: item: TreeItem -> TreeItem
            abstract addItem: widget: Widget -> TreeItem
            abstract addStyleDependentName: styleName: string -> TreeItem
            abstract addStyleName: styleName: string -> TreeItem
            abstract clear: unit -> TreeItem
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract setHTML: html: string -> TreeItem
            abstract setHeight: height: string -> TreeItem
            abstract setId: id: string -> TreeItem
            abstract setPixelSize: width: Integer * height: Integer -> TreeItem
            abstract setSelected: selected: bool -> TreeItem
            abstract setSize: width: string * height: string -> TreeItem
            abstract setState: ``open``: bool -> TreeItem
            abstract setState: ``open``: bool * fireEvents: bool -> TreeItem
            abstract setStyleAttribute: attribute: string * value: string -> TreeItem
            abstract setStyleAttributes: attributes: obj -> TreeItem
            abstract setStyleName: styleName: string -> TreeItem
            abstract setStylePrimaryName: styleName: string -> TreeItem
            abstract setTag: tag: string -> TreeItem
            abstract setText: text: string -> TreeItem
            abstract setTitle: title: string -> TreeItem
            abstract setUserObject: a: obj -> TreeItem
            abstract setVisible: visible: bool -> TreeItem
            abstract setWidget: widget: Widget -> TreeItem
            abstract setWidth: width: string -> TreeItem

        and [<AllowNullLiteral>] UiApp =
            abstract DateTimeFormat: DateTimeFormat with get, set
            abstract FileType: FileType with get, set
            abstract HorizontalAlignment: HorizontalAlignment with get, set
            abstract VerticalAlignment: VerticalAlignment with get, set
            abstract createApplication: unit -> UiInstance
            abstract getActiveApplication: unit -> UiInstance
            abstract getUserAgent: unit -> string

        and [<AllowNullLiteral>] UiInstance =
            abstract add: child: Widget -> UiInstance
            abstract close: unit -> UiInstance
            abstract createAbsolutePanel: unit -> AbsolutePanel
            abstract createAnchor: text: string * asHtml: bool * href: string -> Anchor
            abstract createAnchor: text: string * href: string -> Anchor
            abstract createButton: unit -> Button
            abstract createButton: html: string -> Button
            abstract createButton: html: string * clickHandler: Handler -> Button
            abstract createCaptionPanel: unit -> CaptionPanel
            abstract createCaptionPanel: caption: string -> CaptionPanel
            abstract createCaptionPanel: caption: string * asHtml: bool -> CaptionPanel
            abstract createCheckBox: unit -> CheckBox
            abstract createCheckBox: label: string -> CheckBox
            abstract createCheckBox: label: string * asHtml: bool -> CheckBox
            abstract createClientHandler: unit -> ClientHandler
            abstract createDateBox: unit -> DateBox
            abstract createDatePicker: unit -> DatePicker
            abstract createDecoratedStackPanel: unit -> DecoratedStackPanel
            abstract createDecoratedTabBar: unit -> DecoratedTabBar
            abstract createDecoratedTabPanel: unit -> DecoratedTabPanel
            abstract createDecoratorPanel: unit -> DecoratorPanel
            abstract createDialogBox: unit -> DialogBox
            abstract createDialogBox: autoHide: bool -> DialogBox
            abstract createDialogBox: autoHide: bool * modal: bool -> DialogBox
            abstract createDocsListDialog: unit -> DocsListDialog
            abstract createFileUpload: unit -> FileUpload
            abstract createFlexTable: unit -> FlexTable
            abstract createFlowPanel: unit -> FlowPanel
            abstract createFocusPanel: unit -> FocusPanel
            abstract createFocusPanel: child: Widget -> FocusPanel
            abstract createFormPanel: unit -> FormPanel
            abstract createGrid: unit -> Grid
            abstract createGrid: rows: Integer * columns: Integer -> Grid
            abstract createHTML: unit -> HTML
            abstract createHTML: html: string -> HTML
            abstract createHTML: html: string * wordWrap: bool -> HTML
            abstract createHidden: unit -> Hidden
            abstract createHidden: name: string -> Hidden
            abstract createHidden: name: string * value: string -> Hidden
            abstract createHorizontalPanel: unit -> HorizontalPanel
            abstract createImage: unit -> Image
            abstract createImage: url: string -> Image
            abstract createImage: url: string * left: Integer * top: Integer * width: Integer * height: Integer -> Image
            abstract createInlineLabel: unit -> InlineLabel
            abstract createInlineLabel: text: string -> InlineLabel
            abstract createLabel: unit -> Label
            abstract createLabel: text: string -> Label
            abstract createLabel: text: string * wordWrap: bool -> Label
            abstract createListBox: unit -> ListBox
            abstract createListBox: isMultipleSelect: bool -> ListBox
            abstract createMenuBar: unit -> MenuBar
            abstract createMenuBar: vertical: bool -> MenuBar
            abstract createMenuItem: text: string * asHtml: bool * command: Handler -> MenuItem
            abstract createMenuItem: text: string * command: Handler -> MenuItem
            abstract createMenuItemSeparator: unit -> MenuItemSeparator
            abstract createPasswordTextBox: unit -> PasswordTextBox
            abstract createPopupPanel: unit -> PopupPanel
            abstract createPopupPanel: autoHide: bool -> PopupPanel
            abstract createPopupPanel: autoHide: bool * modal: bool -> PopupPanel
            abstract createPushButton: unit -> PushButton
            abstract createPushButton: upText: string -> PushButton
            abstract createPushButton: upText: string * clickHandler: Handler -> PushButton
            abstract createPushButton: upText: string * downText: string -> PushButton
            abstract createPushButton: upText: string * downText: string * clickHandler: Handler -> PushButton
            abstract createRadioButton: name: string -> RadioButton
            abstract createRadioButton: name: string * label: string -> RadioButton
            abstract createRadioButton: name: string * label: string * asHtml: bool -> RadioButton
            abstract createResetButton: unit -> ResetButton
            abstract createResetButton: html: string -> ResetButton
            abstract createResetButton: html: string * clickHandler: Handler -> ResetButton
            abstract createScrollPanel: unit -> ScrollPanel
            abstract createScrollPanel: child: Widget -> ScrollPanel
            abstract createServerBlurHandler: unit -> ServerHandler
            abstract createServerBlurHandler: functionName: string -> ServerHandler
            abstract createServerChangeHandler: unit -> ServerHandler
            abstract createServerChangeHandler: functionName: string -> ServerHandler
            abstract createServerClickHandler: unit -> ServerHandler
            abstract createServerClickHandler: functionName: string -> ServerHandler
            abstract createServerCloseHandler: unit -> ServerHandler
            abstract createServerCloseHandler: functionName: string -> ServerHandler
            abstract createServerCommand: unit -> ServerHandler
            abstract createServerCommand: functionName: string -> ServerHandler
            abstract createServerErrorHandler: unit -> ServerHandler
            abstract createServerErrorHandler: functionName: string -> ServerHandler
            abstract createServerFocusHandler: unit -> ServerHandler
            abstract createServerFocusHandler: functionName: string -> ServerHandler
            abstract createServerHandler: unit -> ServerHandler
            abstract createServerHandler: functionName: string -> ServerHandler
            abstract createServerInitializeHandler: unit -> ServerHandler
            abstract createServerInitializeHandler: functionName: string -> ServerHandler
            abstract createServerKeyHandler: unit -> ServerHandler
            abstract createServerKeyHandler: functionName: string -> ServerHandler
            abstract createServerLoadHandler: unit -> ServerHandler
            abstract createServerLoadHandler: functionName: string -> ServerHandler
            abstract createServerMouseHandler: unit -> ServerHandler
            abstract createServerMouseHandler: functionName: string -> ServerHandler
            abstract createServerScrollHandler: unit -> ServerHandler
            abstract createServerScrollHandler: functionName: string -> ServerHandler
            abstract createServerSelectionHandler: unit -> ServerHandler
            abstract createServerSelectionHandler: functionName: string -> ServerHandler
            abstract createServerSubmitHandler: unit -> ServerHandler
            abstract createServerSubmitHandler: functionName: string -> ServerHandler
            abstract createServerValueChangeHandler: unit -> ServerHandler
            abstract createServerValueChangeHandler: functionName: string -> ServerHandler
            abstract createSimpleCheckBox: unit -> SimpleCheckBox
            abstract createSimplePanel: unit -> SimplePanel
            abstract createSimpleRadioButton: name: string -> SimpleRadioButton
            abstract createSplitLayoutPanel: unit -> SplitLayoutPanel
            abstract createStackPanel: unit -> StackPanel
            abstract createSubmitButton: unit -> SubmitButton
            abstract createSubmitButton: html: string -> SubmitButton
            abstract createSuggestBox: unit -> SuggestBox
            abstract createTabBar: unit -> TabBar
            abstract createTabPanel: unit -> TabPanel
            abstract createTextArea: unit -> TextArea
            abstract createTextBox: unit -> TextBox
            abstract createToggleButton: unit -> ToggleButton
            abstract createToggleButton: upText: string -> ToggleButton
            abstract createToggleButton: upText: string * clickHandler: Handler -> ToggleButton
            abstract createToggleButton: upText: string * downText: string -> ToggleButton
            abstract createTree: unit -> Tree
            abstract createTreeItem: unit -> TreeItem
            abstract createTreeItem: text: string -> TreeItem
            abstract createTreeItem: child: Widget -> TreeItem
            abstract createVerticalPanel: unit -> VerticalPanel
            abstract getElementById: id: string -> Component
            abstract getId: unit -> string
            abstract isStandardsMode: unit -> bool
            abstract loadComponent: componentName: string -> Component
            abstract loadComponent: componentName: string * optAdvancedArgs: obj -> Component
            abstract remove: index: Integer -> UiInstance
            abstract remove: widget: Widget -> UiInstance
            abstract setHeight: height: Integer -> UiInstance
            abstract setStandardsMode: standardsMode: bool -> UiInstance
            abstract setStyleAttribute: attribute: string * value: string -> UiInstance
            abstract setTitle: title: string -> UiInstance
            abstract setWidth: width: Integer -> UiInstance

        and VerticalAlignment =
            | TOP = 0
            | MIDDLE = 1
            | BOTTOM = 2

        and [<AllowNullLiteral>] VerticalPanel =
            abstract add: widget: Widget -> VerticalPanel
            abstract addStyleDependentName: styleName: string -> VerticalPanel
            abstract addStyleName: styleName: string -> VerticalPanel
            abstract clear: unit -> VerticalPanel
            abstract getId: unit -> string
            abstract getTag: unit -> string
            abstract getType: unit -> string
            abstract remove: index: Integer -> VerticalPanel
            abstract remove: widget: Widget -> VerticalPanel
            abstract setBorderWidth: width: Integer -> VerticalPanel
            abstract setCellHeight: widget: Widget * height: string -> VerticalPanel
            abstract setCellHorizontalAlignment: widget: Widget * horizontalAlignment: HorizontalAlignment -> VerticalPanel
            abstract setCellVerticalAlignment: widget: Widget * verticalAlignment: VerticalAlignment -> VerticalPanel
            abstract setCellWidth: widget: Widget * width: string -> VerticalPanel
            abstract setHeight: height: string -> VerticalPanel
            abstract setHorizontalAlignment: horizontalAlignment: HorizontalAlignment -> VerticalPanel
            abstract setId: id: string -> VerticalPanel
            abstract setLayoutData: layout: obj -> VerticalPanel
            abstract setPixelSize: width: Integer * height: Integer -> VerticalPanel
            abstract setSize: width: string * height: string -> VerticalPanel
            abstract setSpacing: spacing: Integer -> VerticalPanel
            abstract setStyleAttribute: attribute: string * value: string -> VerticalPanel
            abstract setStyleAttributes: attributes: obj -> VerticalPanel
            abstract setStyleName: styleName: string -> VerticalPanel
            abstract setStylePrimaryName: styleName: string -> VerticalPanel
            abstract setTag: tag: string -> VerticalPanel
            abstract setTitle: title: string -> VerticalPanel
            abstract setVerticalAlignment: verticalAlignment: VerticalAlignment -> VerticalPanel
            abstract setVisible: visible: bool -> VerticalPanel
            abstract setWidth: width: string -> VerticalPanel

        and [<AllowNullLiteral>] Widget =
            abstract getId: unit -> string
            abstract getType: unit -> string

//type [<Erase>]Globals =
//    [<Global>] static member UiApp with get(): GoogleAppsScript.UI.UiApp = jsNative and set(v: GoogleAppsScript.UI.UiApp): unit = jsNative


namespace SpreadSharp

open System
open Microsoft.Office.Interop.Excel
open Types

module XlRange =

    /// <summary>Returns a worksheet range.</summary>
    /// <param name="worksheet">The worksheet containing the range.</param>
    /// <param name="rangeString">The string representing the range.</param>
    /// <returns>The range object.</returns>
    let get (worksheet : Worksheet) (rangeString : string) =
        worksheet.Range rangeString
        |> Com.pushComObj

    /// <summary>Selects a range of cells.</summary>
    /// <param name="range">The range to select.</param>
    let select (range : Range) = range.Select () |> ignore

    /// <summary>Copies a range to the clipboard.</summary>
    /// <param name="range">The range to copy.</param>
    let copy (range : Range) = range.Copy () |> ignore

    /// <summary>Copies a range to the spedified destination.</summary>
    /// <param name="range">The range to copy.</param>
    /// <param name="destination">The destination range.</param>
    let copyToRange (range : Range) (destination : Range) = range.Copy destination |> ignore

    /// <summary>Cuts a range to the clipboard.</summary>
    /// <param name="range">The range to cut.</param>
    let cut (range : Range) = range.Cut () |> ignore

    /// <summary>Cuts a range and pastes it into the specified destination.</summary>
    /// <param name="range">The range to cut.</param>
    /// <param name="destination">The paste destination range.</param>
    let cutPaste (range : Range) (destination : Range) = range.Cut(destination) |> ignore
    
    /// <summary>Deletes a range.</summary>
    /// <param name="range">The range to delete.</param>
    /// <param name="shift">The shift direction.</param>
    let delete (range : Range) (shift : ShiftDirection) = range.Delete shift |> ignore

    /// <summary>Inserts a cell or a range of cells using the
    /// shift direction and copy origin parameters.</summary>
    /// <param name="range">The range representing the column.</param>
    /// <param name="shift">The shift direction.</param>
    /// <param name="copyOrigin">The column index, count starts at 1.</param>
    let insert (range : Range) (shift : ShiftDirection) = range.Insert shift |> ignore

    /// <summary>Performs an autofill from a source range to a destination one. The two ranges must overlap.</summary>
    /// <param name="range">The range from which to start.</param>
    /// <param name="destination">The destination range.</param>
    /// <param name="autoFillType">The auto fill type.</param>
    let autoFill (range : Range) destination autoFillType = range.AutoFill(destination, autoFillType) |> ignore

    /// <summary>Sets the value of a range.</summary>
    /// <param name="range">The range object.</param>
    /// <param name="value">The value to use.</param>
    let setValue (range : Range) value = range.Value2 <- value    

    module Column =

        /// <summary>Returns the range representing the column with the specified index.</summary>
        /// <param name="worksheet">The worksheet containing the column.</param>
        /// <param name="idx">The column index, count starts at 1.</param>
        let byIndex (worksheet : Worksheet) (idx : int) =
            worksheet.Columns.[idx]
            :?> Range
            |> fun x -> x.EntireColumn
            |> Com.pushComObj

        /// <summary>Returns the range representing the column with the specified header.</summary>
        /// <param name="worksheet">The worksheet containing the column.</param>
        /// <param name="header">The column header.</param>
        let byHeader (worksheet : Worksheet) (header : string) =
            worksheet.Columns.[header]
            :?> Range
            |> fun x -> x.EntireColumn
            |> Com.pushComObj

        /// <summary>Inserts a column using shift direction and copy origin parameters.</summary>
        /// <param name="range">The range representing the column.</param>
        /// <param name="shift">The shift direction.</param>
        let insert (range : Range) (shift : ShiftDirection) = range.EntireColumn.Insert shift |> ignore

        /// <summary>Hides a column.</summary>
        /// <param name="range">The range representing the column to hide.</param>
        let hide (range : Range) = range.EntireColumn.Hidden <- true

        /// <summary>Displays a hidden column.</summary>
        /// <param name="range">The range representing the hidden column.</param>
        let unhide (range : Range) = range.EntireColumn.Hidden <- false

    module Row =

        /// <summary>Returns the range representing the row with the specified index.</summary>
        /// <param name="worksheet">The worksheet containing the row.</param>
        /// <param name="idx">The row index, count starts at 1.</param>
        let byIndex (worksheet : Worksheet) (idx : int) =
            worksheet.Rows.[idx]
            :?> Range
            |> fun x -> x.EntireRow
            |> Com.pushComObj

        /// <summary>Insert a row using the shift direction and copy origin parameters.</summary>
        /// <param name="range">The range representing the row.</param>
        /// <param name="shift">The shift direction.</param>
        /// <param name="copyOrigin">The copy origin parameter.</param>
        let insert (range : Range) (shift : ShiftDirection) = range.EntireRow.Insert shift |> ignore

        /// <summary>Hides a row.</summary>
        /// <param name="range">The range representing the row to hide.</param>
        let hide (range : Range) = range.EntireRow.Hidden <- true

        /// <summary>Displays a hidden row.</summary>
        /// <param name="range">The range representing the hidden row.</param>
        let unhide (range : Range) = range.EntireRow.Hidden <- false
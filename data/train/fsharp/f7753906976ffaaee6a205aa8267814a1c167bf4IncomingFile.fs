// CloudExporter is a tool that simplifies saving files from the cloud locally.
//
// Copyright (C) 2015 Andrei Streltsov <andrei@astreltsov.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>. 
module IncomingFile 

open System.IO
open System.Text.RegularExpressions
open CommonTypes


type T = IncomingFile of string

let create filePath = IncomingFile(filePath)

let name (IncomingFile filePath) = Path.GetFileName(filePath)

let copyTo (IncomingFile filePath) (DirPath directory) = 
    File.Copy(filePath, Path.Combine(directory, Path.GetFileName(filePath)), true)

let remove (IncomingFile filePath) = File.Delete(filePath)

let matchesPattern file pattern = Regex.IsMatch(name file, pattern)

let matchesAnyPattern file patterns = 
    patterns 
    |> Seq.where (fun p -> matchesPattern file p) 
    |> Seq.length > 0

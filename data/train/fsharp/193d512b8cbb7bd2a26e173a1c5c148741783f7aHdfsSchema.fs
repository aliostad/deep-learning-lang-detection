namespace global

module HdfsSchema =

    type HdfsEntryInfo = {
        BlockSize : int64
        Group : string
        IsDirectory : bool
        LastAccessed : System.DateTime
        LastModifies : System.DateTime
        Name : string
        Owner : string
        Permissions : int16
        Replication : int16
        Size : int64
    }


    type HdfsRecv =
        | GetDirectoryContents of string
        | GetFileInfo of string
        | Copy of string * string
        | Move of string * string
        | GetFileHead of string * int
        | GetFileTail of string * int
        | GetFileData of string
        | DeleteFile of string
        | WriteFile of string * byte[]

    type HdfsSend =
        | DirectoryContents of string[] * string[]
        | FileInfo of HdfsEntryInfo option
        | CopyResult of bool
        | MoveResult of bool    
        | FileHead of string[]
        | FileTail of string[]
        | FileData of byte[]
        | DeleteResult of bool
        | WriteFileResult of bool
        | Exception of string


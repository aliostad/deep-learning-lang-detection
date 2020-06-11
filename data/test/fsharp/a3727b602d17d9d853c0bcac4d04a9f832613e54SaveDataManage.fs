namespace MyLogic

module SaveDataManage =
    open System
    open System.IO
    open System.Runtime.Serialization.Formatters.Binary
    open DefaultData
    open MyError

    /// <summary>
    /// 設定情報データを集めたクラス
    /// </summary>
    [<Serializable>]
    [<Sealed>]
    type SaveData() =
        // #region フィールド

        /// <summary>
        /// バッファサイズの文字列
        /// </summary>
        let mutable bufferSizeText     = DefaultDataDefinition.DEFAULTBUFSIZETEXT
        
        /// <summary>
        /// ループするかどうか
        /// </summary>
        let mutable isLoop          = DefaultDataDefinition.DEFAULTLOOP
        
        /// <summary>
        /// 並列化するかどうか
        /// </summary>
        let mutable isParallel      = DefaultDataDefinition.DEFAULTPARALLEL
        
        /// <summary>
        /// ベリファイするかどうか
        /// </summary>
        let mutable isVerify        = DefaultDataDefinition.DEFAULTVERIFY

        /// <summary>
        /// 最小化のときの状態
        /// </summary>
        let mutable minimize        = DefaultDataDefinition.DEFAULTMINIMIZE

        /// <summary>
        /// タイマの更新間隔
        /// </summary>
        let mutable timerIntervalText = DefaultDataDefinition.DEFAULTTIMERINTERVALTEXT
        
        /// <summary>
        /// ドライブに書き出す一時ファイル名のフルパス
        /// </summary>
        let mutable tempFilenameFullPath = DefaultDataDefinition.DEFAULTTEMPFILENAMEFULLPATH

        /// <summary>
        /// ドライブに書き出す一時ファイルのバイト数
        /// </summary>
        let mutable tempFileSizeText = DefaultDataDefinition.DEFAULTTEMPFILESIZETEXT

        // #endregion フィールド

        // #region プロパティ 

        /// <summary>
        /// バッファサイズの文字列
        /// </summary>
        member public this.BufferSizeText
            with get() = bufferSizeText
            and set(value) = bufferSizeText <- value
        
        /// <summary>
        /// ループするかどうか
        /// </summary>
        member public this.IsLoop
            with get() = isLoop
            and set(value) = isLoop <- value

        /// <summary>
        /// 並列化するかどうか
        /// </summary>
        member public this.IsParallel
            with get() = isParallel
            and set(value) = isParallel <- value
        
        /// <summary>
        /// ベリファイするかどうか
        /// </summary>
        member public this.IsVerify
            with get() = isVerify
            and set(value) = isVerify <- value
        
        /// <summary>
        /// 最小化のときの状態
        /// </summary>
        member public this.Minimize
            with get() = minimize;
            and set(value) = minimize <- value
        
        /// <summary>
        /// タイマの更新間隔
        /// </summary>
        member public this.TimerIntervalText
            with get() = timerIntervalText
            and set(value) = timerIntervalText <- value

        /// <summary>
        /// ドライブに書き出す一時ファイル名のフルパス
        /// </summary>
        member public this.TempFilenameFullPath
            with get() = tempFilenameFullPath
            and set(value) = tempFilenameFullPath <- value

        /// <summary>
        /// ドライブに書き出す一時ファイルのバイト数
        /// </summary>
        member public this.TempFileSizeText
            with get() = tempFileSizeText
            and set(value) = tempFileSizeText <- value

        // #endregion プロパティ

    /// <summary>
    /// 設定情報データをインポート・エクスポートするクラス
    /// </summary>
    [<Sealed>]
    type SaveDataManage() =
        // #region フィールド

        /// <summary>
        /// 設定情報データのオブジェクト
        /// </summary>
        let mutable sd = new SaveData()

        /// <summary>
        /// 設定情報データ保存ファイル名
        /// </summary>
        static member val XMLFILENAME = "asb2data.dat" with get, set
        
        // #endregion フィールド

        // #region プロパティ

        /// <summary>
        /// 設定情報データのオブジェクト
        /// </summary>
        member public this.SaveData
            with get() = sd
            and set(value) = sd <- value

        // #endregion プロパティ
        
        // #region メソッド
        
        /// <summary>
        /// シリアライズされたデータを読み込みし、メモリに保存する
        /// </summary>
        member public this.dataRead() =
            try
                using (new FileStream(SaveDataManage.XMLFILENAME,
                                      FileMode.Open,
                                      FileAccess.Read)) (fun fs ->
                                                         // 逆シリアル化する
                                                         sd <- (new BinaryFormatter()).Deserialize(fs) :?> SaveData)
            with
                | :? FileNotFoundException -> ()
                | :? InvalidOperationException -> MyError.CallErrorMessageBox(
                                                    String.Format("データを保存したxmlファイルが壊れています。{0}xmlファイルを削除してデフォルトデータを読み込みます"))
                                                  File.Delete(SaveDataManage.XMLFILENAME);
                | _ -> reraise ()

        /// <summary>
        /// データをシリアライズし、ファイルに保存する
        /// </summary>
        member public this.dataSave() =
            try
                using (new FileStream(SaveDataManage.XMLFILENAME,
                                      FileMode.Create,
                                      FileAccess.Write)) (fun fs ->
                                                          //シリアル化して書き込む
                                                          (new BinaryFormatter()).Serialize(fs, sd))
            with
                | e -> let message = String.Format(
                                        "{0}データファイルの書き込みに失敗しました。{0}{1}にログを保存しました。",
                                        Environment.NewLine,
                                        MyError.ErrorLogFilename)
                       CallErrorMessageBox (e.Message + message)
                       WriteLog e

        // #endregion メソッド
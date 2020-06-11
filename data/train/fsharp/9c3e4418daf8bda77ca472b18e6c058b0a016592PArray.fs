[<AutoOpen>]
module Alea.cuExtension.MGPU.PArray
//
//open Alea.CUDA
//open Alea.cuExtension
////open Alea.cuExtension.Util
//open Alea.cuExtension.MGPU.DeviceUtil
//open Alea.cuExtension.MGPU.CTAScan
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Bulk Insert
///// <summary></summary>
//type PBulkInsert() =    
//    member bi.BulkInsert() = cuda {
//        let! api = BulkInsert.bulkInsert() 
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m            
//            fun (data_A:DArray<'TI>) (indices:DArray<int>) (data_B:DArray<'TI>) ->
//                let aCount = data_A.Length
//                let bCount = data_B.Length
//                let api = api aCount bCount
//                let sequence = Array.init bCount (fun i -> i)
//                pcalc {
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                    let! counter = DArray.scatterInBlob worker sequence
//                    let! inserted = DArray.createInBlob<'TI> worker (aCount + bCount)
//                    do! PCalc (fun-> apidata_A.Ptr indices.Ptr counter.Ptr data_B.Ptr partition.Ptr inserted.Ptr)
//                    return inserted } ) }
//
//
//    member bi.BulkInsertFunc() = cuda {
//        let! api = BulkInsert.bulkInsert()    
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//
//            fun (aCount:int) (bCount:int) ->
//                let sequence = Array.init bCount (fun i -> i)
//                pcalc {
//                    let api = api aCount bCount                 
//                    let! counter = DArray.scatterInBlob worker sequence
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                    let insert (data_A:DArray<int>) (indices:DArray<int>) (data_B:DArray<int>) (inserted:DArray<int>) =    
//                        pcalc { do! PCalc (fun-> apidata_A.Ptr indices.Ptr counter.Ptr data_B.Ptr partition.Ptr inserted.Ptr) }
//                    return insert } ) }
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Bulk Remove
///// <summary></summary>
//type PBulkRemove(?plan) =
//    let p =
//        match plan with
//        | Some plan -> plan
//        | None -> defaultPlan BulkRemove
//    
//    member br.BulkRemove() = cuda {
//        let! api = BulkRemove.bulkRemove(p)    
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (data:DArray<'TI>) (indices:DArray<int>) ->
//                let sourceCount = data.Length
//                let api = api sourceCount
//                let indicesCount = indices.Length
//                pcalc {
//                    // @COMMENTS@ : you need prepare paration memory for internal usage
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                    // @COMMENTS@ : you can just add the action, and return the DArray
//                    // the DArray is lazy, you just enqueued action, but not executed
//                    // only when you call removed.Gather(), it will trigger all actions
//                    let! removed = DArray.createInBlob<'TI> worker (sourceCount - indicesCount)
//                    do! PCalc (fun-> apiindicesCount partition.Ptr data.Ptr indices.Ptr removed.Ptr)
//                    return removed } ) }
//
//    // @COMMENTS@ : for benchmark test, we need wrap it with in-place pattern, so it is just different
//    // memory usage, that is also why we need a raw api and then wrap them and separate memory management
//    // so strictly
//    member br.BulkRemoveFunc() = cuda {
//        let! api = BulkRemove.bulkRemove(p)    
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            // for a in-place remover, first we need create it, such as internal partition memories which
//            // could be reused, and for that we need know the source count
//            fun (sourceCount:int) ->
//                let api = api sourceCount 
//                pcalc {
//                    // first, we need create partition memory for internal use
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                    // now we return a function, which is in-place remover
//                    let remove (data:DArray<int>) (indices:DArray<int>) (removed:DArray<int>) =
//                        pcalc { do! PCalc (fun-> apiindices.Length partition.Ptr data.Ptr indices.Ptr removed.Ptr) }
//                    return remove } ) }
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Interval Move
///// <summary></summary>
//type PIntervalMove(?plan) =
//    let p =
//        match plan with
//        | Some plan -> plan
//        | None -> defaultPlan IntervalMove
//
//    // IntervalExpand duplicates intervalCount items in values_global.
//    // indices_global is an intervalCount-sized array filled with the scan of item
//    // expand counts. moveCount is the total number of outputs (sum of expand 
//    // counts).
//
//    // Eg:
//    //		values  =  0,  1,  2,  3,  4,  5,  6,  7,  8
//    //		counts  =  1,  2,  1,  0,  4,  2,  3,  0,  2
//    //		indices =  0,  1,  3,  4,  4,  8, 10, 13, 13 (moveCount = 15).
//    // Expand values[i] by counts[i]:
//    // output  =  0, 1, 1, 2, 4, 4, 4, 4, 5, 5, 6, 6, 6, 8, 8 
//    member iprogram.IntervalExpand() = cuda {
//            let! api = IntervalMove.intervalExpand(p)            
//            return Entry(fun program ->
//                let worker = program.Worker
//                let api = api.Apply m
//                fun (moveCount:int) (indices:DArray<int>) (values:DArray<int>) ->
//                    let intervalCount = indices.Length
//                    let api = api moveCount intervalCount
//                    let itr = [|0..moveCount|]
//                    pcalc {                    
//                        let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                        let! countingItr_global = DArray.scatterInBlob worker itr
//                        let! output = DArray.createInBlob<int> worker moveCount
//                        do! PCalc (fun-> apiindices.Ptr values.Ptr countingItr_global.Ptr partition.Ptr output.Ptr)
//                        return output } ) }
//
//    member iprogram.IntervalExpandFunc() = cuda {
//            let! api = IntervalMove.intervalExpand(p)            
//            return Entry(fun program ->
//                let worker = program.Worker
//                let api = api.Apply m
//                fun (moveCount:int) (intervalCount:int) ->
//                    let itr = [|0..moveCount|]
//                    pcalc {
//                        let api = api moveCount intervalCount
//                        let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                        let! countingItr_global = DArray.scatterInBlob worker itr
//                        let expand (indices:DArray<int>) (values:DArray<int>) (output:DArray<int>) =
//                            pcalc { do! PCalc (fun-> apiindices.Ptr values.Ptr countingItr_global.Ptr partition.Ptr output.Ptr) }
//                        return expand } ) }
//
//    member iprogram.IntervalGather = ()
//    member iprogram.IntervalScatter = ()
//
//    member iprogram.IntervalMove() = cuda {
//        let! api = IntervalMove.intervalMove(p)
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m            
//            fun (total:int) (gather:DArray<int>) (scatter:DArray<int>) (counts:DArray<int>) (input:DArray<int>) ->
//                let numInputs = counts.Length
//                let api = api total numInputs
//                let sequence = Array.init total (fun i -> i)
//                pcalc {                    
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                    let! countingItr = DArray.scatterInBlob worker sequence
//                    let! output = DArray.createInBlob<int> worker total
//                    do! PCalc (fun-> apigather.Ptr scatter.Ptr counts.Ptr input.Ptr countingItr.Ptr partition.Ptr output.Ptr)
//                    return output } ) }
//
//    member iprogram.IntervalMoveFunc() = cuda {
//        let! api = IntervalMove.intervalMove(p)
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m            
//            fun (total:int) (numInputs:int) ->                
//                let api = api total numInputs
//                let sequence = Array.init total (fun i -> i)
//                pcalc {                    
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                    let! countingItr = DArray.scatterInBlob worker sequence
//                    let move (input:DArray<int>) (gather:DArray<int>) (scatter:DArray<int>) (counts:DArray<int>) (output:DArray<int>) = 
//                        pcalc { do! PCalc (fun-> apigather.Ptr scatter.Ptr counts.Ptr input.Ptr countingItr.Ptr partition.Ptr output.Ptr) }
//                    return move } ) }
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Join
///// <summary></summary>
//type PJoin() =
//    member x.x = ()
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Load Balance Search
///// <summary></summary>
//type PLoadBalanceSearch() =
//    member plbs.Search() = cuda {
//        let! api = LoadBalance.loadBalanceSearch()
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (aCount:int) (b_global:DArray<int>) ->
//                let bCount = b_global.Length
//                let api = api aCount bCount
//                let itr = Array.init bCount (fun i -> i)
//                pcalc {
//                    //let! ctaCountingItr = DArray.scatterInBlob worker itr
//                    //let! mpCountingItr = DArray.scatterInBlob worker itr
//                    let! countingItr_global = DArray.scatterInBlob worker itr
//                    let! mp_global = DArray.createInBlob<int> worker api.NumPartitions
//                    let! indices_global = DArray.createInBlob<int> worker aCount                    
//                    do! PCalc (fun-> apib_global.Ptr indices_global.Ptr countingItr_global.Ptr mp_global.Ptr)                     
//                    return indices_global } ) }
//    
//
//    member plbs.SearchFunc() = cuda {
//        let! api = LoadBalance.loadBalanceSearch()
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (aCount:int) (bCount:int) ->
//                let api = api aCount bCount
//                let itr = Array.init aCount (fun i -> i)
//                pcalc {
//                    let! mp_global = DArray.createInBlob<int> worker api.NumPartitions
////                    let! mpCountingItr = DArray.scatterInBlob worker itr
////                    let! ctaCountingItr = DArray.scatterInBlob worker itr
//                    let! countingItr_global = DArray.scatterInBlob worker itr
//                    let search (b_global:DArray<int>) (indices_global:DArray<int>) =
//                        pcalc { do! PCalc (fun-> apib_global.Ptr indices_global.Ptr countingItr_global.Ptr mp_global.Ptr) }
//                    return search } ) }
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Locality Sort
///// <summary></summary>
//type PLocalitySort() =
//    member x.x = ()
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Merge
///// <summary></summary>
//type PMerge() =
//    member program.MergeKeys (compOp:IComp<'TV>) = cuda {
//        let! api = Merge.mergeKeys compOp
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (aCount:int) (bCount:int) -> 
//                let api = api aCount bCount           
//                pcalc {
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                    let merger (aData:DArray<'TV>) (bData:DArray<'TV>) (cData:DArray<'TV>) =
//                        pcalc { do! PCalc (fun-> apiaData.Ptr bData.Ptr partition.Ptr cData.Ptr) }
//                    return merger } ) }
//
//    member program.MergePairs (compOp:IComp<'TV>) = cuda {
//        let! api = Merge.mergePairs compOp
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (aCount:int) (bCount:int) -> 
//                let api = api aCount bCount           
//                pcalc {
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                    let merger (aKeys:DArray<'TV>) (aVals:DArray<'TV>) (bKeys:DArray<'TV>) (bVals:DArray<'TV>) (cKeys:DArray<'TV>) (cVals:DArray<'TV>) =
//                        pcalc { do! PCalc (fun-> apiaKeys.Ptr aVals.Ptr bKeys.Ptr bVals.Ptr partition.Ptr cKeys.Ptr cVals.Ptr) }
//                    return merger } ) }
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Mergesort
///// <summary></summary>
//type PMergesort() =
//    member ms.MergesortKeys() = cuda {
//        let! api = Mergesort.mergesortKeys (comp CompTypeLess 0)
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (source:DArray<int>) ->
//                let api = api source.Length
//                pcalc {
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions                
//                    let! dest = DArray.createInBlob<int> worker source.Length
//                    do! PCalc (fun-> apisource.Ptr dest.Ptr partition.Ptr)
//                    return dest } ) }
//
//    member ms.MergesortKeys(compOp:IComp<'TV>) = cuda {
//        let! api = Mergesort.mergesortKeys compOp
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (source:DArray<'TV>) ->
//                let api = api source.Length
//                pcalc {
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions                
//                    let! dest = DArray.createInBlob<'TV> worker source.Length
//                    do! PCalc (fun-> apisource.Ptr dest.Ptr partition.Ptr)
//                    return dest } ) }
//
//    member ms.MergesortKeysFunc(compOp:IComp<'TV>) = cuda {
//        let! api = Mergesort.mergesortKeys compOp
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (count:int) ->
//                let api = api count
//                pcalc {
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions                
//                    let merger (source:DArray<'TV>) (dest:DArray<'TV>) = 
//                        pcalc { do! PCalc (fun-> apisource.Ptr dest.Ptr partition.Ptr) }
//                    return merger } ) }
//
//    member ms.MergesortPairs(keyType:intV) = cuda {
//        let! api = Mergesort.mergesortPairs (comp CompTypeLess keyType)
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (keysSource:DArray<'TV>) (valsSource:DArray<'TV>) ->
//                let count = keysSource.Length
//                let api = api count
//                pcalc {
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions                
//                    let! keysDest = DArray.createInBlob<'TV> worker count
//                    let! valsDest = DArray.createInBlob<'TV> worker count
//                    do! PCalc (fun-> apikeysSource.Ptr valsSource.Ptr keysDest.Ptr valsDest.Ptr partition.Ptr)
//                    let! sortedKeys = keysDest.Gather()
//                    let! sortedVals = valsDest.Gather()
//                    return sortedKeys, sortedVals } ) }
//
//    member ms.MergesortPairs(compOp:IComp<'TV>) = cuda {
//        let! api = Mergesort.mergesortPairs compOp
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (keysSource:DArray<'TV>) (valsSource:DArray<'TV>) ->
//                let count = keysSource.Length
//                let api = api count
//                pcalc {
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions                
//                    let! keysDest = DArray.createInBlob<'TV> worker count
//                    let! valsDest = DArray.createInBlob<'TV> worker count
//                    do! PCalc (fun-> apikeysSource.Ptr valsSource.Ptr keysDest.Ptr valsDest.Ptr partition.Ptr)
//                    return keysDest, valsDest } ) }
//
//    member ms.MergesortPairsFunc(compOp:IComp<'TV>) = cuda {
//        let! api = Mergesort.mergesortPairs compOp
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (count:int) ->
//                let api = api count
//                pcalc {
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions                
//                    let merger (keysSource:DArray<'TV>) (valsSource:DArray<'TV>) (keysDest:DArray<'TV>) (valsDest:DArray<'TV>) = 
//                        pcalc { do! PCalc (fun-> apikeysSource.Ptr valsSource.Ptr keysDest.Ptr valsDest.Ptr partition.Ptr) }
//                    return merger } ) }
//
//    member ms.MergesortIndices() = cuda {
//        let! api = Mergesort.mergesortIndices (comp CompTypeLess 0)
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (keysSource:DArray<int>) (valsSource:DArray<int>) ->
//                let count = keysSource.Length
//                let api = api count
//                let sequence = Array.init count (fun i -> i)
//                pcalc {
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                    let! countingItr = DArray.scatterInBlob worker sequence
//                    let! keysDest = DArray.createInBlob<int> worker count
//                    let! valsDest = DArray.createInBlob<int> worker count
//                    do! PCalc (fun-> apikeysSource.Ptr countingItr.Ptr valsSource.Ptr keysDest.Ptr valsDest.Ptr partition.Ptr)
//                    return keysDest, valsDest } ) }
//
//    member ms.MergesortIndices(compOp:IComp<int>) = cuda {
//        let! api = Mergesort.mergesortIndices compOp
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (keysSource:DArray<int>) (valsSource:DArray<int>) ->
//                let count = keysSource.Length
//                let api = api count
//                let sequence = Array.init count (fun i -> i)
//                pcalc {
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                    let! countingItr = DArray.scatterInBlob worker sequence
//                    let! keysDest = DArray.createInBlob<int> worker count
//                    let! valsDest = DArray.createInBlob<int> worker count
//                    do! PCalc (fun-> apikeysSource.Ptr countingItr.Ptr valsSource.Ptr keysDest.Ptr valsDest.Ptr partition.Ptr)
//                    return keysDest, valsDest } ) }
//
//    member ms.MergesortIndicesFunc(compOp:IComp<int>) = cuda {
//        let! api = Mergesort.mergesortIndices compOp
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (count:int) ->
//                let api = api count
//                let sequence = Array.init count (fun i -> i)
//                pcalc {
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                    let! countingItr = DArray.scatterInBlob worker sequence
//                    let merger (keysSource:DArray<int>) (valsSource:DArray<int>) (keysDest:DArray<int>) (valsDest:DArray<int>) = 
//                        pcalc { do! PCalc (fun-> apikeysSource.Ptr countingItr.Ptr valsSource.Ptr keysDest.Ptr valsDest.Ptr partition.Ptr) }
//                    return merger } ) }
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Reduce
///// <summary></summary>
//type PReduce() =
//    member r.Reduce(op:IScanOp<'TI, 'TV, 'TR>) = cuda {
//        let! api = Reduce.reduce op
//
//        return Entry(fun program ->
//        
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (data:DArray<'TI>) ->
//                pcalc {
//                    let count = data.Length
//                    let api = api count
//                    let! reduction = DArray.createInBlob worker api.NumBlocks
//                    do! PCalc (fun-> apidata.Ptr reduction.Ptr)
//                    let result =
//                        fun () ->
//                            pcalc {
//                                let! reduction = reduction.Gather()
//                                return api.Result reduction }
//                        |> Lazy.Create
//                    return result} ) }
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Scan
///// <summary></summary>
//type PScan() =
//    member ps.Scan(mgpuScanType:int, op:IScanOp<'TI, 'TV, 'TR>, totalAtEnd:int) = cuda {
//        let! api = Scan.scan mgpuScanType op totalAtEnd
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (data:DArray<'TI>) ->
//                let count = data.Length
//                let api = api count
//                pcalc {
//                    let! scanned = DArray.createInBlob worker count
//                    let! total = DArray.createInBlob worker 1
//                    let! reductionDevice = DArray.createInBlob worker (api.NumBlocks + 1)                    
//                    do! PCalc (fun-> apidata.Ptr total.Ptr reductionDevice.Ptr scanned.Ptr)
//                    return total, scanned } ) }
//
//    member ps.Scan(mgpuScanType:int, op:IScanOp<'TI, 'TV, 'TR>) = cuda {
//        let! api = Scan.scan mgpuScanType op 0
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (data:DArray<'TI>) ->
//                let count = data.Length
//                let api = api count
//                pcalc {
//                    let! scanned = DArray.createInBlob worker count
//                    let! total = DArray.createInBlob worker 1
//                    let! reductionDevice = DArray.createInBlob worker (api.NumBlocks + 1)                    
//                    do! PCalc (fun-> apidata.Ptr total.Ptr reductionDevice.Ptr scanned.Ptr)
//                    return total, scanned } ) }
//
//    member ps.Scan() = cuda {
//        let! api = Scan.scan ExclusiveScan (scanOp ScanOpTypeAdd 0) 0
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (data:DArray<int>) ->
//                let count = data.Length
//                let api = api count
//                pcalc {
//                    //let! scanned = DArray.createInBlob worker count
//                    let! total = DArray.createInBlob worker 1
//                    let! reductionDevice = DArray.createInBlob worker (api.NumBlocks + 1)
//                    do! PCalc (fun-> apidata.Ptr total.Ptr reductionDevice.Ptr data.Ptr)
//                    let! scanned = data.Gather()
//                    let! total = total.Gather()
//                    return total.[0], scanned } ) }
//
//    member ps.Scan(op:IScanOp<'TI,'TV,'TR>) = ps.Scan(ExclusiveScan, op)       
//
//    member ps.ScanFunc(mgpuScanType:int, op:IScanOp<'TI, 'TV, 'TR>, totalAtEnd:int) = cuda {
//        let! api = Scan.scan mgpuScanType op totalAtEnd
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (numElements:int) ->
//                let api = api numElements
//                pcalc {
//                    let! reductionDevice = DArray.createInBlob worker (api.NumBlocks + 1)                    
//                    let scanner (data:DArray<'TI>) (scanned:DArray<'TR>) (total:DArray<'TV>) =
//                        pcalc { do! PCalc (fun-> apidata.Ptr total.Ptr reductionDevice.Ptr scanned.Ptr)}
//                    return scanner } ) }
//                    
//    member ps.ScanFunc(op:IScanOp<'TI, 'TV, 'TR>) = ps.ScanFunc(ExclusiveScan, op, 0)    
//
//    member ps.ScanFuncReturnTotal(op:IScanOp<'TI, 'TV, 'TR>) = cuda {
//        let! api = Scan.scan ExclusiveScan op 0
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (numElements:int) ->
//                let api = api numElements
//                pcalc {
//                    let! total = DArray.createInBlob worker 1
//                    let! reductionDevice = DArray.createInBlob worker (api.NumBlocks + 1)                    
//                    let scanner (data:DArray<'TI>) (scanned:DArray<'TR>) =
//                        pcalc { 
//                                do! PCalc (fun-> apidata.Ptr total.Ptr reductionDevice.Ptr scanned.Ptr)
//                                let! total = total.Gather()
//                                return total.[0] }                        
//                    return scanner } ) }
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Search
///// <summary></summary>
//type PSearch() =
//    member s.BinarySearchPartitions(bounds:int, compOp:IComp<int>) = cuda {
//        let! api = Search.binarySearchPartitions bounds compOp
//
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//        
//            fun (count:int) (data_global:DArray<int>) (numItems:int) (nv:int) ->
//                pcalc {                
//                    let api = api count numItems nv
//                    let n = ((divup count nv) + 1)
//                    let! partData = DArray.createInBlob<int> worker n
//                    do! PCalc (fun-> apidata_global.Ptr partData.Ptr)
//                                    
//                    let result =
//                        fun () ->
//                            pcalc { 
//                                let! parts = partData.Gather()
//                                return parts }
//                        |> Lazy.Create
//                    return result} ) }
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Segmented Sort
///// <summary></summary>
//type PSegmentedSort() =
//    member x.x = ()
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Sets
///// <summary></summary>
//type PSets() =
//    member x.x = ()
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////// Sorted Search
///// <summary></summary>
//type PSortedSearch() =
//    member pss.SortedSearch(bounds:int, typeA:MgpuSearchType, typeB:MgpuSearchType, compOp:IComp<'TI>) = cuda {
//        let! api = SortedSearch.sortedSearch bounds typeA typeB compOp
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (aCount:int) (bCount:int) ->                
//                pcalc {
//                    let api = api aCount bCount
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                    let sortedSearch (aData:DArray<'TI>) (bData:DArray<'TI>) (aIndices:DArray<int>) (bIndices:DArray<int>) = 
//                        pcalc { do! PCalc (fun-> apiaData.Ptr bData.Ptr partition.Ptr aIndices.Ptr bIndices.Ptr) }
//                    return sortedSearch } ) }  
//
//    member pss.SortedSearch(bounds:int, compOp:IComp<'TI>) = cuda {
//        let! api = SortedSearch.sortedSearch bounds MgpuSearchTypeIndex MgpuSearchTypeNone compOp
//        return Entry(fun program ->
//            let worker = program.Worker
//            let api = api.Apply m
//            fun (aCount:int) (bCount:int) ->                
//                pcalc {
//                    let api = api aCount bCount
//                    let! partition = DArray.createInBlob<int> worker api.NumPartitions
//                    let sortedSearch (aData:DArray<'TI>) (bData:DArray<'TI>) (aIndices:DArray<int>) = 
//                        pcalc { do! PCalc (fun-> apiaData.Ptr bData.Ptr partition.Ptr aIndices.Ptr (deviceptr<int>(0n)) ) }
//                    return sortedSearch } ) } 
//                     
//    member pss.SortedSearch(bounds:int, ident:intI) = pss.SortedSearch(bounds, (comp CompTypeLess ident))
//

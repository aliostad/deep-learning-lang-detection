namespace FsOSBd.Core

module ReportStory = 
    open Story
    open RR
    
    let CallApi(story : Story<ChapterReportHash>) = OSDbApi.ReportWrongMovieHash story.Token (string story.Chapter.IDSubMovieFile) |> Success
    
    let OnceUponATime(story : Story<ChapterReportHash>) = 
        ValidationManager.Common.AssertCredentials ReportValidate.InvalidCredentials story
        >>= ValidationManager.Common.AssertLogin ReportValidate.LogingFailed
        >>= CallApi
        >>= ReportValidate.AssertReportComplete story

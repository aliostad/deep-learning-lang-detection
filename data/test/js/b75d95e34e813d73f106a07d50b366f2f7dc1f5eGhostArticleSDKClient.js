class GhostArticleSDKClient {

    /**
     * @param {NewsApiIngestService} newsApiIngestService
     * @param {AFINNModelService} AFINNModelService
     * @param {ArticleParsingService} parsingService
     * @param {ArticleSummaryService} summaryService
     */
    constructor (newsApiIngestService, AFINNModelService, parsingService, summaryService) {
        this.IngestService = newsApiIngestService;
        this.AFINNModelService = AFINNModelService;
        this.ParsingService = parsingService;
        this.SummaryService = summaryService;
    }


}

module.exports = GhostArticleSDKClient;
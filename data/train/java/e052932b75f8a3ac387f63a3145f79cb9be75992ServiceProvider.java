package se.blinfo.newsservice.core.service;

/**
 *
 * @author jep
 */
public interface ServiceProvider {

    ArticleService getArticleService();

    CrossReferenceListService getCrossReferenceListService();

    UserService getUserService();

    TagService getTagService();

    LabelingService getLabelingService();

    NumericElementService getNumericElementService();

    ArticleNotationService getArticleNotationService();

    StockQuoteService getStockQuoteService();

    ExchangeRateService getExchangeRateService();

    AllowanceAbroadService getAllowanceAbroadService();

    EventService getEventService();

    BasicDeductionService getBasicDeductionService();

    ArticleReaderStatsService getArticleReaderStatsService();

    PublicationService getPublicationService();

    KortnyttUserService getKortnyttUserService();

    AccomodationalBenefitService getAccomodationalBenefitService();

    AnimalHusbandryCostAndValueService getAnimalHusbandryCostAndValueService();

    SourceReferenceService getSourceReferenceService();
    
    TaxDeductionOnLumpSumService getTaxDeductionOnLumpSumService();
}

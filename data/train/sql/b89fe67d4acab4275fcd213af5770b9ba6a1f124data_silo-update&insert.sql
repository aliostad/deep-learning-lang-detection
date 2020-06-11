insert into main_datasilo(id, text, brand_model, cleandata_model, aggregate_function, brand_name_field, cleandata_brand_field, crawl_queuer, single_company) values('flipkey',  'FlipKey',  null, 'FlipKeyCleanData', null, null, null, 'crawler.crawlers.flipkey.crawl_queuer.FlipKeyCrawlQueuer', true);
insert into main_datasilo(id, text, brand_model, cleandata_model, aggregate_function, brand_name_field, cleandata_brand_field, crawl_queuer, single_company) values('homeaway',  'HomeAway',  null, 'HomeAwayCleanData', null, null, null, 'crawler.crawlers.homeaway.crawl_queuer.HomeAwayCrawlQueuer', true);

update main_datasilo set brand_model = 'EbayBrand', cleandata_model = 'EbayBrandData' where id = 'ebay';
update main_datasilo set brand_model = 'FacebookBrand', cleandata_model = 'FacebookCleanData' where id = 'facebook';
update main_datasilo set brand_model = 'ItunesAppDeveloper', cleandata_model = 'ItunesCleanData' where id = 'itunes';
update main_datasilo set brand_model = 'GoogleTrendsBrand', cleandata_model = 'GoogleTrendsBrandData' where id = 'googletrends';
update main_datasilo set brand_model = 'TwitterBrand', cleandata_model = 'TwitterCleanData' where id = 'twitter';
update main_datasilo set brand_model = 'Brand', cleandata_model = 'AmazonBrandAggregate' where id = 'amazon';
update main_datasilo set brand_model = 'GooglePlayAppDeveloper', cleandata_model = 'GooglePlayCleanData' where id = 'googleplay';


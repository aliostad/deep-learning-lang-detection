angular.module('FeedSubscriptionsServiceModule', ['LocalStorageServiceModule', 'SubscriptionsEntriesServiceModule'])
    .factory('FeedSubscriptionsService', ['LocalStorageService', 'SubscriptionsEntriesService',
        function(LocalStorageService, SubscriptionsEntriesService) {
            return {
                subscriptionsList: LocalStorageService.getAll(),
                hasFeeds: function() {
                    return this.subscriptionsList.length > 0;
                },
                addFeed: function(feed) {
                    this.subscriptionsList = LocalStorageService.add(feed);
                    SubscriptionsEntriesService.appendSubscriptions();
                },
                removeFeed: function(feed) {
                    this.subscriptionsList = LocalStorageService.remove(feed);
                    SubscriptionsEntriesService.appendSubscriptions();
                }
            };
        }
    ]);

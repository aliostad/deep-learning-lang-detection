using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MvcLibrary.Bootstrapper;
using T3ME.Business.BackgroundTasks;
using T3ME.Domain.Repositories;

namespace T3ME.Business.StartUp
{
    public class StartBackgroundTasks : IBootstrapperTask
    {
        protected readonly IApplicationRepository ApplicationRepository = null;
        protected readonly ITweetRepository TweetRepository = null;
        protected readonly ITweeterRepository TweeterRepository = null;
        protected readonly ILanguageRepository LanguageRepository = null;

        public StartBackgroundTasks(IApplicationRepository applicationRepository, ITweetRepository tweetRepository,
            ITweeterRepository tweeterRepository, ILanguageRepository languageRepository)
        {
            this.ApplicationRepository = applicationRepository;
            this.TweetRepository = tweetRepository;
            this.TweeterRepository = tweeterRepository;
            this.LanguageRepository = languageRepository;
        }

        public void Execute()
        {
            TrawlTweets trawler = TrawlTweets.Instance();
            trawler.ApplicationRepository = ApplicationRepository;
            trawler.TweetRepository = TweetRepository;
            trawler.TweeterRepository = TweeterRepository;
            trawler.LanguageRepository = LanguageRepository;

            trawler.Start();
        }
    }
}
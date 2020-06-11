import CacheService from './cacheService';
import GoogleSheetsService from './googleSheetsService';
import JiraService from './jiraService';
import NewRelicService from './newRelicService';
import TriviaService from './triviaService';
import GoogleFinanceService from './googleFinanceService';
import WeatherService from './weatherService';
import StatusCakeService from './statusCakeService';
import TwitterService from './twitterService';
import GithubService from './githubService';
import InstagramService from './instagramService';
import config from '../config';

const googleSheetsService = new GoogleSheetsService(config.google);
const cacheService = new CacheService(config.cache);
const jiraService = new JiraService(config.jira);
const newRelicService = new NewRelicService(config.newRelic);
const triviaService = new TriviaService(config.trivia);
const googleFinanceService = new GoogleFinanceService(config.finance);
const weatherService = new WeatherService(config.weather);
const statusCakeService = new StatusCakeService(config.statusCake);
const twitterService = new TwitterService(config.twitter);
const githubService = new GithubService(config.github);
const instagramService = new InstagramService(config.instagram);

export {
  cacheService,
  googleSheetsService,
  jiraService,
  newRelicService,
  triviaService,
  googleFinanceService,
  weatherService,
  statusCakeService,
  twitterService,
  githubService,
  instagramService,
};

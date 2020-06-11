package service.impl;

import model.Favorites;
import model.Retwit;
import model.Twit;
import model.Users;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.AnswerRepository;
import repository.FavoritesRepository;
import repository.RetwitRepository;
import repository.TwitRepository;
import service.TwitService;

import java.util.List;

@Service
public class TwitServiceImpl implements TwitService {
    private TwitRepository twitRepository;
    private AnswerRepository answerRepository;
    private FavoritesRepository favoritesRepository;
    private RetwitRepository retwitRepository;

    @Autowired
    public TwitServiceImpl(TwitRepository twitRepository, AnswerRepository answerRepository, FavoritesRepository favoritesRepository,
                           RetwitRepository retwitRepository) {
        this.twitRepository = twitRepository;
        this.answerRepository=answerRepository;
        this.favoritesRepository=favoritesRepository;
        this.retwitRepository=retwitRepository;
    }

    public Iterable<Twit> getAllTwits () {
//        return twitRepository.findAll();
        return twitRepository.findAllOrderByDate();
    }

    @Override
    public void saveTwit(Twit twit) {
        twitRepository.save(twit);
    }

    @Override
    public Twit findOne(Long id) {
        Twit twit = twitRepository.findOne(id);
        twit.setAnswer(answerRepository.findAllByTwit(twit));
        return twit;
    }

    @Override
    public Long getTwitsCount(Users user) {
        return twitRepository.getTwitCount(user);
    }

    @Override
    public void saveFav(Favorites favorites) {
       favoritesRepository.save(favorites);
    }

    @Override
    public void saveRetwit(Retwit retwit) {
       retwitRepository.save(retwit);
    }

    @Override
    public Long findFavoritesCount(Long twitId) {
        Twit twit = twitRepository.findOne(twitId);
        return favoritesRepository.findFavoritesCount(twit);
    }

    @Override
    public List<Users> findAllFavotitesAuthors(Long twitId) {
        Twit twit = twitRepository.findOne(twitId);
        return favoritesRepository.findAllFavotitesAuthors(twit);
    }

    @Override
    public List<Users> findAllRetwitsAuthors(Long twitId) {
        Twit twit = twitRepository.findOne(twitId);
        return retwitRepository.findAllRetwitsAuthors(twit);
    }

    @Override
    public Long findRetwitsCount(Long twitId) {
        Twit twit = twitRepository.findOne(twitId);
        return retwitRepository.findRetwitsCount(twit);
    }
}

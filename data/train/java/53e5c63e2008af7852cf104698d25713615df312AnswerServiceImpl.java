package service.impl;

import model.Answer;
import model.Twit;
import model.Users;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.AnswerRepository;
import repository.TwitRepository;
import repository.UsersRepository;
import service.AnswerService;

@Service
public class AnswerServiceImpl implements AnswerService {
    private AnswerRepository answerRepository;
    private UsersRepository usersRepository;
    private TwitRepository twitRepository;

    @Autowired
    public AnswerServiceImpl(AnswerRepository answerRepository, UsersRepository usersRepository, TwitRepository twitRepository) {
        this.answerRepository = answerRepository;
        this.usersRepository = usersRepository;
        this.twitRepository = twitRepository;
    }

    @Override
    public void saveAnswer(Answer answer, Long twitId ) {
        Users user = usersRepository.findOne("alerion94");
        Twit twit = twitRepository.findOne(twitId);
        answer.setAuthor(user);
        answer.setTwitId(twit);
        answerRepository.save(answer);
    }
}

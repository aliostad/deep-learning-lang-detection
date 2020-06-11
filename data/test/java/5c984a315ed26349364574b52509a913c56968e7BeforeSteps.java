package com.andycaine.example.steps;

import com.andycaine.example.GameCategoryRepository;
import com.andycaine.example.GameRepository;
import com.andycaine.example.MemberRepository;
import cucumber.annotation.Before;
import org.springframework.beans.factory.annotation.Autowired;

public class BeforeSteps {

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private GameRepository gameRepository;

    @Autowired
    private GameCategoryRepository gameCategoryRepository;

    @Before
    public void beforeScenario() {
        memberRepository.deleteAll();
        gameRepository.deleteAll();
        gameCategoryRepository.deleteAll();
    }
}

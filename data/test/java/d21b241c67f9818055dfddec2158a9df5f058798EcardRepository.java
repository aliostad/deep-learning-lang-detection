package com.legaldaily.estension.ecard.repository;

import com.fzw.Globals;

public interface EcardRepository {
	public static final UserRepository userRepository = (UserRepository) Globals.getBean("userRepository");
	public static final AnswerRepository answerRepository = (AnswerRepository) Globals.getBean("answerRepository");
	public static final QuestionRepository questionRepository = (QuestionRepository) Globals.getBean("questionRepository");
	public static final AreaRepository areaRepository = (AreaRepository) Globals.getBean("areaRepository");
	public static final PostRepository postRepository = (PostRepository) Globals.getBean("postRepository");
	public static final LawRepository lawRepository = (LawRepository) Globals.getBean("lawRepository");
	public static final SideRepository sideRepository = (SideRepository) Globals.getBean("sideRepository");

}

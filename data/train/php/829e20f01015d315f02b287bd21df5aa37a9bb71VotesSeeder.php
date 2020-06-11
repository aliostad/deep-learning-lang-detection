<?php

use Illuminate\Database\Seeder;
use App\Repositories\Contracts\UserRepository;
use App\Repositories\Contracts\QuestionRepository;
use App\Repositories\Contracts\AnswerRepository;
use App\Repositories\Contracts\VoteRepository;
use Faker\Factory;

class VotesSeeder extends Seeder
{
    private $userRepository;
    private $questionRepository;
    private $answerRepository;
    private $voteRepository;

    public function __construct(
        UserRepository $userRepository,
        QuestionRepository $questionRepository,
        AnswerRepository $answerRepository,
        VoteRepository $voteRepository
    ) {
        $this->userRepository = $userRepository;
        $this->questionRepository = $questionRepository;
        $this->answerRepository = $answerRepository;
        $this->voteRepository = $voteRepository;
    }

    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $users = $this->userRepository->all();
        $questions = $this->questionRepository->all();
        $answers = $this->answerRepository->all();
        $likeable = $questions->merge($answers);

        foreach ($users as $user) {
            $usersLikeable = $likeable->shuffle();

            for ($i = 0; $i < 70; $i++) {
                $this->voteRepository->create([
                    'sign' => rand(0,1),
                    'user_id' => $user->id,
                    'q_and_a_id' => $usersLikeable->pop()->id
                ]);
            }
        }
    }
}

<?php  namespace Giraffe\Comments; 

use Eloquent;
use Giraffe\Users\UserModel;

class CommentStreamModel extends Eloquent
{
    protected $table = "comment_streams";
    protected $fillable = ['commentable_type', 'commentable_id'];

    public function getComments($options = [])
    {
        /** @var CommentRepository $commentRepository */
        $commentRepository = \App::make(CommentRepository::class);

        return $commentRepository->getFor($this, $options);
    }

    public function getCommentCount()
    {
        /** @var CommentRepository $commentRepository */
        $commentRepository = \App::make(CommentRepository::class);

        return $commentRepository->countFor($this);

    }

    public function getParticipatingUsers()
    {
        /** @var CommentRepository $commentRepository */
        $commentRepository = \App::make(CommentRepository::class);

        $users = $commentRepository->getUsersFor($this);
        return $users;
    }

    public function postComment($body, UserModel $user)
    {
        /** @var CommentRepository $commentRepository */
        $commentRepository = \App::make(CommentRepository::class);

        $comment = CommentModel::write($this, $user, $body);
        $commentRepository->save($comment);
        return $comment;
    }

    public static function generate(Commentable $commentable)
    {
        $instance = new static;
        $instance->commentable_type = get_class($commentable);
        $instance->commentable_id = $commentable->getKey();
        return $instance;
    }
}
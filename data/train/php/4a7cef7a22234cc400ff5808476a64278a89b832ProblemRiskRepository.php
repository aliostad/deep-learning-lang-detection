<?php

namespace Bundle\MainBundle\Repository;

use Bundle\MainBundle\Repository\CommentRepository;

/**
 * ProblemRiskRepository
 */
class ProblemRiskRepository extends BaseRepository
{
    /**
     * Установить комментярии для рисков
     * @param $risks
     * @return mixed
     */
    public function getCommentsForRisks($risks)
    {
        if ($risks) {
            /** @var CommentRepository $commentRepository */
            $commentRepository = $this->getRepository('comment');
            foreach ($risks as $risk) {
                $comments = $commentRepository->getComments($risk->getId(), $risk->getEntityType());
                $risk->setComments($comments);
            }
        }

        return $risks;
    }
}

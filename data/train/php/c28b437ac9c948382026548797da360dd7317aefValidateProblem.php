<?php

/**
 * Created by PhpStorm.
 * User: Sameque
 * Date: 13/09/2015
 * Time: 17:06
 */

namespace App\Libraries\CrawlerRepository;


class ValidateProblem
{
    public function validate($repository_id, $problem)
    {
        $validator = null;
        if ($repository_id == 'spoj') {
            $repository = new ValidateProblemSpoj();
        } elseif ($repository_id == 'uri') {
            $repository = new ValidateProblemUri();
        } elseif ($repository_id == 'uva') {
            $repository = new ValidateProblemUva();
        } else $repository = null;

        if (!empty($repository)) {
            return $repository->validationProblem($problem);
        } else
            return false;
    }
}
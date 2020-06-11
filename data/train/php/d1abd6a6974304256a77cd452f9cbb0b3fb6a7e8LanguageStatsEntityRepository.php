<?php

namespace org\dokuwiki\translatorBundle\Entity;

use Doctrine\ORM\EntityRepository;

class LanguageStatsEntityRepository extends EntityRepository {

    public function clearStats(RepositoryEntity $repository) {
        $query = $this->getEntityManager()->createQuery('
            DELETE FROM dokuwikiTranslatorBundle:LanguageStatsEntity langStats
            WHERE langStats.repository = :repository
        ');
        $query->setParameter('repository', $repository);
        $query->execute();
    }
}

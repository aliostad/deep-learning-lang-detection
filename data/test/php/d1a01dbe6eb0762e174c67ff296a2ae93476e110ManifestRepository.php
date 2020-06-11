<?php

namespace AppBundle\Entity;

use Doctrine\ORM\EntityRepository;

class ManifestRepository extends EntityRepository
{
    public function findOneByReference(Repository $repository, $reference)
    {
        $qb = $this->createQueryBuilder('m')
            ->where('m.repository = :repository')
            ->andWhere('(m.digest = :reference OR m.tag = :reference)')
            ->setParameters([
                'repository' => $repository,
                'reference' => $reference,
            ])
        ;

        return $qb->getQuery()->getOneOrNullResult();
    }

    public function findOneByReferenceOrCreate(Repository $repository, $reference)
    {
        $manifest = $this->findOneByReference($repository, $reference);
        if (null === $manifest) {
            $manifest = $this->create($repository);
        }

        return $manifest;
    }

    public function create(Repository $repository)
    {
        return new Manifest($repository);
    }

    public function save(Manifest $manifest)
    {
        $this->_em->persist($manifest);
        $this->_em->flush();
    }

    public function incrementPulls(Manifest $manifest)
    {
        // Increment Manifest
        $this->_em
            ->createQuery(<<<DQL
UPDATE AppBundle:Manifest m
SET m.pulls = m.pulls + 1
WHERE m.id = :manifest
DQL
            )
            ->setParameter('manifest', $manifest->getId())
            ->execute()
        ;

        // Increment Repository
        $this->_em
            ->createQuery(<<<DQL
UPDATE AppBundle:Repository r
SET r.pulls = r.pulls + 1
WHERE r.id = :repository
DQL
        )
            ->setParameter('repository', $manifest->getRepository()->getId())
            ->execute()
        ;
    }
}

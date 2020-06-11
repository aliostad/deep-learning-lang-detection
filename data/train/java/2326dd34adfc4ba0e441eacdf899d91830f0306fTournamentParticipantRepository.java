package com.bazzingart.repository;

import com.bazzingart.domain.TournamentParticipant;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.roo.addon.layers.repository.mongo.RooMongoRepository;
import org.springframework.stereotype.Repository;

import java.math.BigInteger;
import java.util.List;


@Repository
public interface TournamentParticipantRepository extends PagingAndSortingRepository<TournamentParticipant, BigInteger> {

    List<TournamentParticipant> findAll();
}

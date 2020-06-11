package com.ua.kh.champmanager.manager;

import com.ua.kh.champmanager.dal.CompetitorRepository;
import com.ua.kh.champmanager.dal.ResultRepository;
import com.ua.kh.champmanager.domain.Championship;

public class ResultManager {

    private ResultRepository resultRepository;
    private CompetitorRepository competitorRepository;

    public ResultManager (ResultRepository resultRepository, CompetitorRepository competitorRepository) {
        this.resultRepository = resultRepository;
        this.competitorRepository =competitorRepository;
    }

    public ResultTable getChampionshipResults(Championship championship) {
        ResultTable resultTable = new ResultTable(competitorRepository.getChampionshipCompetitors(championship));
        resultTable.fillResults(resultRepository);

        return resultTable;
    }
}

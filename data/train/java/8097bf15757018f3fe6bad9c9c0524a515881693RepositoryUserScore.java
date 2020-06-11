package org.bgcokehack.github_recommender.model;

public class RepositoryUserScore implements Comparable<RepositoryUserScore> {
    private Repository repository;
    private float score;

    public RepositoryUserScore(final Repository repository, final float overlap) {
        this.repository = repository;
        this.score = overlap;
    }

    @Override
    public int compareTo(final RepositoryUserScore o) {
        return Float.compare(this.getScore(), o.getScore());
    }

    public float getScore() {
        return score;
    }

    public Repository getRepository() {
        return repository;
    }

}

package br.com.elo7.probe.repository;

/**
 * The type Plateau repository.
 *
 * @author Felipe Adorno (felipeadsc@gmail.com)
 */
public class PlateauRepository {

    private static PlateauRepository plateauRepository = null;
    private Integer vertical;
    private Integer horizontal;

    private PlateauRepository() {
        //not to do
    }

    public static PlateauRepository newInstance(Integer vertical, Integer horizontal) {

        if(plateauRepository == null) {
            plateauRepository = new PlateauRepository();
        }

        plateauRepository.horizontal = horizontal;
        plateauRepository.vertical = vertical;

        return plateauRepository;
    }

    public static PlateauRepository getInstance() {
        if(plateauRepository == null) {
            throw new IllegalStateException("Use the method newInstance after user getInstance");
        }
        return plateauRepository;
    }

    public Integer getVertical() {
        return vertical;
    }

    public Integer getHorizontal() {
        return horizontal;
    }
}

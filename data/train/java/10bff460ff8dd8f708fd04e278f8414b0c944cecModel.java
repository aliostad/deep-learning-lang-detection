package model;

import camera.Camera;
import model.handlers.*;
import model.renderers.ShapeRenderer;

public class Model {
    // Variables for creating the playing field
    private static final int TILE_SIZE = 10;
    private static final int NUM_TILES_IN_ONE_DIRECTION = 25;
    public static final int MIN_MAP_COORDINATE = -TILE_SIZE * NUM_TILES_IN_ONE_DIRECTION;
    public static final int MAX_MAP_COORDINATE = TILE_SIZE * NUM_TILES_IN_ONE_DIRECTION;
    public static final boolean DRAW_MINI_MAP = true;

    private Camera camera;
    private ScoreHandler scoreHandler;
    private PlayerHandler playerHandler;
    private EnemyHandler enemyHandler;
    private ObstacleHandler obstacleHandler;
    private ShotsHandler shotsHandler;
    private HudHandler hudHandler;

    // Use slick library - IMPORTANT: Have to be initialized AFTER InitGL()
    private TextureHandler textureHandler;
    private SoundHandler soundHandler;

    public Model(Camera camera, int mapNumber, int difficulty) {
        this.camera = camera;
        scoreHandler = new ScoreHandler();
        textureHandler = new TextureHandler();
        soundHandler = new SoundHandler();
        enemyHandler = new EnemyHandler(scoreHandler, textureHandler, soundHandler);
        playerHandler = new PlayerHandler(camera, enemyHandler, soundHandler);
        obstacleHandler = new ObstacleHandler(textureHandler, mapNumber);
        shotsHandler = new ShotsHandler(obstacleHandler, enemyHandler, textureHandler, soundHandler);
        hudHandler = new HudHandler(scoreHandler, shotsHandler, enemyHandler, playerHandler, textureHandler);

        soundHandler.getBackgroundAudio().playAsMusic(1.0f, 1.0f, true);
    }

    public void resetGame(int difficulty) {
        // TODO: Reset game with new difficulty
    }

    public void update() {
        playerHandler.checkForCollisions();
        playerHandler.drawPlayer();
        shotsHandler.updateShots();
        enemyHandler.updateEnemies(camera);
    }

    public void drawMap() {
        ShapeRenderer.drawFloorTiles(TILE_SIZE, NUM_TILES_IN_ONE_DIRECTION,
                textureHandler.getTexture(TextureHandler.STONE_1), textureHandler.getTexture(TextureHandler.STONE_2));
        ShapeRenderer.drawWalls(500.0, 100.0, Colors.BLUE, textureHandler.getTexture(TextureHandler.STONE_4));

        obstacleHandler.drawObstacles();
        playerHandler.drawPlayer();
        enemyHandler.drawEnemies();
        shotsHandler.drawShots();
    }

    public void drawHud() {
        hudHandler.drawHud();
        if(DRAW_MINI_MAP) {
            ShapeRenderer.drawFloorTiles(TILE_SIZE, NUM_TILES_IN_ONE_DIRECTION,
                    textureHandler.getTexture(TextureHandler.STONE_1), textureHandler.getTexture(TextureHandler.STONE_2));
            ShapeRenderer.drawWalls(500.0, 100.0, Colors.BLUE, textureHandler.getTexture(TextureHandler.STONE_4));
            playerHandler.drawPlayer();
            obstacleHandler.drawObstacles();
            enemyHandler.drawEnemies();
            shotsHandler.drawShots();
            hudHandler.finishDrawingHud();
        }
    }

    public void addShot() {
        shotsHandler.addShot(camera);
    }

    public PlayerHandler getPlayerHandler() {
        return playerHandler;
    }
}

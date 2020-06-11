package lando.systems.ld34.world;

import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.g2d.GlyphLayout;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.math.Rectangle;
import com.badlogic.gdx.utils.ObjectMap;
import lando.systems.ld34.screens.GameScreen;
import lando.systems.ld34.utils.Assets;

/**
 * Brian Ploeckelman created on 12/12/2015.
 */
public class AreaMgmt extends Area {

    GlyphLayout                    glyphLayout;
    public static Rectangle        bounds;
    ObjectMap<Manage.Type, Manage> manageMap;
    Manage                         currentManage;

    public AreaMgmt(GameScreen gameScreen) {
        super(gameScreen, Type.MGMT);
        worldX = 3;
        glyphLayout = new GlyphLayout(Assets.font, "Management Area");

        float w = gameScreen.uiCamera.viewportWidth / 2f;
        float h = gameScreen.uiCamera.viewportHeight - gameScreen.uiCamera.viewportHeight / 6f;
        float x = gameScreen.uiCamera.viewportWidth / 2f - w / 2f;
        float y = gameScreen.uiCamera.viewportHeight / 2f - h / 2f;
        bounds = new Rectangle(x, y, w, h);

        manageMap = new ObjectMap<Manage.Type, Manage>();
        manageMap.put(Manage.Type.SLAVES, new ManageSlaves(bounds));
        manageMap.put(Manage.Type.UPGRADES, new ManageUpgrades(bounds));
        manageMap.put(Manage.Type.WORKERS, new ManageWorkers(bounds));
        manageMap.put(Manage.Type.RESOURCES, new ManageResources(bounds));
        manageMap.put(Manage.Type.PHAROAH, new ManagePharoah(bounds));

        currentManage = manageMap.get(Manage.Type.SLAVES);
    }

    @Override
    public void update(float delta) {
        currentManage.update(delta);
    }

    @Override
    public void render(SpriteBatch batch) {
        batch.setColor(0.5f, 0.5f, 0.5f, 1.0f);
        batch.draw(Assets.mgmtBackground, bounds.x, bounds.y, bounds.width, bounds.height);
        batch.setColor(Color.WHITE);
        Assets.niceNinePatch.draw(batch, bounds.x, bounds.y, bounds.width, bounds.height);

        currentManage.render(batch);
    }

    public void setCurrentManageType(Manage.Type newType) {
        currentManage = manageMap.get(newType);
    }
}

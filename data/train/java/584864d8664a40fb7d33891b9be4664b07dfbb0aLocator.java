package binauld.pierre.musictag.service;

import android.graphics.Bitmap;

/**
 * Implement the service locator pattern for the bitmap Cache service.
 */
public class Locator {

    private static CacheService<Bitmap> cacheService;

    /**
     * Provide a bitmap cache service.
     * @param cacheService The bitmap cache service provided.
     */
    public static void provide(CacheService<Bitmap> cacheService) {
        Locator.cacheService = cacheService;
    }

    /**
     * Get The bitmap cache service.
     * @return The bitmap cache service.
     */
    public static CacheService<Bitmap> getCacheService() {
        return Locator.cacheService;
    }
}

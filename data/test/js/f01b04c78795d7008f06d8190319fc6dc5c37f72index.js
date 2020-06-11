const placeService = require('./place-service');
const snapshotService = require('./snapshot-service');
const frontpageService = require('./frontpage-service');

async function populateInitialCache () {
    try {
        await placeService.populateInitialCache();
        await snapshotService.populateInitialCache();
        await frontpageService.populateInitialCache();
    } catch (error) {
        console.error(error);
    }
}

module.exports = {
    populateInitialCache,
    placeService,
    snapshotService
};

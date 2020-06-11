import angular from 'angular';

import CardCounterController from './card-counter-controller';
import CardExplorerController from './card-explorer-controller';
import CardFilterController from './card-filter-controller';
import CardModalController from './card-modal-controller';
import BackupController from './backup-controller';
import DeckBuilderController from './deck-builder-controller';
import DeckListController from './deck-list-controller';
import BackupSaveController from './backup-save-controller';
import BackupLoadController from './backup-load-controller';
import MenuController from './menu-controller';
import OwnCardsController from './own-cards-controller';
import UtilController from './util-controller';


export default angular.module('Controllers', [])
    .controller('CardCounterController', CardCounterController)
    .controller('CardExplorerController', CardExplorerController)
    .controller('CardFilterController', CardFilterController)
    .controller('CardModalController', CardModalController)
    .controller('BackupController', BackupController)
    .controller('DeckBuilderController', DeckBuilderController)
    .controller('DeckListController', DeckListController)
    .controller('BackupLoadController', BackupLoadController)
    .controller('BackupSaveController', BackupSaveController)
    .controller('MenuController', MenuController)
    .controller('OwnCardsController', OwnCardsController)
    .controller('UtilController', UtilController);

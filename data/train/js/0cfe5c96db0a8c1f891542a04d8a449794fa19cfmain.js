define([
    'testConfig'
  ],

  function () {

    require([
      'mmdl',
      'ButtonsController',
      'TextInputsController',
      'CardsController',
      'ProgressBarsController',
      'jquery',
      'backbone',
      'marionette',
      'dust'
    ],

    function (
      mmdl,
      ButtonsController,
      TextInputsController,
      CardsController,
      ProgressBarsController
      ) {

      //Create a new mmdl app
      var app = mmdl.app({
        routes: {
          buttons: ButtonsController,
          textInputs: TextInputsController,
          cards: CardsController,
          progressBars: ProgressBarsController
        }
      });

      //Start the application
      app.start();
  });
});
(function () {
  const showService = window.vep.services.show;

  class PageShow {
    beforeRegister() {
      this.is = "page-show";

      this.properties = {
        canonical: {
          type: String,
          value: null
        },
        show: {
          type: Object,
          value: null,
          observer: "_showChanged"
        }
      }
    }

    attached() {
      const that = this;
      showService.find(this.canonical).then((show) => that.show = show);
    }

    _showChanged(value) {
      if (value) {
        this.$.content.innerHTML = value.content;
      }
    }
  }

  Polymer(PageShow);
})();
describe('EIGENFACTORIZER.default_options', function () {
  var default_options = EIGENFACTORIZER.default_options;

  describe('#makeComplete', function () {
    it('should return an object when passed null', function () {
      expect(default_options.makeComplete(null)).toEqual(
	default_options.defaults);
    });

    it('should fill in missing values from default', function () {
      expect(default_options.makeComplete(
	{show_modal: true,
	 color_scheme: 0})).toEqual(
	   { debug: false,
	     show_modal: true,
	     show_color_key: true,
	     show_impact: true,
	     show_search: true,
	     show_share: true,
	     color_scheme: 0});
      expect(default_options.makeComplete(
	{debug: true,
	 color_scheme: 0})).toEqual(
	   { debug: true,
	     show_modal: true,
	     show_color_key: true,
	     show_impact: true,
	     show_search: true,
	     show_share: true,
	     color_scheme: 0});
      expect(default_options.makeComplete(
	{debug: true,
	 show_modal: true})).toEqual(
	   { debug: true,
	     show_modal: true,
	     show_color_key: true,
	     show_impact: true,
	     show_search: true,
	     show_share: true,
	     color_scheme: 0});
    });

    it('should fill in missing values from template', function () {
      expect(default_options.makeComplete(
	{debug: false,
	 show_modal: true},
	{debug: false,
	 show_modal: true,
	 color_scheme: 4})).toEqual(
	   { debug: false,
	     show_modal: true,
	     show_color_key: true,
	     show_impact: true,
	     show_search: true,
	     show_share: true,
	     color_scheme: 4});
    });

    it('should fall back to default when template values missing', function () {
      expect(default_options.makeComplete(
	{debug: false,
	 show_modal: true},
	{debug: true,
	 show_modal: true})).toEqual(
	   { debug: false,
	     show_modal: true,
	     show_color_key: true,
	     show_impact: true,
	     show_search: true,
	     show_share: true,
	     color_scheme: 0});
    });
  });

});

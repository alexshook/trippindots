AppRouter = Backbone.Router.extend({
  routes: {"":"index"},

  inititalize: function() {
    this.input = new TrippinView();
  },

  start: function() {
    Backbone.history.start();
  },

  index: function() {
    var searchForm = new SearchFormView();

  }

})

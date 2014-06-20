var SearchFormView = Backbone.View.extend({
  el: 'div#search-form',

  initialize: function() {
    this.render();
  },

  events: {
    'click .analyze-button': "getEchoNestData"
  },

  render: function() {
  },

  getEchoNestData: function(e) {
    this.cleanTrippinDisplay();
    var localURL = $(e.currentTarget).prev()[0].innerHTML;
    var songURL = 'https://s3.amazonaws.com/trippindotssongs/' + localURL.split(' ').join('+');
    var sensitivity = this.$('#sensitivity-value').val();
    $.ajax({
      url: '/echonest_analyze',
      type: 'GET',
      data: {
        song_url: songURL
      },
      dataType: 'json'
    }).done(function(data) {
      this.trippinDotsView = new TrippinDotsView({
        data: data.meta_data,
        sensitivity: sensitivity,
        artist: data.artist,
        song: data.song,
        songURL: songURL
      });
      this.trippinDotsView.$el.appendTo($('#trippin-display'));
    }.bind(this));
  },

  cleanTrippinDisplay: function(){
    $('#trippin-error').remove();
    if (this.trippinDotsView !== undefined) {
      _.each(this.trippinDotsView.timeOuts, function(timeOut, index){
        clearTimeout(timeOut);
      }.bind(this));
    }
    $('#trippin-display').remove();
    $('body').append("<div id='trippin-display'>");
  },

  trippinDotsError: function(){
    $('#trippin-error').remove();
    $('body').append("<div id='trippin-error'>Sorry, we don't have data on that song/artist. Check your spelling or try searching again</div>");
  }
});

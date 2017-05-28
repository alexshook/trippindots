var SearchFormView = Backbone.View.extend({
  el: 'div#search-form',

  initialize: function() {
    this.render();
  },

  events: {
    'click .analyze-button': "getTrackAnalysis"
  },

  render: function() {
  },

  getTrackAnalysis: function(e) {
    this.cleanTrippinDisplay();
    var trackName = $(e.currentTarget).prev()[0].innerHTML;
    var sensitivity = this.$('#sensitivity-value').val();
    $.ajax({
      url: '/spotify_analyze',
      type: 'GET',
      data: {
        track_name: trackName
      },
      dataType: 'json'
    }).done(function(data) {
      this.trippinDotsView = new TrippinDotsView({
        data: data.meta_data,
        sensitivity: sensitivity,
        artist: data.artist,
        song: data.song,
        songURL: data.file
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

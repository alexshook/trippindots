var SearchFormView = Backbone.View.extend({
  el: 'div#search-form',
  initialize: function() {
    this.template = _.template($("#search-form-template").html());
    this.render();
  },
  events: {
    'click #search-button': "getEchoNestData"
  },
  render: function() {
    this.$el.html(this.template);
  },
  getEchoNestData: function() {
    this.cleanTrippinDisplay();
    var title = this.$('#search-input-title').val();
    var artist = this.$('#search-input-artist').val();
    var sensitivity = this.$('#sensitivity-value').val();
    title = title.split(' ').join('+');
    artist = artist.split(' ').join('+');
    $.ajax({
      url: '/search_soundcloud',
      type: 'GET',
      data: {
        title: title,
        artist_name: artist
      },
      dataType: 'json'
    }).done(function(data) {
      var soundcloudSong = data['soundcloud_song'];
      var soundcloudSongSanitized = soundcloudSong.replace('http://', '')
      console.log(soundcloudSongSanitized);
      $('#sound').append("<iframe width='0' height='0' scrolling='no' frameborder='no' src='https://w.soundcloud.com/player/?url=https%3A//" + soundcloudSongSanitized + "&amp;auto_play=true&amp;hide_related=false&amp;visual=true'></iframe>");
    });
    $.ajax({
      url: '/search',
      type: 'GET',
      data: {
        title: title,
        artist_name: artist
      },
      dataType: 'json'
    }).done(function(data) {
      if (data['artist'] === 'trippinDots error') {
        this.trippinDotsError();
      } else {
        this.trippinDotsView = new TrippinDotsView({
          data: data['meta_data'],
          sensitivity: sensitivity,
          artist: data['artist'],
          song: data['song']
        });
      this.trippinDotsView.$el.appendTo($('#trippin-display'));
    }
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

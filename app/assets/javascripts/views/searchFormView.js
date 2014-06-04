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
    var title = this.$('#search-input').val();
    var sensitivity = this.$('#sensitivity-value').val();
    title = title.split(' ').join('+');
    $.ajax({
      url: '/search',
      type: 'GET',
      data: {title: title},
      dataType: 'json'
    }).done(function(data) {
      this.trippinDotsView = new TrippinDotsView({
        data: data['meta_data'],
        sensitivity: sensitivity,
        itunes_audio: data['itunes_audio_url'],
        artist: data['artist'],
        song: data['song']
      });
    this.trippinDotsView.$el.appendTo($('#trippin-display'));
    }.bind(this));
  },
  cleanTrippinDisplay: function(){
    if (this.trippinDotsView !== undefined) {
      _.each(this.trippinDotsView.timeOuts, function(timeOut, index){
        clearTimeout(timeOut);
      }.bind(this));
    }
    $('#trippin-display').remove();
    $('body').append("<div id='trippin-display'>");
  }
});

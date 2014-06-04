var TrippinDotsView = Backbone.View.extend({
  el: 'div#trippin-display',
  initialize: function(options) {
    self = this;
    this.options = options || {};
    this.options.data = this.options.data;
    this.sections = this.options.data['sections'];
    this.segments = this.options.data['segments'];
    this.timeOuts = [];
    this.render();
  },
  render: function() {
    $('#trippin-display').append('<h2 id="song">' + this.options['song'] + '</h2>');
    $('#trippin-display').append('<h3 id="artist">' + this.options['artist'].split("+").join(" ") + '</h3>');
    _.each(this.sections, function(section, index) {
      if (index !== 0) {
        $('#trippin-display').append('<p>section start time: ' + Math.round(this.sections[index-1]['start']) + ' secs - ' + Math.round(section["start"]) + ' secs</p> <div class="section" id="section_' + index + '"></div>');
        this.timeOuts.push(setTimeout(self.scroller, section["start"] * 1000, $('div#section_' + index).offset().top));
      }
    }.bind(this));
    this.appendAudio();
    setTimeout(function(){
      this.initializeDots();
    }.bind(this), 0);
  },
  appendAudio: function() {
    $('#trippin-display').append("<audio id='audio-play' src='/assets/gotye.mp3'></audio>");
    setTimeout(function(){
      $('#audio-play').trigger('play');
    }, 0);
  },
  initializeDots: function() {
    for (var i = 0; i < this.segments.length; i++) {
      if (this.segments[i]["timbre"][0] > this.options.sensitivity) {
         this.timeOuts.push(setTimeout(this.appendDot, this.segments[i]["start"]*1000, this.segments[i]));
      }
    }
  },
  appendDot: function(segment) {
    var dot = $('<div>');
    var size = segment['loudness_start'] + 60;
    var r = Math.floor(Math.random() * 255);
    var g = Math.floor(Math.random() * 255);
    var b = Math.floor(Math.random() * 255);
    dot.css({
      background: 'rgb('+r+','+g+','+b+')',
      height: size * 3,
      width: size * 3,
      top: Math.random() * 300,
      left: Math.random() * $('#section_1').width()
    });
    dot.addClass('dot');
    for (var i = 1; i < self.options.data["sections"].length; i++) {
      if (segment['start'] < self.options.data["sections"][i]['start']) {
        $('#section_' + i).append(dot);
        break;
      }
    }
  },
  scroller: function(offset){
    $('html, body').animate({
      scrollTop: offset
    }, 500);
  }
});

$(function () {
  if (!!window.EventSource) {
    startSSE();
  } else {
    alert('SSEs are not available. Please reload the page to check the processing progress');
  }

  function startSSE() {
    var videos = $.grep($('.thumbnail'), function (video) {
      return $(video).data('state') != 'processed';
    });

    videos.forEach(function (video) {
      listenFor(video);
    });
  }

  function listenFor(obj) {
    var video = $(obj);
    var videoId = video.data('id');
    var thumbnail = video.find('img');

    var fileSource = new EventSource(`videos/${videoId}/file_state`);
    var thumbnailSource = new EventSource(`videos/${videoId}/thumbnail_state`);

    fileSource.addEventListener('message', function(e) {
      var data = e.data;
      if (data != 'processed') return;

      video.find('.pending').fadeOut('slow', function () {
        video.find('.processed').fadeIn('slow');
      });
      fileSource.close();
    });

    thumbnailSource.addEventListener('message', function(e) {
      var data = e.data;
      if (thumbnail.attr('src') == data) return;

      thumbnail.fadeOut('slow', function () {
        thumbnail.attr('src', data);
        thumbnail.fadeIn('slow');
      });
      thumbnailSource.close();
    });
  }
});

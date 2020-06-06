
// functins (global) called form js.erb

function toggleEam() {
  $('a.toggle-edit-answer-modal').on('click', function(e) {
    e.preventDefault();
    $('.edit-answer-modal').toggleClass('d-none');
  });
};

function sendFile(that, file) {
  var data;
  data = new FormData;
  data.append('image[image]', file);
  $.ajax({
    data: data,
    type: 'POST',
    url: "/images",
    cache: false,
    contentType: false,
    processData: false,
    success: function(data) {
      var img;
      img = document.createElement('IMG');
      img.src = data.url;
      img.setAttribute('id', data.image_id);
      $(that).summernote('insertNode', img);
      // clearing the file_inputs for remote submission.
      var form = $(that).parents('form');
      var fileInputs = form.find('input[type="file"]');
      fileInputs.wrap('form').closest('form').get(0).reset();
      fileInputs.unwrap();
    }
  });
};

function deleteFile(file_id) {
  $.ajax({
    type: 'DELETE',
    url: "/images/" + file_id,
    cache: false,
    contentType: false,
    processData: false
  });
};

function initSummernote() {
  $('[data-provider="summernote"]').each(function() {
    $(this).summernote({
      tabsize: 2,
      height: 200,
      placeholder: '....',
      toolbar: [['font', ['bold', 'underline','strikethrough', 'superscript', 'subscript', 'clear']],
                ['font', ['style', 'color']],
                ['para', ['ul', 'ol', 'paragraph', 'height']],
                ['insert', ['link', 'picture', 'video', 'hr', 'table']],
                ['view', ['fullscreen', 'help']]],
      callbacks: {
        onImageUpload: function(files) {
          var img;
          img = sendFile(this, files[0]);
        },
        onMediaDelete: function(target, editor, editable) {
          var image_id;
          image_id = target[0].id;
          if (!!image_id) {
            deleteFile(image_id);
          }
          target.remove();
        }
      }
    });
  });
};

$('.q-upvote').click(function(e) {
  var elem, q_id;
  e.preventDefault;
  elem = $(this);
  q_id = elem.attr('id').split('@#!')[0];
  $.ajax({
    url: '/questions/' + q_id + '/vote',
    type: 'put',
    data: {},
    success: function(data) {
      elem.html('Helpful (' + data.count + ')');
    },
    error: function(data) {}
  });
});

$('.a-upvote').click(function(e) {
  var a_id, elem, q_id;
  e.preventDefault;
  elem = $(this);
  q_id = elem.attr('id').split('@#!')[0];
  a_id = elem.attr('id').split('@#!')[1];
  $.ajax({
    url: '/questions/' + q_id + '/answers/' + a_id + '/vote',
    type: 'put',
    data: {},
    success: function(data) {
      elem.html('Vote as Helpful Answer (' + data.count + ')');
    },
    error: function(data) {}
  });
});

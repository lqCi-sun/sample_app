document.addEventListener('turbo:load', function() {
  document.addEventListener('change', function(event) {
    let image_upload = document.querySelector('#micropost_image');
    const size_in_megabytes = image_upload.files[0].size/1024/1024;
    if (size_in_megabytes > Settings.micropost.image_megabytes) {
      I18n.t('js.micropost.max_size_error');
      image_upload.value = '';
    }
  });
});

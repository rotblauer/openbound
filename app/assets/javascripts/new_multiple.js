  // $(document).ready(function() {

  //   // Activating Bootstrap Tooltip 
  //   $('.has-tooltip').tooltip();
  //   // Activating Best In Place 
  //   jQuery(".best_in_place").best_in_place();
  //   // 'use strict';
  //   var multiple_works_form = $('#new_work');
  //   // http://stackoverflow.com/questions/7755966/how-do-i-use-jquery-to-disable-a-forms-submit-button-until-every-required-field
  //   // $form = $('#new_work'); // cache
  //   multiple_works_form.find(':input[type="submit"]').prop('disabled', true); // disable submit btn
  //   multiple_works_form.find(':input').change(function() { // monitor all inputs for changes
  //       var disable = false;
  //       multiple_works_form.find(':input').not('[type="submit"]').each(function(i, el) { // test all inputs for values
  //           if ($.trim(el.value) === '') {
  //               disable = true; // disable submit if any of them are still blank
  //           }
  //       });
  //       multiple_works_form.find(':input[type="submit"]').prop('disabled', disable);
  //   });

  //   multiple_works_form.fileupload({
  //     // http://stackoverflow.com/questions/17451629/maxfilesize-and-acceptfiletypes-in-blueimp-file-upload-plugin-do-not-work-why

  //     // add: function(e, data) {
  //     //         var uploadErrors = [];
  //     //         var acceptFileTypes = /^image\/(gif|jpe?g|png)$/i;
  //     //         if(data.files[0]['type'].length && !acceptFileTypes.test(data.files[0]['type'])) {
  //     //             uploadErrors.push('Not an accepted file type');
  //     //         }
  //     //         if(data.files[0]['size'].length && data.files[0]['size'] > 5000000) {
  //     //             uploadErrors.push('Filesize is too big');
  //     //         }
  //     //         if(uploadErrors.length > 0) {
  //     //             alert(uploadErrors.join("\n"));
  //     //         } else {
  //     //             data.submit();
  //     //         }
  //     // },

  //     dataType: 'script',
  //     dropZone: $('#dropzone'),

  //     // add: function (e, data) {
  //     //   var acceptedTypes = /(\.|\/)(<%= DocumentUploader::WHITE_ARM.join('|') %>)$/i;
  //     //   file = data.files[0];
  //     //   if (acceptedTypes.test(file.type) || acceptedTypes.test(file.name)) {
  //     //     data.submit();
  //     //   }
  //     //   else { alert(file.name + " must be an image (GIF, JPEG, PDF, PNG, BMP) or text-based (DOC, DOCX, RTF, TXT, MD, HTML) file, \n and it must be less than 5 megabytes."); }
  //     // }

  //     add: function (e, data) {
  //       var uploadErrors = [];
  //       acceptedTypes = /(\.|\/)(<%= DocumentUploader::WHITE_ARM.join('|') %>)$/i;
  //       file = data.files[0];
  //       if (data.files[0]['type'].length && !( acceptedTypes.test(file.type) || acceptedTypes.test(file.name) ) ) {
  //         uploadErrors.push(file.name + ' is not an accepted file type. \n\nWe currently accept: \n.jpg .jpeg .gif .png .bmp \n.doc .docx .ppt .pptx .xls .xlsx \n.txt .md .tex .rtf .csv .html \n.pdf \n.odt .odp .ods \n.pages .numbers .key');
  //       }
  //       if (data.files[0].size > 5242880) {
  //         uploadErrors.push(file.name + ' is too big. Maximum file size is 5mb.');
  //       }
  //       if (uploadErrors.length > 0) {
  //           alert(uploadErrors.join('\n\n'));
  //       } 
  //       else {
  //         data.submit();
  //       }
  //     }
  //   });

  //   // Progress bar.
  //   var wrapper = multiple_works_form.find('.progress-wrapper');
  //   var progress_bar = wrapper.find('.progress-bar');
     
  //   multiple_works_form.on('fileuploadstart', function() {
  //     wrapper.show();
  //   });
     
  //   multiple_works_form.on('fileuploaddone', function() {
  //     wrapper.hide();
  //     progress_bar.width(0); // Revert progress bar's width back to 0 for future uploads
  //   });
     
  //   multiple_works_form.on('fileuploadprogressall', function (e, data) {
  //     var progress = parseInt(data.loaded / data.total * 100, 10);
  //     progress_bar.css('width', progress + '%').text(progress + '%');
  //   });

  //   // Bitrate.
  //   var bitrate = wrapper.find('.bitrate');
  //   // Process. 
  //   var process = wrapper.find('.process');
  //   // var spinner = wrapper.find('.spinner');
     
  //   multiple_works_form.on('fileuploadprogressall', function (e, data) {
  //     bitrate.text((data.bitrate / 1024).toFixed(2) + 'Kb/s');
     
  //     var progress = parseInt(data.loaded / data.total * 100, 10);
  //     progress_bar.css('width', progress + '%').text(progress + '%');

  //     if ((data.loaded / data.total) == 1) {
  //       process.removeClass('hidden');
  //       // spinner.removeClass('hidden');
  //     }
  //   });

  // });

  // $(document).bind('dragover', function (e) {
  //   var dropZone = $('#dropzone'),
  //           timeout = window.dropZoneTimeout;
  //   if (!timeout) {
  //     dropZone.addClass('in');
  //   } else {
  //     clearTimeout(timeout);
  //   }
  //   var found = false,
  //           node = e.target;
  //   do {
  //     if (node === dropZone[0]) {
  //       found = true;
  //       break;
  //     }
  //     node = node.parentNode;
  //   } while (node != null);
  //   if (found) {
  //     dropZone.addClass('hover');
  //   } else {
  //     dropZone.removeClass('hover');
  //   }
  //   window.dropZoneTimeout = setTimeout(function () {
  //     window.dropZoneTimeout = null;
  //     dropZone.removeClass('in hover');
  //   }, 100);

  // });  
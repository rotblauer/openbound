// /// From Google documentation
// //https://developers.google.com/drive/web/integrate-open

//     console.log('Google Drive Filepicker reporting for duty!!!');

// // The Browser API key obtained from the Google Developers Console.
//     // Replace with your own Browser API key, or your own key.
//     var developerKey = 'AIzaSyAnYDLf-IB51jHgXb-baOVtB-uBvoPGoLk';

//     // The Client ID obtained from the Google Developers Console. Replace with your own Client ID.
//     var clientId = "592292275881-goo2qidsn0nrb26n9d8hn4qnn8she0hp.apps.googleusercontent.com";

//     // Replace with your own App ID. (Its the first number in your Client ID)
//     var appId = "592292275881";

//     // Scope to use to access user's Drive items.
//     var scope = ['https://www.googleapis.com/auth/drive'];

//     var pickerApiLoaded = false;
//     var oauthToken;

//     // Use the Google API Loader script to load the google.picker script.
//     function loadPicker() {
//       gapi.load('auth', {'callback': onAuthApiLoad});
//       gapi.load('picker', {'callback': onPickerApiLoad});
//     }

//     //http://stackoverflow.com/questions/11864657/google-drive-access-webcontentlink-through-javascript
//     function getData(url, callback) {
//         xmlhttp = new XMLHttpRequest();
//         xmlhttp.onreadystatechange = function() {
//             if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
//                 callback(xmlhttp.responseText);
//             }
//         }
//         xmlhttp.open('GET', url, true);
//         var myToken = gapi.auth.getToken();
//         xmlhttp.setRequestHeader('Authorization', 'Bearer ' + myToken.access_token);
//         xmlhttp.send();
//     }

//     function onAuthApiLoad() {
//       window.gapi.auth.authorize(
//           {
//             'client_id': clientId,
//             'scope': scope,
//             'immediate': false
//           },
//           handleAuthResult);
//     }

//     function onPickerApiLoad() {
//       pickerApiLoaded = true;
//       createPicker();
//     }

//     function handleAuthResult(authResult) {
//       if (authResult && !authResult.error) {
//         oauthToken = authResult.access_token;
//         createPicker();
//       }
//     }

//     // Create and render a Picker object for searching images.
//     function createPicker() {
//       if (pickerApiLoaded && oauthToken) {
//         var view = new google.picker.View(google.picker.ViewId.DOCS);
//         view.setMimeTypes("image/png,image/jpeg,image/jpg");
//         var picker = new google.picker.PickerBuilder()
//             .enableFeature(google.picker.Feature.NAV_HIDDEN)
//             .enableFeature(google.picker.Feature.MULTISELECT_ENABLED)
//             .setAppId(appId)
//             .setOAuthToken(oauthToken)
//             .addView(view)
//             .addView(new google.picker.DocsUploadView())
//             .setDeveloperKey(developerKey)
//             .setCallback(pickerCallback)
//             .build();
//          picker.setVisible(true);
//       }
//     }

// 	// A simple callback implementation.
// 	//http://stackoverflow.com/questions/11864657/google-drive-access-webcontentlink-through-javascript
// 	function pickerCallback(data) {
// 	   if (data.action == google.picker.Action.PICKED) {
// 	       var fileId = data.docs[0].id;
// 	       var url = 'https://www.googleapis.com/drive/v2/files/' + fileId;
// 	       getData(url, function(responseText) {
// 	           var metaData = JSON.parse(responseText);
// 	           // getData(metaData.downloadUrl, function(text) {
// 	           //     //Do something with text...
// 	           //     console.log(text);
// 	           // });
// 	         	console.log(metaData.downloadUrl);
// 	         	var downloadUrler = metaData.downloadUrl;
// 	         	// console.log(metaData.webContentLink);
// 	         	// var webContentLinker = metaData.webContentLink;
// 	         	// This get request to downloadUrl needs to be authorized somehow. 
// 	         	document.getElementById('google_work_document').setAttribute('value', downloadUrler);
// 	       });
// 	   }
// 	}





// // /**!
// //  * Google Drive File Picker Example
// //  * By Daniel Lo Nigro (http://dan.cx/)
// //  */
// // (function() {
// // 	/**
// // 	 * Initialise a Google Driver file picker
// // 	 */
// // 	var FilePicker = window.FilePicker = function(options) {
// // 		// Config
// // 		this.apiKey = options.apiKey;
// // 		this.clientId = options.clientId;
 
// // 		// Elements
// // 		this.buttonEl = options.buttonEl;
 
// // 		// Events
// // 		this.onSelect = options.onSelect;
// // 		this.buttonEl.addEventListener('click', this.open.bind(this));
 
// // 		// Disable the button until the API loads, as it won't work properly until then.
// // 		this.buttonEl.disabled = true;
 
// // 		// Load the drive API
// // 		gapi.client.setApiKey(this.apiKey);
// // 		gapi.client.load('drive', 'v2', this._driveApiLoaded.bind(this));
// // 		google.load('picker', '1', { callback: this._pickerApiLoaded.bind(this) });
// // 	}
 
// // 	FilePicker.prototype = {
// // 		/**
// // 		 * Open the file picker.
// // 		 */
// // 		open: function() {
// // 			// Check if the user has already authenticated
// // 			var token = gapi.auth.getToken();
// // 			if (token) {
// // 				this._showPicker();
// // 			} else {
// // 				// The user has not yet authenticated with Google
// // 				// We need to do the authentication before displaying the Drive picker.
// // 				this._doAuth(false, function() { this._showPicker(); }.bind(this));
// // 			}
// // 		},
 
// // 		/**
// // 		 * Show the file picker once authentication has been done.
// // 		 * @private
// // 		 */
// // 		_showPicker: function() {
// // 			var accessToken = gapi.auth.getToken().access_token;
// // 			var view = new google.picker.DocsView();
// // 			// view.setIncludeFolders(true);
// // 			view.setMimeTypes("image/png,image/jpeg,image/jpg");
// // 			this.picker = new google.picker.PickerBuilder()
// // 				.enableFeature(google.picker.Feature.NAV_HIDDEN)
// // 				.enableFeature(google.picker.Feature.MULTISELECT_ENABLED)
// // 				.setAppId(this.clientId)
// // 				.setDeveloperKey(this.apiKey)
// // 				.setOAuthToken(accessToken)
// // 				.addView(view)
// // 				.setCallback(this._pickerCallback.bind(this))
// // 				.build()
// // 				.setVisible(true);
// // 		},
 
// // 		/**
// // 		 * Called when a file has been selected in the Google Drive file picker.
// // 		 * @private
// // 		 */
// // 		_pickerCallback: function(data) {
// // 			var url = 'nothing';
// // 			if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
// // 				// var file = data[google.picker.Response.DOCUMENTS][0],
// // 				// 	id = file[google.picker.Document.ID],
// // 				// 	request = gapi.client.drive.files.get({
// // 				// 		fileId: id
// // 				// 	});
// //  					var fileId = data.docs[0].id;
// //  					var url = 'https://www.googleapis.com/drive/v2/files/' + fileId;

// // 	        getData(url, function(responseText) {
// // 	            var metaData = JSON.parse(responseText);
// // 	            getData(metaData.downloadUrl, function(text) {
// // 	                //Do something with text...
// // 	                document.getElementById('google_work_document').setAttribute('value', text);
// // 	            });
// // 	        });
// // 				// request.execute(this._fileGetCallback.bind(this));
// // 				// var doc = data[google.picker.Response.DOCUMENTS][0];
// // 				// url = doc[google.picker.Document.URL];

// // 				// these don't work
// // 				// url = doc['webContentLink'];
// // 				// url = doc[google.picker.Document.downloadUrl];
// // 			}
// // 			// document.getElementById('google_work_document').setAttribute('value', url);
// // 		},


// // 		// http://stackoverflow.com/questions/11864657/google-drive-access-webcontentlink-through-javascript
// // 		// function pickerCallback(data) {
// // 		//     if (data.action == google.picker.Action.PICKED) {
// // 		//         var fileId = data.docs[0].id;
// // 		//         var url = 'https://www.googleapis.com/drive/v2/files/' + fileId;
// // 		//         getData(url, function(responseText) {
// // 		//             var metaData = JSON.parse(responseText);
// // 		//             getData(metaData.downloadUrl, function(text) {
// // 		//                 //Do something with text...
// // 		//             });
// // 		//         });
// // 		//     }
// // 		// }

// // 		// http://stackoverflow.com/questions/20204383/how-to-pass-data-from-google-drive-api-into-rails-app-model
// // 		// // A simple callback implementation.
// // 		//  function pickerCallback(data) {
// // 		//    var url = 'nothing';
// // 		//    if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
// // 		//      var doc = data[google.picker.Response.DOCUMENTS][0];
// // 		//      url = doc[google.picker.Document.URL];
// // 		//    }
// // 		//    document.getElementById('gdrive').setAttribute('value', url);
// // 		//  }


// // 		/**
// // 		 * Called when file details have been retrieved from Google Drive.
// // 		 * @private
// // 		 */
// // 		_fileGetCallback: function(file) {
// // 			if (this.onSelect) {
// // 				this.onSelect(file);
// // 			}
// // 		},
 
// // 		/**
// // 		 * Called when the Google Drive file picker API has finished loading.
// // 		 * @private
// // 		 */
// // 		_pickerApiLoaded: function() {
// // 			this.buttonEl.disabled = false;
// // 		},
 
// // 		/**
// // 		 * Called when the Google Drive API has finished loading.
// // 		 * @private
// // 		 */
// // 		_driveApiLoaded: function() {
// // 			this._doAuth(true);
// // 		},
 
// // 		/**
// // 		 * Authenticate with Google Drive via the Google JavaScript API.
// // 		 * @private
// // 		 */
// // 		_doAuth: function(immediate, callback) {
// // 			gapi.auth.authorize({
// // 				client_id: this.clientId,
// // 				scope: 'https://www.googleapis.com/auth/drive.readonly',
// // 				immediate: immediate
// // 			}, callback);
// // 		}
// // 	};
// // }());






// // ///// From Google documentation
// // // https://developers.google.com/drive/web/integrate-open

// // // // The Browser API key obtained from the Google Developers Console.
// // //     // Replace with your own Browser API key, or your own key.
// // //     var developerKey = 'AIzaSyAnYDLf-IB51jHgXb-baOVtB-uBvoPGoLk';

// // //     // The Client ID obtained from the Google Developers Console. Replace with your own Client ID.
// // //     var clientId = "592292275881-goo2qidsn0nrb26n9d8hn4qnn8she0hp.apps.googleusercontent.com"

// // //     // Replace with your own App ID. (Its the first number in your Client ID)
// // //     var appId = "592292275881";

// // //     // Scope to use to access user's Drive items.
// // //     var scope = ['https://www.googleapis.com/auth/drive'];

// // //     var pickerApiLoaded = false;
// // //     var oauthToken;

// // //     // Use the Google API Loader script to load the google.picker script.
// // //     function loadPicker() {
// // //       gapi.load('auth', {'callback': onAuthApiLoad});
// // //       gapi.load('picker', {'callback': onPickerApiLoad});
// // //     }

// // //     function onAuthApiLoad() {
// // //       window.gapi.auth.authorize(
// // //           {
// // //             'client_id': clientId,
// // //             'scope': scope,
// // //             'immediate': false
// // //           },
// // //           handleAuthResult);
// // //     }

// // //     function onPickerApiLoad() {
// // //       pickerApiLoaded = true;
// // //       createPicker();
// // //     }

// // //     function handleAuthResult(authResult) {
// // //       if (authResult && !authResult.error) {
// // //         oauthToken = authResult.access_token;
// // //         createPicker();
// // //       }
// // //     }

// // //     // Create and render a Picker object for searching images.
// // //     function createPicker() {
// // //       if (pickerApiLoaded && oauthToken) {
// // //         var view = new google.picker.View(google.picker.ViewId.DOCS);
// // //         view.setMimeTypes("image/png,image/jpeg,image/jpg");
// // //         var picker = new google.picker.PickerBuilder()
// // //             .enableFeature(google.picker.Feature.NAV_HIDDEN)
// // //             .enableFeature(google.picker.Feature.MULTISELECT_ENABLED)
// // //             .setAppId(appId)
// // //             .setOAuthToken(oauthToken)
// // //             .addView(view)
// // //             .addView(new google.picker.DocsUploadView())
// // //             .setDeveloperKey(developerKey)
// // //             .setCallback(pickerCallback)
// // //             .build();
// // //          picker.setVisible(true);
// // //       }
// // //     }

// // //     // A simple callback implementation.
// // //     function pickerCallback(data) {
// // //       if (data.action == google.picker.Action.PICKED) {
// // //         var fileId = data.docs[0].id;
// // //         alert('The user selected: ' + fileId);
// // //       }
// // //     }
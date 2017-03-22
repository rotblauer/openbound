// I have fork with updated ClientId handling and better picker (allows to open folders)
// https://gist.github.com/JLarky/640859bed8704520dd61

/**!
 * Google Drive File Picker Example
 * By Daniel Lo Nigro (http://dan.cx/)
 */
(function() {
	/**
	 * Initialise a Google Driver file picker
	 */
	var FilePicker = window.FilePicker = function(options) {
		// Config
		this.apiKey = options.apiKey;
		this.clientId = options.clientId;

		// Elements
		this.buttonEl = options.buttonEl;

		// Events
		this.onSelect = options.onSelect;
		this.buttonEl.addEventListener('click', this.open.bind(this));

		// Disable the button until the API loads, as it won't work properly until then.
		this.buttonEl.disabled = true;

		// Load the drive API
		gapi.client.setApiKey(this.apiKey);

		gapi.client.load('drive', 'v2', this._driveApiLoaded.bind(this));
		google.load('picker', '1', { callback: this._pickerApiLoaded.bind(this) });
	}

	FilePicker.prototype = {
		/**
		 * Open the file picker.
		 */
		open: function() {
			// Check if the user has already authenticated
			var token = gapi.auth.getToken();
			if (token) {
				this._showPicker();
			} else {
				// The user has not yet authenticated with Google
				// We need to do the authentication before displaying the Drive picker.
				this._doAuth(false, function() { this._showPicker(); }.bind(this));
			}
		},

		/**
		 * Show the file picker once authentication has been done.
		 * @private
		 */
		_showPicker: function() {
			var accessToken = gapi.auth.getToken().access_token;
			var view = new google.picker.DocsView();
			view.setIncludeFolders(true);
			this.picker = new google.picker.PickerBuilder()
				.addView(google.picker.ViewId.DOCUMENTS) // <-- only allow DOCUMENTS, so far. - ia
				// .enableFeature(google.picker.Feature.NAV_HIDDEN)
				.enableFeature(google.picker.Feature.MULTISELECT_ENABLED) // <--
				.setAppId(this.clientId)
        // http://stackoverflow.com/questions/23548135/api-developer-key-error-with-google-drive-picker/23551463#23551463
        // Don't know why commenting this makes it work in development, but it does.
				.setDeveloperKey(this.apiKey)
				.setOAuthToken(accessToken)
				.addView(view)
				.setCallback(this._pickerCallback.bind(this))
				.build()
				.setVisible(true);
		},

		/**
		 * Called when a file has been selected in the Google Drive file picker.
		 * @private
		 */
		_pickerCallback: function(data) {
			if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {


				///////////////////////// DRAFTY
				var files = data[google.picker.Response.DOCUMENTS];
				var files_length = files.length;
				var dis = this; // so i can reach outside da function bellow

				console.log('The user selected ' + files_length + ' files.');

				// // for each file in files[] by length
				for (i=0; i < files_length; i++) {
					handleAFile(files[i]);
					// testAlert(files[i]);
				}

				// function testAlert (file) {
				// 	alert('da File is ' + file);
				// }

				// // authorized request to gapi for each file
				function handleAFile(file) {
					// this seems like it picks on the first document of an array
					// i bet i need to get the whole array of documents. here? 
						var id = file[google.picker.Document.ID],
						request = gapi.client.drive.files.get({
							fileId: id
						});

					request.execute(dis._fileGetCallback.bind(dis));
				}
				///////////////////////////////////////////////////////

				////////////////////////////////////// CURRENT VERSION. 
				// handles a single file
				// var file = data[google.picker.Response.DOCUMENTS][0], // this seems like it picks on the first document of an array
				// // i bet i need to get the whole array of documents. here? 
				// 	id = file[google.picker.Document.ID],
				// 	request = gapi.client.drive.files.get({
				// 		fileId: id
				// 	});

				// request.execute(this._fileGetCallback.bind(this));
				///////////////////////////////////////////////////


				////////////////////////////////////////////////////////// TESTES
				   // if (data.action == google.picker.Action.PICKED) {
				     // var fileId = data.docs[0].id;
				     // alert('The user selected: ' + fileId);
				   // }
				   

				   // FOR (i=0; i < )
				   // alert('user selected this many files ' + files_length);
				//////////////////////////////////////////////////////

			}
		},

		/// http://googleappsdeveloper.blogspot.com/2012/08/allowing-user-to-select-google-drive.html
		// function pickerCallback(data) {
		//    if (data.action == google.picker.Action.PICKED) {
		//      var fileId = data.docs[0].id;
		//      alert('The user selected: ' + fileId);
		//    }
		//  }

		/**
		 * Called when file details have been retrieved from Google Drive.
		 * @private
		 */
		_fileGetCallback: function(file) { // onSelect function declared in _new_google_upload_dan.html.erb 
			if (this.onSelect) {
				this.onSelect(file);
			}
		},

		/**
		 * Called when the Google Drive file picker API has finished loading.
		 * @private
		 */
		_pickerApiLoaded: function() {
			this.buttonEl.disabled = false;
		},

		/**
		 * Called when the Google Drive API has finished loading.
		 * @private
		 */
		_driveApiLoaded: function() {
			this._doAuth(true);
		},

		/**
		 * Authenticate with Google Drive via the Google JavaScript API.
		 * @private
		 */
		_doAuth: function(immediate, callback) {
			gapi.auth.authorize({
				client_id: this.clientId,
				scope: 'https://www.googleapis.com/auth/drive.readonly',
				immediate: immediate
			}, callback);
		}
	};
}());

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// // https://gist.github.com/Daniel15/5994054

// /**!
//  * Google Drive File Picker Example
//  * By Daniel Lo Nigro (http://dan.cx/)
//  */
// (function() {
// 	/**
// 	 * Initialise a Google Driver file picker
// 	 */
// 	var FilePicker = window.FilePicker = function(options) {
// 		// Config
// 		this.apiKey = options.apiKey;
// 		this.clientId = options.clientId;
		
// 		// Elements
// 		this.buttonEl = options.buttonEl;
		
// 		// Events
// 		this.onSelect = options.onSelect;
// 		this.buttonEl.addEventListener('click', this.open.bind(this));		
	
// 		// Disable the button until the API loads, as it won't work properly until then.
// 		this.buttonEl.disabled = true;

// 		// Load the drive API
// 		gapi.client.setApiKey(this.apiKey);
// 		gapi.client.load('drive', 'v2', this._driveApiLoaded.bind(this));
// 		google.load('picker', '1', { callback: this._pickerApiLoaded.bind(this) });
// 	}

// 	FilePicker.prototype = {
// 		/**
// 		 * Open the file picker.
// 		 */
// 		open: function() {		
// 			// Check if the user has already authenticated
// 			var token = gapi.auth.getToken();
// 			if (token) {
// 				this._showPicker();
// 			} else {
// 				// The user has not yet authenticated with Google
// 				// We need to do the authentication before displaying the Drive picker.
// 				this._doAuth(false, function() { this._showPicker(); }.bind(this));
// 			}
// 		},
		
// 		/**
// 		 * Show the file picker once authentication has been done.
// 		 * @private
// 		 */
// 		_showPicker: function() {
// 			var accessToken = gapi.auth.getToken().access_token;
// 			this.picker = new google.picker.PickerBuilder().
// 				addView(google.picker.ViewId.DOCUMENTS).
// 				setAppId(this.clientId).
// 				setOAuthToken(accessToken).
// 				setCallback(this._pickerCallback.bind(this)).
// 				build().
// 				setVisible(true);
// 		},
		
// 		/**
// 		 * Called when a file has been selected in the Google Drive file picker.
// 		 * @private
// 		 */
// 		_pickerCallback: function(data) {
// 			if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
// 				var file = data[google.picker.Response.DOCUMENTS][0],
// 					id = file[google.picker.Document.ID],
// 					request = gapi.client.drive.files.get({
// 						fileId: id
// 					});
					
// 				request.execute(this._fileGetCallback.bind(this));
// 			}
// 		},
// 		/**
// 		 * Called when file details have been retrieved from Google Drive.
// 		 * @private
// 		 */
// 		_fileGetCallback: function(file) {
// 			if (this.onSelect) {
// 				this.onSelect(file);
// 			}
// 		},
		
// 		/**
// 		 * Called when the Google Drive file picker API has finished loading.
// 		 * @private
// 		 */
// 		_pickerApiLoaded: function() {
// 			this.buttonEl.disabled = false;
// 		},
		
// 		/**
// 		 * Called when the Google Drive API has finished loading.
// 		 * @private
// 		 */
// 		_driveApiLoaded: function() {
// 			this._doAuth(true);
// 		},
		
// 		/**
// 		 * Authenticate with Google Drive via the Google JavaScript API.
// 		 * @private
// 		 */
// 		_doAuth: function(immediate, callback) {	
// 			gapi.auth.authorize({
// 				client_id: this.clientId + '.apps.googleusercontent.com',
// 				scope: 'https://www.googleapis.com/auth/drive.readonly',
// 				immediate: immediate
// 			}, callback);
// 		}
// 	};
// }());


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// To download the selected file with JS, use this:

// function downloadFile(file, callback) {
//   if (file.downloadUrl) {
//     var accessToken = gapi.auth.getToken().access_token;
//     var xhr = new XMLHttpRequest();
//     xhr.open('GET', file.downloadUrl);
//     xhr.setRequestHeader('Authorization', 'Bearer ' + accessToken);
//     xhr.onload = function() {
//       callback(xhr.responseText);
//     };
//     xhr.onerror = function() {
//       callback(null);
//     };
//     xhr.send();
//   } else {
//     callback(null);
//   }
// }
// Seen in the examples here: https://developers.google.com/drive/web/manage-downloads





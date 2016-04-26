# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

#james' document conversion init
#Isaac added :doc because server was complaining about a missing argument
Mime::Type.register 'application/vnd.ms-word', :msword

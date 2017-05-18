require 'converter-machine.rb'
module WorksHelper

  include ConverterMachine

  def work_owner? work
    logged_in? and work.user_id == current_user.id
  end

  def working_title work
    if work.name.present?
      work.name
    else
      work.file_name
    end
  end

  def working_author project
      if project.anonymouse?
        raw '<span class="works-show-author-name">' + project.author_name + '</span>'.html_safe
      else
        link_to project.user do
          # raw '<span class="works-show-user-name">' + work.project.author_name + '</span>'.html_safe
          return link_to project.author_name, project.user
        end
      end
  end

  def diff_compare_name(id1, id2)
    work1_name = Work.find(id1).name
    work2_name = Work.find(id2).name
    return work1_name + ' / ' + work2_name
  end

  ### This is the only place this exists. ???  ###
  # def pinky_for work
  #   if work.docordocx? || work.markdown? || work.type_html? || work.latex?
  #     markdown(work.file_content_md) if work.file_content_md

  #   elsif work.plain_text? || work.type_rtf? || work.powerpoint? || work.spreadsheet? || work.open_office? || work.i_works?
  #     content_tag('pre', work.file_content_text)

  #   elsif work.pdf?
  #     image_tag work.document_url(:png_thumb), class: "shadowy-figure shadowy-figure-image thumb"

  #   elsif work.image?
  #     image_tag work.document_url(:thumb), class: "shadowy-figure shadowy-figure-image thumb"

  #   end
  # end


  ##### handle this in model after_create #######
  # Receives raw html from uploaded docx/doc or Google Drive response file contents.
  # Parses and removes interfering stuff, !DOCTYPE, <head>, <style>, <meta> elements as well as all class attributes.
  # Returns raw html.
  def presentable_html(html)
    # sanitize edited, tags: %w(body p span a h1 h2 h3 h4 h5 h6 ul ol li) if work.file_content_html %> -->
      # doc = Nokogiri::HTML(html_junk)
      # body = doc.at_xpath("//body")
      # body.css('*').remove_attr('class')
      # edited = body.to_html
    return raw html
  end

  # handed word object, then we'll use work model methods to check for content type.
  def pretty_content_type(work)
    if work.source_from == 'google_drive'
      return image_tag('Google-Drive-Icon.png', height: '10')
    else
      # this will now almost surely get bypassed in favor of picture above
      if !work.document.file  # there is not associated file, thus no file_name to split
                              # most likely (for now) a google drive doc
        a = work.content_type.split('/').last # ie 'text/html'
        return a.split('.').last if a.include? '.'
        a
      # or it will be a normal local upload, in which case we'll handle with splitting original file name
      else
        if !work.file_name.nil? 
          if work.file_name.include? '.' and work.file_name.split('.').size > 1 # ie essay.docx
            return work.file_name.split('.').last 
          end
        end

        if !work.content_type.nil?
          a = work.content_type.split('/').last
          return a.split('.').last if a.include? '.'
        end
        
        return a
      end
    end
  end

  def pretty_doc_type_img(work, height, mod)

    # cases:
      # imported from Google Drive
      # uploaded
        # pdf
        # doc/docx, ie Word
        # md
        # txt
        # img

    if work.source_from == 'google_drive'
      image_tag('Google-Drive-Icon.png', height: "16") #{height}
    elsif work.pdf?
      content_tag :span, '', :class => "fa fa-file-pdf-o fa-#{mod}", :style => "height: #{height}"
    elsif work.docordocx?
      content_tag :span, '', :class => "fa fa-file-word-o fa-#{mod}", :style => "height: #{height}"
    elsif work.image?
      content_tag :span, '', :class => "fa fa-file-image-o fa-#{mod}", :style => "height: #{height}"
    elsif work.type_html?
      content_tag :span, '', :class => "fa fa-file-code-o fa-#{mod}", :style => "height: #{height}"
    else
      content_tag :span, '', :class => "fa fa-file-text-o fa-#{mod}", :style => "height: #{height}"
    end

  end

  # this might be useful for rendering raw html from converted DOCs. currently not in use.
  def html_escape(text)
    Rack::Utils.escape_html(text)
  end

  def markdown(string, images=true)
    renderable = string
    if !images
      markdown = ConverterMachine::Standard.markdowner_no_images
    else
      markdown = ConverterMachine::Standard.markdowner
    end
    return markdown.render(renderable).html_safe if renderable.present?
    return " " if renderable.nil?
  end

  def first_page_url(work, version) # version -> %w ( 160x 700x 1000x )

    work_is_called = "#{work.file_name.chomp(work.document.file.extension)[0..-2]}_1.jpg"
    return "/uploads/work/document/#{work.user.uuid.to_s}/#{work.slug}/#{version}/#{work_is_called}"

    # work_is_called = "#{work.file_name.chomp(work.document.file.extension)[0..-2]}_1.jpg"
    # return "/uploads/work/document/#{work.user.uuid.to_s}/#{work.slug}/#{version}/#{work_is_called}"
  end


end

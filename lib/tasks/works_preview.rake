namespace :works do
  desc 'create preview images for all works with file_content_md'
  task :init_previews => :environment do

    # excludes images, hopefully ONLY images
    # Work#create_preview_png should be indempotent
    Work.where.not(file_content_md: nil).each do |work|

      if work.has_preview?
        puts "#{work.id} preview exists, skipping"
        next
      end
      puts "creating preview for work #{work.id}"

      if work.create_preview_png and work.has_preview?
        puts "saved #{work.id} -> #{work.preview_url}"
      else
        puts "shit #{work.id}"
      end
    end
  end

  task :recreate_preview_versions => :environment do
    Work.where.not(file_content_md: nil).each do |work|
      if work.has_preview?
        puts "recreating version for work #{work.id}"
        work.preview.recreate_versions!
        work.save
      end
    end
  end
end

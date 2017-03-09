namespace :tags do
  desc 'migrate tags from associations acts_as_taggable_on to array columns'
  task :migrate => :environment do

    Work.all.each do |work|
      if work.contexts.any?
        work.contexts.each do |context|
          work.tags.push(context.name)
        end
      end
      if work.contents.any?
        work.contents.each do |content|
          work.tags.push(content.name)
        end
      end
      if work.save
        puts "Saved #{work.name} with tags #{work.tags}"
      else
        puts "Couldn't save #{work.name} with tags #{work.tags}"
      end
    end

    Project.all.each do |work|
      if work.contexts.any?
        work.contexts.each do |context|
          work.tags.push(context.name)
        end
      end
      if work.contents.any?
        work.contents.each do |content|
          work.tags.push(content.name)
        end
      end
      if work.save
        puts "Saved #{work.name} with tags #{work.tags}"
      else
        puts "Couldn't save #{work.name} with tags #{work.tags}"
      end
    end

  end
end

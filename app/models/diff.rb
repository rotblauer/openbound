class Diff < ActiveRecord::Base
  belongs_to :project

  counter_culture :project

  validates :project_id, presence: true
  validates :work1, presence: true
  validates :work2, presence: true

  


   # ----------- another init for diff changeup ------------ #
  
  def diffyable
    # add appropriate diff column data for diff.right and diff.left and update other attrs to the Diffy way®

    w1id = self.work1
    w2id = self.work2
    w1work = Work.find(w1id)
    w2work = Work.find(w2id)
    w1md = w1work.file_content_md
    w2md = w2work.file_content_md
    w1txt = w1work.file_content_text
    w2txt = w2work.file_content_text

    html = Diffy::Diff.new(w1md, w2md).to_s(:html)
    md = Diffy::Diff.new(w1md, w2md).to_s
    text = Diffy::Diff.new(w1txt, w2txt).to_s
    
    lucy = Diffy::SplitDiff.new(w1md, w2md, :format => :html).left
    recha = Diffy::SplitDiff.new(w1md, w2md, :format => :html).right

    html.force_encoding("UTF-8").scrub!
    md.force_encoding("UTF-8").scrub!
    text.force_encoding("UTF-8").scrub!

    lucy.force_encoding("UTF-8").scrub!
    recha.force_encoding("UTF-8").scrub!

    self.update_attributes(left: lucy, right: recha, diff_md: md, diff_html: html, diff_text: text)
    self.save
  end
  
end

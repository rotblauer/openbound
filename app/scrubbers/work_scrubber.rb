class WorkScrubber < Rails::Html::PermitScrubber
  def allowed_node?(node)
    !%w(form script comment blockquote).include?(node.name)
  end

  def skip_node?(node)
    node.text?
  end

  def scrub_attribute?(name)
    name == 'style'
  end
end
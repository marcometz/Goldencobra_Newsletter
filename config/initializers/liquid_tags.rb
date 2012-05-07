class Newsletterform < Liquid::Tag
  #include ActionController::RequestForgeryProtection
  
  def initialize(tag_name, message, tokens)
       super
       @message = message
  end
  
  def render(context)
      ActionController::Base.new.render_to_string(:partial => 'goldencobra_newsletter/newsletters/register', :layout => false, :locals => {:newsletter_tag => @message})
  end
end

Liquid::Template.register_tag('newsletter_form', Newsletterform)



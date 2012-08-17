ActiveAdmin.register GoldencobraNewsletter::NewsletterCampaign, as: "Newsletter Campaign" do
  menu :parent => "Newsletter", label: I18n.t("goldencobra_newsletter/newsletter_campaign", scope: [:activerecord, :models], count: 3), :if => proc{can?(:update, GoldencobraNewsletter::NewsletterCampaign)}

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.actions
    if f.object.new_record?
      f.inputs "Kampagne" do
        f.input :title, label: "Name der Kampagne", hint: "Zur Unterscheidung verschiedener Kampagnen"
        f.input :subject, hint: "Der Betreff der E-Mail. Wird vom Empfaenger gelesen."
        f.input :from, label: "Absender", hint: "Erscheint als Absender beim Empfaenger"
      end
    else
      f.inputs "Layout" do
        f.input :title, label: "Name der Kampagne", hint: "Zur Unterscheidung verschiedener Kampagnen"
        f.input :subject, hint: "Der Betreff der E-Mail. Wird vom Empfaenger gelesen."
        f.input :from, label: "Absender", hint: "Erscheint als Absender beim Empfaenger"
        f.input :layout, hint: "Schreiben Sie hier HTML Code hinein"
      end
    end
    f.actions
  end

  GoldencobraNewsletter::NewsletterRegistration.all.map{|nlr| nlr.newsletter_tags.strip unless nlr.newsletter_tags.blank?}.flatten.uniq!.each do |tag|
    batch_action "An Empfaenger '#{tag}' schicken", confirm: "Sicher?" do |campaign_id|
      GoldencobraNewsletter::NewsletterCampaign.find(campaign_id) do |campaign|
        recipients = GoldencobraNewsletter::NewsletterRegistration.where('newsletter_tags LIKE ?', tag).all.map{|a| a.user}
        GoldencobraNewsletter::NewsletterMailer.send_campaign_email(recipients, campaign).deliver
      end
      redirect_to :action => :index, :notice => "Kampagne wurden durchgefuehrt"
    end
  end
end

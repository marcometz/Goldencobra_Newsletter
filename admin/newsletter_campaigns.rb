# Encoding: UTF-8
ActiveAdmin.register GoldencobraNewsletter::NewsletterCampaign, as: "Newsletter Campaign" do
  menu parent: "Newsletter", label: I18n.t("goldencobra_newsletter/newsletter_campaign", scope: [:activerecord, :models], count: 3), if: proc{can?(:update, GoldencobraNewsletter::NewsletterCampaign)}

  form html: { enctype: "multipart/form-data" }  do |f|
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
        f.input :plaintext, hint: "Schreiben Sie hier den Inhalt der Nur-Text E-Mail"
        f.input :selected_tags_display, hint: "An welche Newsletter Tags soll die Kamapgne versandt werden?",
          as: :select, collection: GoldencobraNewsletter::NewsletterRegistration.all.map{|nlr| nlr.newsletter_tags.split(",").map{|s|s.strip} if nlr.newsletter_tags.present?}.flatten.uniq.compact,
          input_html: { class: 'chzn-select', style: 'width: 70%;', 'data-placeholder' => 'Newsletter Tags', multiple: true }
      end
    end
    f.actions
  end

  batch_action "Kampagne verschicken", confirm: "Sicher?" do |campaign_id|
    GoldencobraNewsletter::NewsletterCampaign.find(campaign_id).each do |campaign|
      recipients = []
      if campaign.selected_tags.present?
        campaign.selected_tags.split(",").each do |tag|
          recipients << GoldencobraNewsletter::NewsletterRegistration.where('newsletter_tags LIKE ?', "%#{tag}%").includes(:user).all.map{|a| a.user}
        end
        recipients = recipients.flatten.uniq.compact
      end
      if recipients.count > 0
        recipients.each do |user|
          if user.present? && user.email.present?
            GoldencobraNewsletter::NewsletterMailer.send_campaign_email(user, campaign).deliver
          end
        end
      end
    end
    flash[:notice] = "Kampagne wurde durchgeführt"
    redirect_to action: :index
  end
end

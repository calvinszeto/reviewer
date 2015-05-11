class DigestionMailer < ActionMailer::Base
  default from: "szeto.calvin@gmail.com"

  def digestion_email(digestion, notes)
    @notes = notes
    mail(to: digestion.email, subject: "Your Review Digest for #{Date.today.to_s(:long_ordinal)}")
  end
end

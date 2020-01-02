require "rails_helper"

RSpec.describe PasswordMailer, type: :mailer do
  describe "forget_email" do
    let(:user) { create(:confirmed_user) }
    let(:mail) { PasswordMailer.forget_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Authna: Reset Password")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([ENV["devise_mailer_from_address"]])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end

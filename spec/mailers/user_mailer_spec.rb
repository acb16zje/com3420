require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "welcome" do
    let(:mail) { UserMailer.welcome }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "booking_approved" do
    let(:mail) { UserMailer.booking_approved }

    it "renders the headers" do
      expect(mail.subject).to eq("Booking approved")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "asset_due" do
    let(:mail) { UserMailer.asset_due }

    it "renders the headers" do
      expect(mail.subject).to eq("Asset due")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "asset_overdue" do
    let(:mail) { UserMailer.asset_overdue }

    it "renders the headers" do
      expect(mail.subject).to eq("Asset overdue")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end

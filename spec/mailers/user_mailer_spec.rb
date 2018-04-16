require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  b = FactoryBot.create(:booking_today_all_day)

  describe "welcome" do

    let(:mail) { UserMailer.welcome(b.item.user) }

    it "renders the headers" do
      expect(mail.subject).to eq("AMRC - Welcome: #{b.user.givenname} #{b.user.sn}")
      expect(mail.to).to eq(["#{b.user.email}"])
      expect(mail.from).to eq(["no-reply@sheffield.ac.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("#{b.user.givenname}")
    end
  end

  describe "booking_approved" do

    let(:mail) { UserMailer.booking_approved(b) }

    it "renders the headers" do
      expect(mail.subject).to eq("AMRC - Booking Confirmed: #{b.item.name}")
      expect(mail.to).to eq(["#{b.user.email}"])
      expect(mail.from).to eq(["no-reply@sheffield.ac.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("#{b.item.name}")
    end
  end

  describe "booking_ongoing" do

    let(:mail) { UserMailer.booking_ongoing(b) }

    it "renders the headers" do
      expect(mail.subject).to eq("AMRC - Booking Started: #{b.item.name}")
      expect(mail.to).to eq(["#{b.user.email}"])
      expect(mail.from).to eq(["no-reply@sheffield.ac.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("#{b.item.name}")
    end
  end

  describe "user_booking_requested" do

    let(:mail) { UserMailer.user_booking_requested(b) }

    it "renders the headers" do
      expect(mail.subject).to eq("AMRC - Booking Recieved: #{b.item.name}")
      expect(mail.to).to eq(["#{b.user.email}"])
      expect(mail.from).to eq(["no-reply@sheffield.ac.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("#{b.item.name}")
    end
  end

  describe "manager_booking_requested" do

    let(:mail) { UserMailer.manager_booking_requested(b) }

    it "renders the headers" do
      expect(mail.subject).to eq("AMRC - Booking Requested: #{b.item.name}")
      expect(mail.to).to eq(["#{b.item.user.email}"])
      expect(mail.from).to eq(["no-reply@sheffield.ac.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("#{b.item.name}")
    end
  end

  describe "manager_asset_returned" do

    let(:mail) { UserMailer.manager_asset_returned(b) }

    it "renders the headers" do
      expect(mail.subject).to eq("AMRC - Item Returned: #{b.item.name}")
      expect(mail.to).to eq(["#{b.item.user.email}"])
      expect(mail.from).to eq(["no-reply@sheffield.ac.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("#{b.item.name}")
    end
  end

  describe "manager_asset_issue" do

    let(:mail) { UserMailer.manager_asset_returned(b.user, b.item) }

    it "renders the headers" do
      expect(mail.subject).to eq("AMRC - Item Issue: #{b.item.name}")
      expect(mail.to).to eq(["#{b.item.user.email}"])
      expect(mail.from).to eq(["no-reply@sheffield.ac.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("#{b.item.name}")
    end
  end

  describe "manager_booking_cancelled" do

    let(:mail) { UserMailer.manager_booking_cancelled(b) }

    it "renders the headers" do
      expect(mail.subject).to eq("AMRC - Booking Cancelled: #{b.item.name}")
      expect(mail.to).to eq(["#{b.item.user.email}"])
      expect(mail.from).to eq(["no-reply@sheffield.ac.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("#{b.item.name}")
    end
  end

  describe "booking_rejected" do

    let(:mail) { UserMailer.booking_rejected(b) }

    it "renders the headers" do
      expect(mail.subject).to eq("AMRC - Booking Rejected: #{b.item.name}")
      expect(mail.to).to eq(["#{b.user.email}"])
      expect(mail.from).to eq(["no-reply@sheffield.ac.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("#{b.item.name}")
    end
  end

  describe "asset_due" do

    let(:mail) { UserMailer.asset_due(b) }

    it "renders the headers" do
      expect(mail.subject).to eq("AMRC - Return Due Soon: #{b.item.name}")
      expect(mail.to).to eq(["#{b.user.email}"])
      expect(mail.from).to eq(["no-reply@sheffield.ac.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("#{b.item.name}")
    end
  end

  describe "asset_overdue" do

    let(:mail) { UserMailer.asset_overdue(b)}

    it "renders the headers" do
      expect(mail.subject).to eq("AMRC - Late For Return: #{b.item.name}")
      expect(mail.to).to eq(["#{b.user.email}"])
      expect(mail.from).to eq(["no-reply@sheffield.ac.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("#{b.item.name}")
    end
  end

end

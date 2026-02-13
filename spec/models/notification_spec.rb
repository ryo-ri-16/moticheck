require "rails_helper"

RSpec.describe Notification, type: :model do
  let(:user) { create(:user) }
  let(:list) { create(:list, user: user) }

  describe "バリデーション" do
    subject { build(:notification, user: user, list: list) }

    it "重複なし" do
      create(:notification, user: user, list: list, kind: :reminder)

      duplicate = build(:notification, user: user, list: list, kind: :reminder)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:list_id]).to include("この通知は既に存在します")
    end
  end

  describe "enum" do
    it "定義されている" do
      expect(Notification.kinds.keys).to contain_exactly("reminder", "start")
    end
  end

  describe "scopes" do
    let!(:unread_notification) { create(:notification, user: user, list: list, kind: :reminder) }
    let!(:read_notification)   { create(:notification, user: user, list: list, kind: :start, read_at: 1.day.ago) }

    it ".unread returns unread notifications" do
      expect(Notification.unread).to include(unread_notification)
      expect(Notification.unread).not_to include(read_notification)
    end

    it ".read returns read notifications" do
      expect(Notification.read).to include(read_notification)
      expect(Notification.read).not_to include(unread_notification)
    end
  end

  describe "#mark_as_read!" do
    let(:notification) { create(:notification, user: user, list: list, read_at: nil) }

    it "sets read_at to current time" do
      travel_to Time.zone.parse("2026-02-13 10:00") do
        notification.mark_as_read!
        expect(notification.read_at).to eq(Time.current)
      end
    end
  end

  describe "#unread?" do
    it "returns true when read_at is nil" do
      notification = build(:notification, read_at: nil)
      expect(notification.unread?).to be true
    end

    it "returns false when read_at is present" do
      notification = build(:notification, read_at: Time.current)
      expect(notification.unread?).to be false
    end
  end
end

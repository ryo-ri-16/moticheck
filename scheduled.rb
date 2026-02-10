every 1.day, at: '4:00 am' do
  runner "CleanupGuestUsersJob.perform_later"
end

class GenerateListsJob < ApplicationJob
  queue_as :default

  def perform
    ListGenerator.run
  end
end

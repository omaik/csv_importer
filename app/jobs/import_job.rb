class ImportJob
  include Sidekiq::Worker

  def perform(*_)
    puts "Hello"
  end
end

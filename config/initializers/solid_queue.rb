# config/initializers/solid_queue.rb

# SolidQueue::Record が queue DB を使うよう指定
SolidQueue::Record.connects_to database: { writing: :queue }

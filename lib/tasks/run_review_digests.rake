namespace :run do
  desc "Run any passed review digests for all users"
  task :review_digests => :environment do
    puts "Starting Review Digest Job"
    User.all.each do |user|
      puts "Analyzing digests for #{user.email}"
      user.run_passed_review_digests
    end
    puts "Finished Review Digest Job"
  end
end
namespace :run do
  desc "Run any passed review digests for all users"
  task :review_digests => :environment do
    User.all.map(&:run_passed_review_digests)
  end
end
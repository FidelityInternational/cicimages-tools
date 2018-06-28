require_relative 'support/lint'

desc 'lint project shellscripts'
task :shellcheck do
  Lint.run_linter(:shellcheck)
end

desc 'lint project ruby source code'
task :rubocop do
  Lint.run_linter(:rubocop)
end

task :coverage_check do
  SimpleCov.minimum_coverage 80
end

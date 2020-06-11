@api_dir = 'api'
@api_dst = "#{@api_dir}/index.html"

desc 'Build API documentation.'
task :api => @api_dst

file @api_dst => FileList['lib/**/*.rb'].include('LICENSE') do
  inner_task_name = 'api:yard'

  require 'yard'
  require 'yard/rake/yardoc_task'
  YARD::Rake::YardocTask.new(inner_task_name) do |yardoc|
    yardoc.options = [
      '--output-dir', @api_dir,
      '--title', @project_module.inspect,
      '--readme', 'LICENSE',
      '--no-private'
    ]
  end

  Rake::Task[inner_task_name].invoke
end

CLEAN.include '.yardoc'
CLOBBER.include @api_dir

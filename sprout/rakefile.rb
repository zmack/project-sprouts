require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/rubyforgepublisher'
require 'fileutils'
require 'lib/sprout'
require 'lib/sprout/version'

PROJECT                 = "sprout"
NAME                    = "sprout"
SUMMARY                 = "Sprouts is an open-source, cross-platform project generation, configuration and build tool."
GEM_VERSION             = Sprout::VERSION::STRING
AUTHOR                  = "Luke Bayes"
EMAIL                   = "projectsprouts@googlegroups.com"
HOMEPAGE                = "http://www.projectsprouts.org"
DESCRIPTION             = "Sprouts take the tedium and frustration out of creating new programming projects by automatically installing and configuring external tools, libraries, commands and build tasks."
HOMEPATH                = "http://#{PROJECT}.rubyforge.org"
RELEASE_TYPES           = ["gem"]
PKG_LIST                = FileList['[a-zA-Z]*',
                                  'samples/**/*',
                                  'bin/**/*',
                                  'lib/**/*',
                                  'doc/*'
                                  ]
PKG_LIST.exclude('.svn')
PKG_LIST.exclude('artifacts')
PKG_LIST.each do |file|
  task :package => file
end

spec = Gem::Specification.new do |s|
    s.summary             = SUMMARY
    s.description         = DESCRIPTION
    s.name                = NAME
    s.version             = GEM_VERSION
    s.author              = AUTHOR
    s.email               = EMAIL
    s.homepage            = HOMEPAGE
    s.rubyforge_project   = PROJECT
    s.require_path        = 'lib'
    s.bindir              = 'bin'
    s.has_rdoc            = true
    s.rdoc_options        << '--title' << 'Project Sprouts -- Core Documentation'
    s.rdoc_options        << '--main' << 'Sprout::Sprout'
    s.rdoc_options        << '--line-numbers' << '--inline-source'
    s.rdoc_options        << '--charset' << 'utf-8'
    s.rdoc_options        << '-i' << '.'
    s.files               = PKG_LIST.to_a
    s.executables         = ['sprout']
    s.default_executable  = 'sprout'

    s.add_dependency('rubyzip', '>= 0.9.1')
    s.add_dependency('archive-tar-minitar', '>= 0.5.1')
    s.add_dependency('rubigen', '= 1.3.3')
    s.add_dependency('net-sftp')
    s.add_dependency('net-ssh')
    
    if(RUBY_PLATFORM.match('mswin'))
      s.add_dependency('win32-open3', '0.2.5')
    else
      s.add_dependency('open4', '>= 0.9.6')
    end
end

Rake::GemPackageTask.new(spec) do |pkg|
end

Rake::RDocTask.new do |t|
  t.rdoc_files.include(['doc/*', 'lib/*.rb', 'lib/**/*.rb', 'MIT-LICENSE'])
  t.title    = "Project Sprouts -- Core Documentation"
  t.rdoc_dir = 'rdoc'
  t.main     = 'Sprout::Sprout'
  t.options << '--line-numbers' << '--inline-source'
  t.options << '--charset' << 'utf-8'
  t.options    << '-i .'
end

CLEAN.add('rdoc')
require File.dirname(__FILE__) + '/script/build_helpers'

#task :release => :release_rubyforge

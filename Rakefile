require 'rake'
require 'erb'

def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end

def brew(pkg, flags=[])
  cmd = "brew install #{pkg} #{flags.join(' ')}"
  system cmd
end

def log(msg)
  puts "- #{msg}"
end

CONFIG_DIR = File.expand_path(File.dirname(__FILE__))

namespace :setup do
  desc "install homebrew packages"
  task :osx do
    brew("vim", %w(--with-ruby --with-python --with-lua))
    brew("postgresql")
    brew("weechat")
    brew("ffmpeg")
    brew("imagemagick")
  end

  desc "source rc files"
  task :source_rc do
    {
      "vimrc" => "~/.vimrc"
    }.each do |file, rcfile|
      fullpath = File.expand_path(rcfile)
      configline = "source #{CONFIG_DIR}\/#{file}"
      unless File.readlines(fullpath).grep(/^#{configline}/).size > 0
        File.open(fullpath, "a+") {|f| f << configline }
      end
    end
  end

  desc "symlink some files"
  task :symlink do
    %w(zshrc gitconfig hgrc irbrc ackrc ctags).each do |filename|
      link_file(filename)
      log("Linked #{filename}")
    end
  end

  desc "setup oh-my-zsh"
  task :oh_my_zsh do
    system("if [[ ! -d ~/.oh-my-zsh ]]; then git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh ; fi")
  end
end

desc "setup user configs"
task :setup => ["setup:osx", "setup:source_rc", "setup:symlink", "setup:oh_my_zsh"]

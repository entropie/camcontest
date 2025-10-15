require "fileutils"
require "open3"
require File.expand_path("~/Source/trompie/lib/trompie.rb")

if ARGV.include?("--debug")
  Trompie.debug = true
  ARGV.delete("--debug")
end

BASEDIR = File.join(File.dirname(File.expand_path(__FILE__)), "..")
INTERVAL = 3
STEPS = 3

TMPDIR = File.join(BASEDIR, ".work")

# start fresh
FileUtils.rm_rf(TMPDIR)
FileUtils.mkdir_p(TMPDIR)


def llm_describe_images(prmpt, files: [])
  # send files with prompt to llm
  llmargs = ["prompt", "\"#{prmpt}\"", "-m", "llama-server-vision", "-n"]
  arguments = files.map{ |f| ["-a", f] }

  stdout_str, status = Open3.capture2("llm", *(llmargs + arguments).flatten)
end

def prompt(pfile = "prompt.txt")
  @prompt ||= File.readlines(File.join(BASEDIR, pfile)).join
end


require_relative "camcontest/result"

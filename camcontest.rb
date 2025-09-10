#!/usr/bin/env ruby

require "fileutils"
require "open3"
require File.expand_path("~/Source/trompie/lib/trompie.rb")

$debug = true if ARGV.include?("--debug")


BASEDIR = File.dirname(File.expand_path(__FILE__))
INTERVAL = 30
STEPS = 3

TMPDIR = File.join(BASEDIR, "work")

# start fresh
FileUtils.rm_rf(TMPDIR)
FileUtils.mkdir_p(TMPDIR)

ha = Trompie::HA.new
ret = []

1.upto(STEPS) do |step|
  file = File.join(TMPDIR, "file-#{"%02i" % step}-#{Time.now.strftime("%Y%d%m-%H%M%S")}.jpg")
  fc = ha.make_req(:camera_proxy, "camera.livingroom_sw", raw: true)
  File.open(file, "w+") { |fp| fp.write(fc) }
  ret << file
  sleep INTERVAL if STEPS != step
end

PROMPT = File.readlines(File.join(BASEDIR, "prompt.txt")).join

llmargs = ["prompt", "\"#{PROMPT}\"", "-m", "llama-server-vision"]
arguments = ret.map{ |f| ["-a", f] }

stdout_str, status = Open3.capture2("llm", *(llmargs + arguments).flatten)

File.open(File.join(TMPDIR, "gemma-evaluation.txt"), "w+" ) { |fp| fp.puts(stdout_str) }

combined = `nix-shell -p imagemagick --run 'cd #{BASEDIR} && ./report.sh'`

puts combined, stdout_str

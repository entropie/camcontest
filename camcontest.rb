#!/usr/bin/env ruby

require "fileutils"
require "open3"
require File.expand_path("~/Source/trompie/lib/trompie.rb")

$debug = true if ARGV.include?("--debug")


BASEDIR = File.dirname(File.expand_path(__FILE__))
INTERVAL = 120
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

PROMPT = %Q|Analyze the 3 provided images from a surveillance camera showing 1-3 dogs. Compare the images with each other to determine the activity level of the dogs, focusing exclusively on signs of nervousness, making noise, or mischief. Lying dogs are considered chill. Ignore humans.

Rate the activity on a scale from 0 (no activity, all dogs are lying still) to 10 (high activity, multiple dogs are interacting). Your response must be a single sentence that starts with 'Activity level YOURRATING'. Only add a brief description if the level is above 5. BE VERY CONSERVATIVE|


llmargs = ["prompt", "'#{PROMPT}'", "-m", "llama-server-vision"]
arguments = ret.map{ |f| ["-a", f] }


stdout_str, status = Open3.capture2("llm", *(llmargs + arguments).flatten)

File.open(File.join(TMPDIR, "gemma-evaluation.txt"), "w+" ) { |fp| fp.puts(stdout_str) }

combined = `nix-shell -p imagemagick --run 'cd #{BASEDIR} && ./report.sh'`

puts combined, stdout_str

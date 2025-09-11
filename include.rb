require "fileutils"
require "open3"
require File.expand_path("~/Source/trompie/lib/trompie.rb")

if ARGV.include?("--debug")
  Trompie.debug = true
  ARGV.deletee("--debug")
end

BASEDIR = File.dirname(File.expand_path(__FILE__))
INTERVAL = 3
STEPS = 3

TMPDIR = File.join(BASEDIR, "work")

# start fresh
FileUtils.rm_rf(TMPDIR)
FileUtils.mkdir_p(TMPDIR)

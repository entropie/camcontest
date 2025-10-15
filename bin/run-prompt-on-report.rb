#!/usr/bin/env ruby

require_relative "../lib/camcontest"

prompt = 
  if !STDIN.tty? && !STDIN.eof?
    STDIN.read.strip
  else
    File.read(File.join(BASEDIR, "prompt.txt"))
  end

target_report_directories = ARGV

abort "#{$0} <*report directories>" if target_report_directories.empty?

files = target_report_directories.map { |tdir| Dir.glob("%s/file-*.jpg" % tdir) }.sort.flatten

stdout_str, status = llm_describe_images(prompt, files: files)

# generate report
rep = Report.new(files, prompt, stdout_str.strip)
rep.save

puts rep.output_file, stdout_str

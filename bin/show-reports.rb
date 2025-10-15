#!/usr/bin/env ruby

require_relative "../lib/camcontest"

using TermColors

path = ARGV.join
path = path.empty? ? "." : path
path = File.expand_path(path)

reports = Dir.glob("%s/*.json" % path).sort.map { |json_report_file|
  JSON.parse(File.read(json_report_file))
}


reports.each do |report|
  puts "%s\t%s" % [ "level".yellow, report["level"] ]
  puts "%s\n\t%s" % [ "file".yellow, report["result_file"] ]
  prompt = report["prompt"].gsub(/(.{1,60})(?:\s|\Z)|(.{60})/, "\\1\\2\n")
  puts "%s\n\t%s" % ["prompt".yellow, prompt]
  puts "%s\n\t%s" % ["result".yellow, report["llm_result"]]
  puts ("-" * 60).blue
end


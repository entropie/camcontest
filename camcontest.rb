#!/usr/bin/env ruby

require_relative "include"

ha = Trompie::HA.new
files = []

# cleanup
FileUtils.rm_rf(TMPDIR)
FileUtils.mkdir_p(TMPDIR)


# get files from ha
1.upto(STEPS) do |step|
  file = File.join(TMPDIR, "file-#{"%02i" % step}-#{Time.now.strftime("%Y%d%m-%H%M%S")}.jpg")
  fc = ha.make_req(:camera_proxy, "camera.livingroom_sw", raw: true)
  File.open(file, "w+") { |fp| fp.write(fc) }
  files << file
  sleep INTERVAL if STEPS != step
end

stdout_str, status = llm_describe_images(prompt, files: files)


# generate report
rep = Report.new(files, prompt, stdout_str.strip)
rep.workdir = "/home/mit/camcontest/report-#{Time.now.strftime('%Y%m%d%H%M')}"
rep.save

puts rep.output_file, stdout_str

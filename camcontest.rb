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

level = stdout_str[/Level\s+(\d+)/, 1].to_i

#if level > 5
  # generate report
  rep = Report.new(files, prompt, stdout_str.strip)
  rep.workdir = "/home/mit/camcontest/report-#{Time.now.strftime('%Y%m%d%H%M')}-#{"%03d" % level}"
  rep.save

  Trompie::MMQTT.new.
    submit("test/synopsis/image", File.binread(rep.output_file), retain: true, qos: 0)

  if level > 6
  end
  puts rep.output_file, stdout_str
#end




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


def llm_describe_images(prmpt, files: [])
  # send files with prompt to llm
  llmargs = ["prompt", "\"#{prmpt}\"", "-m", "llama-server-vision"]
  arguments = files.map{ |f| ["-a", f] }

  stdout_str, status = Open3.capture2("llm", *(llmargs + arguments).flatten)
end

def prompt(pfile = "prompt.txt")
  @prompt ||= File.readlines(File.join(BASEDIR, pfile)).join
end

class Report
  def initialize(files, prompt, text, resizeX: 640, resizeY: 480)
    @files, @prompt, @text, @resizeX, @resizeY = files, prompt, text, resizeX, resizeY
    @version = 0
  end

  def output_file=(filename)
    @filename = filename
  end

  def result=(str)
    @result = str
  end

  def result
    @text
  end

  def level
    result[/Level\s+(\d+)/, 1].to_i
  end
  
  def workdir=(wd)
    @workdir = wd
  end

  def workdir
    @workdir ||= File.dirname(File.expand_path(@files.first))
  end
  
  def output_file
    @output_file ||=
      begin
        mkfilename = -> () { 
          File.join(workdir, "report-version-#{"%03d" % @version}.jpg")
        }
        filename = mkfilename.call
        while File.exist?(filename)
          @version += 1
          filename = mkfilename.call
        end
        filename
      end
  end

  def save_json
    prompt_file = File.join(workdir, "prompt-version-#{"%03d" % @version}.json")
    jhash = {
      files: @files,
      result_file: output_file,
      prompt: @prompt,
      llm_result: @text,
      level: level
    }
    File.open(prompt_file, "w+"){ |fp| fp.puts(jhash.to_json) }
  end

  def save
    unless File.exist?(workdir)
      FileUtils.cp_r(TMPDIR, workdir)
    end
    stdout_str, status = Open3.capture2("magick", *magick_arguments)
    save_json
    return stdout_str, status
  end

  def copy_or_save
  end

  def magick_arguments
    cmd = [
      "-background", "black",
      "-fill", "white",
      "-stroke", "black",
      "-strokewidth", "0",
      "-font", "DejaVu-Sans",
      "-pointsize", "24",
      "-size", "#{@resizeX}x",
      "-gravity", "Center",
      "caption:#{result}",
      *@files,
      "-resize", "#{@resizeX}x#{@resizeY}",
      "-append",
      output_file
    ]

  end
end

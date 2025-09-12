# CameraContinuedEstimation

* *camcontest.rb* saves STEPS images with INTERVAL delay in *./work*
  and submits them via `llm` to llama.cpp to get the activity level of
  the dogs comparing the images
  
* *report.sh* combines images and banners them with the estimation
  text from the *llm* and saves them (for debugging)


## example


```bash
 Θ rm -rf ~/camcontest && mkdir ~/camcontest
 Θ nix-shell -p imagemagick --run /home/mit/Source/camcontest/camcontest.rb
/home/mit/camcontest/report-202509120403/report--level-1-version-00.jpg
Level 5 | The dogs are shifting positions slightly, with one dog mostly lying down and another moving towards
 Θ ls /home/mit/camcontest/report-202509120403
file-01-20251209-040333.jpg  file-02-20251209-040336.jpg  file-03-20251209-040340.jpg  report--level-1-version-00.jpg
 Θ echo "describe" | nix-shell -p imagemagick --run "/home/mit/Source/camcontest/run-prompt-on-report.rb /home/mit/camcontest/report-202509120403/"
/home/mit/camcontest/report-202509120403/report--level-1-version-01.jpg
Here's a description of the images you sent:

**Overall Impression:**

The images appear to be taken from a security camera, showing a room that is cluttered and appears to be a home office or workspace. There's a significant amount of laundry and dog bedding scattered around, suggesting a busy or relaxed atmosphere.

**Key Elements:**

* **Subject:** A man is sitting at a desk, seemingly working or relaxing. He appears to be wearing a light-colored sweater.
* **Dogs:** There are two dogs lying on the floor, one brown and one lighter-colored. They look comfortable and relaxed.
* **Furniture and Equipment:** There’s a desk chair, a laptop, a small table, and what looks like a printer or scanner. 
* **Background:** The background shows a wall with radiators and a portion of a doorway leading to another room.
 Θ ls /home/mit/camcontest/report-202509120403
file-01-20251209-040333.jpg  file-02-20251209-040336.jpg  file-03-20251209-040340.jpg  report--level-1-version-00.jpg  report--level-1-version-01.jpg
```

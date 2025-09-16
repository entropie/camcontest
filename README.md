# CameraContinuedEstimation

* *camcontest.rb* saves STEPS images with INTERVAL delay in *./work*
  and submits them via `llm` to llama.cpp to get the activity level of
  the dogs comparing the images. It generates a report.
  
* *run-prompt-on-report.rb* <*report-directory*> uses stdin PROMPT to
  generate new report image and saves it in same folder. This is to
  test other prompt on existing image sets.


# Motivation

We want to know when our dogs do shit while we not at home.

The GPU work does a Nvidia Jetson Orin Nano Super integrated GPU system with
8 gb shared (v)ram.

Right now iam testing [google/gemma-3n-E4B-it](https://huggingface.co/google/gemma-3n-E4B-it)
with `CTX=1024`. This is a text and vision model. The estimation of
the image(s) is usually done within 15 seconds.

LLM backend is @llama.cpp via shell cli [llm](https://github.com/simonw/llm).

## Example

Below example shows how to run the script.

* It fetches STEPS images with DELAY from the home assistant camera api
* runs `llm` with the images attached and `$(cat prompt.txt)`
* combines every input image and headers it with the llm output and
* save everything in a directory where we can re-run different promps later for testing


```bash
 Θ rm -rf ~/camcontest && mkdir ~/camcontest
 Θ ~/Source/camcontest/camcontest.rb
/home/mit/camcontest/report-202509120515-003/report-version-000.jpg
Level 3 | The dogs are mostly lying down with their heads up, suggesting a relaxed but slightly alert
 Θ ls /home/mit/camcontest/report-202509120515-003/
file-01-20251209-051524.jpg  file-02-20251209-051527.jpg  file-03-20251209-051531.jpg  prompt-version-000.json  report-version-000.jpg
 Θ echo "list timestamps in the top left from every image" | ./run-prompt-on-report.rb /home/mit/camcontest/report-202509120515-003/

/home/mit/camcontest/report-202509120515-003/report-version-001.jpg
Here are the timestamps from the top left of each image:
*   Image 1: 2025-09-12 05:15:23
*   Image 2: 2025-09-12 05:15:27
*   Image 3: 2025-09-12 05:15:30
 Θ ls /home/mit/camcontest/report-202509120515-003/
file-01-20251209-051524.jpg  file-02-20251209-051527.jpg  file-03-20251209-051531.jpg  prompt-version-000.json  prompt-version-001.json  report-version-000.jpg  report-version-001.jpg

```

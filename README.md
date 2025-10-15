# CameraContinuedEstimation

* *bin/fetch-images-and-run.rb* saves STEPS images with INTERVAL delay in *./work*
  and submits them via `llm` to llama.cpp to get the activity level of
  the dogs comparing the images. It generates a report.
  
* *bin/run-prompt-on-report.rb* <*report-directory*> uses stdin PROMPT to
  generate new report image and saves it in same folder. This is to
  test other prompt on existing image sets.

* *bin/show-reports.rb* <*report-directory*> generates a list if all
  result generations with corresponding prompts


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
[nix-shell]  Θ rm -rf ~/camcontest && mkdir ~/camcontest
[nix-shell]  Θ ~/Source/camcontest/bin/fetch-images-and-run.rb --force
/home/mit/camcontest/report-202510151825-003/report-version-000.jpg
Level 3 | Both dogs are lying down, seemingly relaxed.
[nix-shell]  Θ echo "list timestamps in the top left from every image" | ~/Source/camcontest/bin/run-prompt-on-report.rb /home/mit/camcontest/report-202510151825-003/
/home/mit/camcontest/report-202510151825-003/report-version-001.jpg
Here are the timestamps from the top left of each image:

*   **Image 1:** 2025-10-15 18:24:47
*   **Image 2:** 2025-10-15 18:24:51
*   **Image 3:** 2025-10-15 18:24:54
[nix-shell]  Θ date
Wed 15 Oct 18:26:40 CEST 2025
[nix-shell]  Θ ~/Source/camcontest/bin/show-reports.rb /home/mit/camcontest/report-202510151825-003/
level   3
file
        /home/mit/camcontest/report-202510151825-003/report-version-000.jpg
prompt
        carefully examine each of the 3 images from the sequence of
a surviliance camera few second apart each other and find
any dogs (usually there are at least 2 or 3 sometimes more)
and evalute what they do and where they are located

compare the images, the positions of the dogs and what
posture changes between each image to only determinate their
acitivity level. when one dog is visible in one image and
not in another consider him very active

the goal is to get an idea how they behave and how active
they are on a SCORE from 1..10 while 1 is lying on the
ground 10 is standing dogs or positin shifting.

SCORE must be below 5 if all dogs lying
SCORE must be above 5 if there are dogs standing or moving
around else below

Never mention images, camera (angles), furniture or humans -
this is 100% about the dogs.

Respond 'Level [SCORE] | very brief description of dogs
posture'
result
        Level 3 | Both dogs are lying down, seemingly relaxed.
------------------------------------------------------------
level   0
file
        /home/mit/camcontest/report-202510151825-003/report-version-001.jpg
prompt
        list timestamps in the top left from every image
result
        Here are the timestamps from the top left of each image:

*   **Image 1:** 2025-10-15 18:24:47
*   **Image 2:** 2025-10-15 18:24:51
*   **Image 3:** 2025-10-15 18:24:54
------------------------------------------------------------
```

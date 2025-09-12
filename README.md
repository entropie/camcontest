# CameraContinuedEstimation

* *camcontest.rb* saves STEPS images with INTERVAL delay in *./work*
  and submits them via `llm` to llama.cpp to get the activity level of
  the dogs comparing the images. It generates a report.
  
* *run-prompt-on-report.rb* <*report-directory*> uses stdin PROMPT to
  generate new report image and saves it in same folder. This is to
  test other prompt on existing image sets.


## example


Blow example shows how to run the script.

* It fetches STEPS images with DELAY from the home assistant camera api
* runs `llm` with the images attached and `$(cat prompt.txt)`
* combines every input image and headers it with the llm output and
* save everything in a directory where we can re-run different promps later for testing


```bash
 Θ rm -rf ~/camcontest && mkdir ~/camcontest
 Θ /home/mit/Source/camcontest/camcontest.rb
/home/mit/camcontest/report-202509120435/report--level-1-version-000.jpg
Level 3 | The dogs are mostly lying down with occasional head lifts, indicating a state of relaxed observation
 Θ ls /home/mit/camcontest/report-202509120435/
file-01-20251209-043533.jpg  file-02-20251209-043536.jpg  file-03-20251209-043539.jpg  prompt-version-000.json  report--level-1-version-000.jpg
 Θ echo "describe" | /home/mit/Source/camcontest/run-prompt-on-report.rb /home/mit/camcontest/report-202509120435/
/home/mit/camcontest/report-202509120435/report--level-1-version-001.jpg
Here's a description of the images you sent:

**Overall Impression:**

The images are black and white surveillance camera stills showing a domestic interior, likely a living room or home office. There’s a man sitting at a desk, and two dogs are present in the room. The room appears somewhat cluttered with laundry and various items.

**Details:**

*   **Man:** A man is sitting in a rolling office chair, facing away from the camera. He is wearing a grey shirt and dark pants. He’s leaning back in his chair, with his arms raised, appearing to be relaxed or possibly looking at something on a computer screen.

*   **Dogs:** There are two dogs in the room. One is a large, black and white dog lying on a large, circular dog bed. The other is a smaller, white dog lying on the floor near the man's desk.

*   **Furniture & Objects:**
    *   A desk with a computer and various office supplies (pens, bottles, etc.).
    *   A rolling chair.
    *   A black dog bed with a white dog on it.
 Θ ls /home/mit/camcontest/report-202509120435/
file-01-20251209-043533.jpg  file-03-20251209-043539.jpg  prompt-version-001.json          report--level-1-version-001.jpg
file-02-20251209-043536.jpg  prompt-version-000.json      report--level-1-version-000.jpg
```

# CameraContinuedEstimation

* *camcontest.rb* saves STEPS images with INTERVAL delay in *./work*
  and submits them via `llm` to llama.cpp to get the activity level of
  the dogs comparing the images
  
* *report.sh* combines images and banners them with the estimation
  text from the *llm* and saves them (for debugging)

# DECam Survey of Intermediate Redshift Transients

DESIRT software

 ## Elise's Files/Notes

 ### data_cuts.ipynb
 Used to compare cadences between a simulated dataset (in this case, ELAsTiCC) and DECam data, cut data by cadence and/or nondetections, then compare magnitude and cadence distributions. 

 ### test_elasticc_models.ipynb
 Used to compare performance of parsnip models trained on ELAsTiCC vs PLAsTiCC. Also can generate predictions with this code but more robust to use an sbatch job. 

 ### cdf_noise.ipynb
 Used to generate noise for a simulation dataset (ELAsTiCC) similar to DECam observations using a cdf sampling method. Saves data with simulated noise with SNR >=5. 

  ### nearest_noise.ipynb
 Used to generate noise for a simulation dataset (ELAsTiCC) similar to DECam observations using the nearest neighbor noise for values inside of the range of DECam fluxes and using linear interpolation for values outside of the range. Saves data with simulated noise with SNR >=5. 

 ### convert_to_lcdata.ipynb
 Similar to Converting2LCdata.ipynb files already in the github, this generates lcdatasets from both new and old observations. Used to get all the lcdata within /global/cfs/cdirs/m4237/desirt/2021_data/lcdata/, /global/cfs/cdirs/m4237/desirt/new_data/DCDE/, /global/cfs/cdirs/m4237/desirt/new_data/DCDE2/, /global/cfs/cdirs/m4237/desirt/new_data/DCDE3/, and /global/cfs/cdirs/m4237/desirt/new_data/DCDE4/.

 ### create_dataset.py
 Python script adapted from Kostya's parsing code (https://github.com/uiucsn/elasticc_classifier_kostya/blob/master/create_dataset.py) for creating lcdata from SNANA simulations. 

 ### decam_desi_crossmatch.csv

 File from Tomas that includes all crossmatched redshifts/datasets from DECam observations. 

 ### get_object_info.ipynb

 Used to generate a csv file with all information about DECam observations. The file was then used to create the crossmatch.csv file. 

 ### train_parsnip_models.sbatch

 Sample sbatch script used to train a parsnip model. Definitely not the best-written sbatch script but it works.

 ### generate_parsnip_predictions.sbatch
 Sample sbatch script used to generate parsnip predictions. 

 ### Summary of Models
 cdf_noise: Created with the cdf_noise.ipynb file. In NERSC, noisy without cuts are located at /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_data/, noisy with cuts are located at /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/. Trained models are located at /global/cfs/cdirs/m4237/eliseke/parsnip/models/parsnip_elasticc_cdf_noise_##number epochs##.pt, and there's models for 300, 350, 370, and 410 epochs. Trained classifiers are located in /global/cfs/cdirs/m4237/eliseke/parsnip/predictions/, along with predictions produced by their respective models. 

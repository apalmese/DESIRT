#!/bin/bash
#SBATCH --constraint=gpu
#SBATCH --mem-per-cpu=1200
#SBATCH --cpus-per-task=50
#SBATCH --time 00:15:00
#SBATCH --gpus=1
#SBATCH --gpus-per-node=1
#SBATCH --gpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --account=m4237
#SBATCH --job-name=predict_SNIb+HostXT_V19
#SBATCH --output=/global/cfs/cdirs/m4237/eliseke/logs/%x.log
#SBATCH --qos=regular
#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=eliseke@umich.edu


module load python
conda activate parsnip_env

export MODEL_PATH="/global/cfs/cdirs/m4237/eliseke/parsnip/models/parsnip-elasticc-extragal4.pt"
export PREDICTIONS_PATH="/global/cfs/cdirs/m4237/eliseke/parsnip/predictions/SNIb+HostXT_V19test.hdf5"
export TRAININGSET_PATH="/global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/cutmags/SNIb+HostXT_V19_noisy.hdf5"


parsnip_predict ${PREDICTIONS_PATH} ${MODEL_PATH} ${TRAININGSET_PATH}

#!/bin/bash
#SBATCH --constraint=gpu
#SBATCH --mem-per-cpu=1200
#SBATCH --time 12:00:00
#SBATCH --gpus=1
#SBATCH --gpus-per-node=1
#SBATCH --gpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --account=m4237
#SBATCH --job-name=cdf_train
#SBATCH --output=/global/cfs/cdirs/m4237/eliseke/logs/%x.log
#SBATCH --qos=regular

module load python
conda activate parsnip_env

# Add environment variables for debugging CUDA errors
export CUDA_LAUNCH_BLOCKING=1
export TORCH_USE_CUDA_DSA=1

model_path="/global/cfs/cdirs/m4237/eliseke/parsnip/models/parsnip_elasticc_cdf_noise.pt"
data_path="/global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SNIa-SALT3.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SLSN-I+host.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SNIb+HostXT_V19.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SNIcBL+HostXT_V19.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SNIb-Templates.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SNIIb+HostXT_V19.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SNIax.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SNIIn-MOSFIT.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SNII-NMF.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SNIa-91bg.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SNII-Templates.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SNIIn+HostXT_V19.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SNIc-Templates.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/SNIc+HostXT_V19.hdf5
/global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/KN_B19.hdf5 /global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/KN_K17.hdf5
/global/cfs/cdirs/m4237/desirt/Elasticc_data/Elasticc_updated_lcdata/noisy_with_cuts2/TDE.hdf5"

watch_nvidia_smi () {
  while :; do
   # Print GPU and GPU RAM consumption every 60 seconds
    nvidia-smi
   # Prints CPU and RAM consumption every 60 seconds
    top -b -n1 -u "$USER"
    sleep 60
  done
}

watch_nvidia_smi &

parsnip_train $model_path $data_path --threads=20 --device=cuda --batch_size=2024 --learning_rate=1e-5 --min_learning_rate=1e-8 --zeropoint=27.5

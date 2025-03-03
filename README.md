# SplatFields: Neural Gaussian Splats for Sparse 3D and 4D Reconstruction

[Project page](https://markomih.github.io/SplatFields/) | [Paper](https://arxiv.org/pdf/2409.11211) <br>

![Teaser image](assets/splatFields_teaser_lego.png)

This repo contains the official implementation for the paper "SplatFields: Neural Gaussian Splats for Sparse 3D and 4D Reconstruction". 
SplatFields regularizes 3D Gaussian Splatting (3DGS) by predicting the splat features and locations via neural fields to improve the reconstruction under unconstrained sparse views. 

Our approach effectively handles static and dynamic scenes. 

> **Fork Information:**  
> This repository is a fork of the original SplatFields implementation.
> 
>It is maintained by **Rogério T. Gasi** (`rgasi@siggraph.org`) as part of an open-source ETC project.

## Installation

We will use Docker to build an image.

### 1. Pull from nvidia:

```bash
docker pull nvidia/cuda:11.6.2-cudnn8-devel-ubuntu18.04
```

### 2. Build your image

```bash
docker build -t splatfields .
```

### 3. Run the image

```bash
docker run --gpus all -it splatfields
```

### 4. Install other dependencies
I wasn't able to get all dependencies installed through the dockerfile, so you'll need to install these yourself.
Just copy and paste the lines below into your terminal.
```bash
pip install --no-build-isolation git+https://github.com/ingra14m/depth-diff-gaussian-rasterization@f2d8fa9921ea9a6cb9ac1c33a34ebd1b11510657#egg=diff_gaussian_rasterization
pip install --no-build-isolation git+https://gitlab.inria.fr/bkerbl/simple-knn.git@44f764299fa305faf6ec5ebd99939e0508331503#egg=simple_knn
pip install --no-build-isolation git+https://github.com/open-mmlab/mmgeneration@f6551e1d6ca24121d1f0a954c3b3ac15de6d302e#egg=mmgen
```

## Static Reconstruction
The project structure follows the original 3DGS repository. 

### Blender Dataset
The original instructions had a broken link to the NERF Blender Dataset. I downloaded the dataset from this link: https://nerfbaselines.github.io/blender and I put it in my google drive for a single access. I got the 3DGS-MCMC method but you can feel free to use what you need.

To download the datasets, you need to do `nerfbaselines download-dataset external://blender` from your venv, and then set the folder `C:\Users\USERNAME\.cache\nerfbaselines\datasets\blender\` in your bat script.
Alternatively, you can also [download from Google Drive](https://drive.google.com/file/d/1BYyEWDk2q1xzij9dXsi54StMrNmPshhv/view?usp=sharing).

> **NOTE: This is already done automatically in your docker image**

To run SplatFields on the Blender dataset follow the instructions in the `run_blender.sh` script. 

Make sure that the `DATASET_ROOT` variable is set to the directory where the Blender dataset is downloaded. 
In our case it should be `/root/blender_dataset`.

### DTU Dataset (NOT UPDATED)
To run our method on the DTU dataset, you could directly download the pre-processed subset released in the [2DGS repo](https://drive.google.com/drive/folders/1SJFgt8qhQomHX55Q4xSvYE2C6-8tFll9). 
We provide the bash script `run_dtu.sh` to run SplatFields on the DTU sequences. Update the `DATASET_ROOT` in the script to the path of the downloaded dataset. 

## Dynamic Reconstruction
SplatFields straightforwardly extends to dynamic scenes. 

### Owlii Dataset (NOT UPDATED)
The pre-processed Owlii dataset for the dynamic sparse view reconstruction is available [here](https://drive.google.com/file/d/1OdqwXKmvnpxFI4LC8ckI0eV6r9EZ64ZV/view?usp=sharing) (or download it via `gdown 1OdqwXKmvnpxFI4LC8ckI0eV6r9EZ64ZV && unzip DATA_OWLII`). Then, run the script `run_owlii.sh` to train our model on varying configurations (set the data directory appropriately). 

## Citation

If you find our work helpful, please consider citing:
```bibtex
@inproceedings{SplatFields,
   title={SplatFields: Neural Gaussian Splats for Sparse 3D and 4D Reconstruction},
   author={Mihajlovic, Marko and Prokudin, Sergey and Tang, Siyu and Maier, Robert and Bogo, Federica and Tung, Tony and Boyer, Edmond},
   booktitle={European Conference on Computer Vision (ECCV)},
   year={2024},
   organization={Springer}
}
```

## LICENSE
The code released under this repo is under MIT license, however the origianl 3DGS renderer that is utilized has a more restrictive [LICENSE](https://github.com/graphdeco-inria/gaussian-splatting).

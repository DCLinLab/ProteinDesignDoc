# RFDiffusion Guide for Lin Lab

This is the main utility for users to commit protein design. There are a number of modes to choose from for specific tasks.

Source: https://github.com/RosettaCommons/RFdiffusion/

- [RFDiffusion Guide for Lin Lab](#rfdiffusion-guide-for-lin-lab)
  - [Usage](#usage)
    - [Unconditional (most basic)](#unconditional-most-basic)

## Usage

Create conda environment SE3nv if not any:

```bash
conda env create -f /opt/RFdiffusion/env/SE3nv.yml
conda activate SE3nv
cd /opt/RFdiffusion/env/SE3Transformer
pip install --no-cache-dir -r requirements.txt
py=`which python`
sudo $py setup.py install       # in case you don't have the write permission
cd ../..
py=`which pip`
sudo $py install -e .           # in case you don't have the write permission
```
This first installs the transformer, then installs the repo as editable, so DO NOT edit it.

Activate before use:

```bash
conda activate SE3nv
```

### Unconditional (most basic)
./scripts/run_inference.py

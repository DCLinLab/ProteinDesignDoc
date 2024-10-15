 # ProteinMPNN Guide for Lin Lab
ProteinMPNN is used to convert the designed backbone to a probable sequence, as the final result of protein design.

Source: https://github.com/dauparas/ProteinMPNN

- [ProteinMPNN Guide for Lin Lab](#proteinmpnn-guide-for-lin-lab)
  - [Usage](#usage)
  - [Demos](#demos)
    - [demo1: simple monomer (for a folder of proteins)](#demo1-simple-monomer-for-a-folder-of-proteins)
    - [demo2: multi-chain (for a folder of proteins)](#demo2-multi-chain-for-a-folder-of-proteins)
    - [More demos can be found in the repo](#more-demos-can-be-found-in-the-repo)


## Usage

The repos has been cloned to /opt with all requirements installed.

First, run `conda activate mlfold` to prepare your terminal for the job.

For a new user, the conda environment might not have been set up. Run:

```bash
conda create --name mlfold
conda activate mlfold
conda install pytorch torchvision torchaudio cudatoolkit=11.3 -c pytorch
```

Then, run `python /opt/ProteinMPNN/protein_mpnn_run.py <options>`, like the following

```bash
 python ../protein_mpnn_run.py \
        --pdb_path $path_to_PDB \
        --pdb_path_chains "$chains_to_design" \
        --out_folder $output_dir \
        --num_seq_per_target 2 \
        --sampling_temp "0.1" \
        --batch_size 1
```

It can also be used in jupyter notebook, but is a bit too difficult for learning.

Output:

```
>3HTN, score=1.1705, global_score=1.2045, fixed_chains=['B'], designed_chains=['A', 'C'], model_name=v_48_020, git_hash=015ff820b9b5741ead6ba6795258f35a9c15e94b, seed=37
NMYSYKKIGNKYIVSINNHTEIVKALNAFCKEKGILSGSINGIGAIGELTLRFFNPKTKAYDDKTFREQMEISNLTGNISSMNEQVYLHLHITVGRSDYSALAGHLLSAIQNGAGEFVVEDYSERISRTYNPDLGLNIYDFER/NMYSYKKIGNKYIVSINNHTEIVKALNAFCKEKGILSGSINGIGAIGELTLRFFNPKTKAYDDKTFREQMEISNLTGNISSMNEQVYLHLHITVGRSDYSALAGHLLSAIQNGAGEFVVEDYSERISRTYNPDLGLNIYDFER
>T=0.1, sample=1, score=0.7291, global_score=0.9330, seq_recovery=0.5736
NMYSYKKIGNKYIVSINNHTEIVKALKKFCEEKNIKSGSVNGIGSIGSVTLKFYNLETKEEELKTFNANFEISNLTGFISMHDNKVFLDLHITIGDENFSALAGHLVSAVVNGTCELIVEDFNELVSTKYNEELGLWLLDFEK/NMYSYKKIGNKYIVSINNHTDIVTAIKKFCEDKKIKSGTINGIGQVKEVTLEFRNFETGEKEEKTFKKQFTISNLTGFISTKDGKVFLDLHITFGDENFSALAGHLISAIVDGKCELIIEDYNEEINVKYNEELGLYLLDFNK
>T=0.1, sample=2, score=0.7414, global_score=0.9355, seq_recovery=0.6075
NMYKYKKIGNKYIVSINNHTEIVKAIKEFCKEKNIKSGTINGIGQVGKVTLRFYNPETKEYTEKTFNDNFEISNLTGFISTYKNEVFLHLHITFGKSDFSALAGHLLSAIVNGICELIVEDFKENLSMKYDEKTGLYLLDFEK/NMYKYKKIGNKYVVSINNHTEIVEALKAFCEDKKIKSGTVNGIGQVSKVTLKFFNIETKESKEKTFNKNFEISNLTGFISEINGEVFLHLHITIGDENFSALAGHLLSAVVNGEAILIVEDYKEKVNRKYNEELGLNLLDFNL
```

  `score` - average over residues that were designed negative log probability of sampled amino acids
  `global score` - average over all residues in all chains negative log probability of sampled/fixed amino acids
  `fixed_chains` - chains that were not designed (fixed)
  `designed_chains` - chains that were redesigned
  `model_name/CA_model_name` - model name that was used to generate results, e.g. v_48_020
  `git_hash` - github version that was used to generate outputs
  `seed` - random seed
  `T=0.1` - temperature equal to 0.1 was used to sample sequences
  `sample` - sequence sample number 1, 2, 3...etc



## Demos

All demos are set up in their repo. Here includes some of them.

### demo1: simple monomer (for a folder of proteins)

Modified from: `/opt/ProteinMPNN/examples/submit_example_1.sh`

```bash
source activate mlfold

folder_with_pdbs="/opt/ProteinMPNN/inputs/PDB_monomers/pdbs/"

output_dir="."

path_for_parsed_chains=$output_dir"/parsed_pdbs.jsonl"

python /opt/ProteinMPNN/helper_scripts/parse_multiple_chains.py --input_path=$folder_with_pdbs --output_path=$path_for_parsed_chains

python /opt/ProteinMPNN/protein_mpnn_run.py \
        --jsonl_path $path_for_parsed_chains \
        --out_folder $output_dir \
        --num_seq_per_target 2 \
        --sampling_temp "0.1" \
        --seed 37 \
        --batch_size 1

```

It first parsed the chains in the pdb with `parse_multiple_chains.py`, and then run MPNN to get all the FASTA sequences.

The parse estimates the AA coordinates for each sequence and store them into `parsed_pdbs.jsonl`.

### demo2: multi-chain (for a folder of proteins)

Modified from: `/opt/ProteinMPNN/examples/submit_example_1.sh`

```bash
source activate mlfold

folder_with_pdbs="/opt/ProteinMPNN/inputs/PDB_complexes/pdbs/"

output_dir="."

path_for_parsed_chains=$output_dir"/parsed_pdbs.jsonl"
path_for_assigned_chains=$output_dir"/assigned_pdbs.jsonl"
chains_to_design="A B"

python /opt/ProteinMPNN/helper_scripts/parse_multiple_chains.py --input_path=$folder_with_pdbs --output_path=$path_for_parsed_chains

python /opt/ProteinMPNN/helper_scripts/assign_fixed_chains.py --input_path=$path_for_parsed_chains --output_path=$path_for_assigned_chains --chain_list "$chains_to_design"

python /opt/ProteinMPNN/protein_mpnn_run.py \
        --jsonl_path $path_for_parsed_chains \
        --chain_id_jsonl $path_for_assigned_chains \
        --out_folder $output_dir \
        --num_seq_per_target 2 \
        --sampling_temp "0.1" \
        --seed 37 \
        --batch_size 1
```

This script first also parses the chains. Then it assigns the chains of selection for fixed or designed.

```json
{"3HTN": [["A", "B"], ["C"]], "4YOW": [["A", "B"], ["C", "D", "E", "F"]]}
```

In FASTA, only A and B are designed and others are fixed.

### More demos can be found in the repo

mpnn can be run for PDB directly. Also there are less common utils such as fixing residue positions (example_4), tieing positions together (example_5), homooligomer (example_6).

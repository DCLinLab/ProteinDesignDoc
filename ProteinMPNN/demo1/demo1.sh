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

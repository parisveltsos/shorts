#!/usr/bin/env python
import os
import sys
# import subprocess
import argparse
import logging
from argparse import RawTextHelpFormatter
import pysam
from tqdm import tqdm
import numpy as np
import multiprocessing
# from multiprocessing import Pool, Manager


'''
Vulcan: Map long and prosper, a pipeline connects minimap2 and NGMLR
@author: Yilei Fu
@Email: yf20@rice.edu
'''


logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

WORK_DIR = None
THREADS = 1
FULL = False
# LOG = ""


def parseArgs(argv):
    """Function for parsing Arguments

    Args:
        argv: The arguments sent into this program
    Returns:
        arguments
    """

    parser = argparse.ArgumentParser(
        description="vulcan: map long reads and prosper🖖, a long read mapping pipeline that melds minimap2 and NGMLR", formatter_class=RawTextHelpFormatter)
    # parser.add_argument("-i", "--input", nargs="+", type=str,
    #                     help="input read path, can accept multiple files", required=True)
    requiredNamed = parser.add_argument_group('Required arguments:')

    requiredNamed.add_argument("-i", "--input",  nargs="+", type=str,
                               help="input read path, can accept multiple files", required=True)
    requiredNamed.add_argument("-r", "--reference", type=str,
                               help="reference path", required=True)
    requiredNamed.add_argument("-o", "--output", type=str,
                               help="vulcan's output's prefix, the output will be prefix_{percentile}.bam", required=True)
    parser.add_argument("-w", "--work_dir",  type=str,
                        help="Directory of work, store temp files, default: ./vulcan_work",
                        default="./vulcan_work")
    parser.add_argument("-t", "--threads",  type=int,
                        help="threads, default: 1",  default=1)
    parser.add_argument("-p", "--percentile", nargs="+", type=int,
                        help="percentile of cut-off, default: 90", default=[90])
    parser.add_argument("-m", "--minimap2",
                        help="use existing minimap2 output as input", type=str)
    parser.add_argument("-f", "--full",
                        help="keep all temp file", action="store_true")
    parser.add_argument("-d", "--dry",
                        help="only generate config", action="store_true")
    parser.add_argument("-R", "--raw_edit_distance",
                        help="Use raw edit distance to do the cut-off", action="store_true")
    read_type = parser.add_mutually_exclusive_group()
    read_type.add_argument(
        "-clr", "--pacbio_clr", help="Input reads is pacbio CLR reads", action="store_true")
    read_type.add_argument(
        "-hifi", "--pacbio_hifi", help="Input reads is pacbio hifi reads", action="store_true")
    read_type.add_argument(
        "-ont", "--nanopore", help="Input reads is Nanopore reads", action="store_true")
    read_type.add_argument(
        "-any", "--anylongread", help="Don't know which kind of long read", action="store_true")
    read_type.add_argument(
        "-hclr", "--humanclr", help="Human pacbio CLR read", action="store_true")
    read_type.add_argument(
        "-hhifi", "--humanhifi", help="Human pacbio hifi reads", action="store_true")
    read_type.add_argument(
        "-hont", "--humannanopore", help="Human Nanopore reads", action="store_true")
    read_type.add_argument(
        "-cmd", "--custom_cmd", help="Use minimap2 and NGMLR with user's own parameter setting", action="store_true")
    # By default, minimap2 -a --MD -t -o, reference and input are required, will not be included
    # ngmlr --bam-fix -t {THREADS} -r {ngmlr_input_ref} -q {ngmlr_input_reads} -o {ngmlr_output} are required
    if len(argv) == 0:
        parser.print_help(sys.stderr)
        sys.exit(1)
    args = parser.parse_args(argv)

    return args


def run_minimap2(minimap2_input_ref, minimap2_input_reads, minimap2_output, read_type):
    read_as_input = " ".join(minimap2_input_reads)
    if read_type == "hifi":
        logger.info("Use minimap2 PacBio hifi parameter")
        minimap2_cmd = f"minimap2 -a -x map-pb --MD -t {THREADS} {minimap2_input_ref} {read_as_input} > {minimap2_output}"
    elif read_type == "clr":
        logger.info("Use minimap2 PacBio CLR parameter")
        minimap2_cmd = f"minimap2 -a -x map-pb --MD -t {THREADS} {minimap2_input_ref} {read_as_input} > {minimap2_output}"
    elif read_type == "any":
        logger.info("Use minimap2 universial parameter")
        minimap2_cmd = f"minimap2 -a --MD -t {THREADS}  {minimap2_input_ref} {read_as_input} > {minimap2_output}"
    elif read_type == "hclr":
        logger.info("Use minimap2 suggested human clr parameter")
        # GIAB  recommended parameters
        minimap2_cmd = f"minimap2 -x map-pb -a --eqx -L -O 5,56 -E 4,1 -B 5 --secondary=no -z 400,50 -r 2k -Y -t {THREADS} --MD {minimap2_input_ref} {read_as_input} > {minimap2_output}"
    elif read_type == "hhifi":
        logger.info("Use minimap2 suggested human hifi parameter")
        # GIAB  recommended parameters
        minimap2_cmd = f"minimap2 -a -k 19 -O 5,56  -E 4,1 -B 5 -z 400,50 -r 2k --eqx --secondary=no --MD -t {THREADS}  {minimap2_input_ref} {read_as_input} > {minimap2_output}"
    elif read_type == "hont":
        logger.info("Use minimap2 suggested Human Nanopore parameter")
        # GIAB  recommended parameters
        minimap2_cmd = f"minimap2 -x map-ont -a -z 600,200 -t {THREADS} --MD {minimap2_input_ref} {read_as_input} > {minimap2_output}"
    else:
        logger.info("Use minimap2 Nanopore parameter")
        minimap2_cmd = f"minimap2 -x map-ont -a --MD -t {THREADS}  {minimap2_input_ref} {read_as_input} > {minimap2_output}"

    logger.info(f"Executing: {minimap2_cmd}")
    os.system(minimap2_cmd)
    return minimap2_output


def run_cmd_minimap2(minimap2_input_ref, minimap2_input_reads, minimap2_output, params):
    read_as_input = " ".join(minimap2_input_reads)
    logger.info("Use minimap2 custom parameter")
    minimap2_cmd = f"minimap2 -a --MD {params} -t {THREADS}  -o {minimap2_output}  {minimap2_input_ref} {read_as_input}"
    logger.info(f"Executing: {minimap2_cmd}")
    os.system(minimap2_cmd)
    return minimap2_output


def filter_sam_file(input_sam, output_sam):
    os.system(f"sed -E '/\t[0-9]+S\t/d' {input_sam} > {output_sam}")
    return output_sam


def run_ngmlr(ngmlr_input_ref, ngmlr_input_reads, ngmlr_output, read_type):
    if read_type in ["hifi", "clr", "hhifi", "hclr"]:
        ngmlr_cmd = f"ngmlr -x pacbio --bam-fix -t {THREADS} -r {ngmlr_input_ref} -q {ngmlr_input_reads} -o {ngmlr_output}"
        logger.info(f"Executing: {ngmlr_cmd}")
        os.system(ngmlr_cmd)
    elif read_type == "any":
        ngmlr_cmd = f"ngmlr --bam-fix -t {THREADS} -r {ngmlr_input_ref} -q {ngmlr_input_reads} -o {ngmlr_output}"
        logger.info(f"Executing: {ngmlr_cmd}")
        os.system(ngmlr_cmd)
    else:
        ngmlr_temp = os.path.join(WORK_DIR, "ngmlr_ont_temp.sam")
        ngmlr_cmd = f"ngmlr -x ont --bam-fix -t {THREADS} -r {ngmlr_input_ref} -q {ngmlr_input_reads} -o {ngmlr_temp}"
        logger.info(f"Executing: {ngmlr_cmd}")
        os.system(ngmlr_cmd)
        filter_sam_file(ngmlr_temp, ngmlr_output)
        if FULL == False:
            os.system(f"rm {ngmlr_temp} &")
    return ngmlr_output


def run_cmd_ngmlr(ngmlr_input_ref, ngmlr_input_reads, ngmlr_output, params):
    ngmlr_cmd = f"ngmlr {params} --bam-fix -t {THREADS} -r {ngmlr_input_ref} -q {ngmlr_input_reads} -o {ngmlr_output}"
    logger.info(f"Executing: {ngmlr_cmd}")
    os.system(ngmlr_cmd)
    return ngmlr_output


def keep_primary_mapping(input_sam, output_sam):
    samtools_cmd = f"samtools view -h -@ {THREADS - 1} -F 2308 {input_sam} -o {output_sam}"
    logger.info(f"Executing: {samtools_cmd}")
    os.system(samtools_cmd)
    return output_sam


def sort_bam_from_bam(input_bam, output_bam):
    sort_bam_cmd = f"samtools sort -@ {THREADS-1} -T {WORK_DIR} {input_bam} > {output_bam}"
    logger.info(f"Executing: {sort_bam_cmd}")
    os.system(sort_bam_cmd)
    return output_bam


def generate_distance_file(input_sam, percentile, raw_edit_distance):
    distance_l = []
    samfile = pysam.AlignmentFile(input_sam, "r")
    # with open(output_txt, "w") as out_f:
    for read in tqdm(samfile.fetch()):
        tags = dict(read.tags)
        if "NM" in tags:
            NM_distance = int(tags["NM"])
            if raw_edit_distance:
                distance_l.append(NM_distance)
            else:
                normalized_edit_distance = float(
                    NM_distance)/read.query_alignment_length
                distance_l.append(normalized_edit_distance)
    dist_percentile_num = np.percentile(list(distance_l), percentile)

    return dist_percentile_num


def generate_sorted_bam(input_sam, output_bam):
    transform_cmd = f"samtools view -bS -@ {THREADS-1} {input_sam} | samtools sort -@ {THREADS-1} -T {WORK_DIR} -o {output_bam}"
    logger.info(transform_cmd)
    os.system(transform_cmd)
    return output_bam


def seperate_sam_files(input_sam, under_value_bam, above_value_bam, cut_off_value, raw_edit_distance):
    if raw_edit_distance:
        transformed_bam = f"{input_sam[:-4]}.bam"
        generate_sorted_bam(input_sam, transformed_bam)
        logger.info(
            f"seperate sam file based on raw edit distance {cut_off_value}")
        bamtools_above_cmd = f"bamtools filter -in {transformed_bam} -out {above_value_bam} -tag NM:{int(cut_off_value)}"
        logger.info(bamtools_above_cmd)
        os.system(bamtools_above_cmd)
        under_filter = "{\"tag\": \"NM:<"+str(cut_off_value)+"\"}"
        under_filter_json = os.path.join(WORK_DIR, "under_filter.json")
        with open(under_filter_json, "w") as ufj:
            ufj.writelines(str(under_filter))
        bamtools_under_cmd = f"bamtools filter -in {transformed_bam} -script {under_filter_json} -out {under_value_bam}"
        logger.info(bamtools_under_cmd)
        os.system(bamtools_under_cmd)
        if FULL == False:
            os.system(f"rm {transformed_bam} &")
    else:
        logger.info(
            f"Splitting sam file with normalized edit distance {cut_off_value}")
        samfile = pysam.AlignmentFile(input_sam, "r")
        above_f = pysam.AlignmentFile(above_value_bam, "wb", template=samfile)
        under_f = pysam.AlignmentFile(under_value_bam, "wb", template=samfile)
        for read in tqdm(samfile.fetch()):
            tags = dict(read.tags)
            if "NM" in tags:
                NM_distance = int(tags["NM"])
                normalized_edit_distance = float(
                    NM_distance)/read.query_alignment_length
                if normalized_edit_distance >= cut_off_value:
                    above_f.write(read)
                else:
                    under_f.write(read)


def bam_to_reads(input_bam, output_reads):
    bam_to_reads_cmd = f"samtools fasta -@ {THREADS-1} {input_bam} > {output_reads} "
    logger.info(bam_to_reads_cmd)
    os.system(bam_to_reads_cmd)


def merge_bam_files(under_value_bam, above_value_bam, final_output):
    final_unsorted_bam = os.path.join(WORK_DIR, "final_unsorted.bam")
    merge_bam_cmd = f"samtools merge {final_unsorted_bam} {under_value_bam} {above_value_bam} -@ {THREADS-1}"
    logger.info(f"Executing: {merge_bam_cmd}")
    os.system(merge_bam_cmd)
    sort_bam_from_bam(final_unsorted_bam, final_output)
    if FULL == False:
        os.system(f"rm {final_unsorted_bam} &")


def generate_config_for_notebook(percentile, final_output, raw_edit_distance):
    # TODO
    work_dir = WORK_DIR
    config_file = os.path.expanduser("~/.vulcan_config")

    threads = THREADS
    percentile = percentile

    ngmlr_above_bam = os.path.abspath(os.path.join(
        work_dir, f"ngmlr_above{percentile}.bam"))
    ngmlr_above_sam = os.path.abspath(os.path.join(
        work_dir, f"ngmlr_above{percentile}.sam"))
    ngmlr_above_edit_distance = os.path.abspath(os.path.join(
        work_dir, f"ngmlr_above{percentile}_distance.txt"))
    minimap2_above_bam = os.path.abspath(os.path.join(
        work_dir, f"minimap2_above{percentile}.bam"))
    minimap2_above_sam = os.path.abspath(os.path.join(
        work_dir, f"minimap2_above{percentile}.sam"))
    minimap2_above_edit_distance = os.path.abspath(os.path.join(
        work_dir, f"minimap2_above{percentile}_distance.txt"))
    minimap2_full_bam = os.path.abspath(os.path.join(
        work_dir, f"minimap2_full.bam"))
    minimap2_full_edit_distance = os.path.abspath(os.path.join(
        work_dir, "minimap2_full_distance.txt"))
    final_bam = os.path.abspath(final_output)
    final_sam = os.path.abspath(os.path.join(work_dir, "final.sam"))
    final_edit_distance = os.path.abspath(
        os.path.join(work_dir, "final_edit_distance.txt"))
    raw_edit_distance = int(raw_edit_distance)
    config_list = [threads, percentile, work_dir, ngmlr_above_bam, ngmlr_above_sam, ngmlr_above_edit_distance, minimap2_above_bam,
                   minimap2_above_sam, minimap2_above_edit_distance, minimap2_full_bam,
                   minimap2_full_edit_distance, final_bam, final_sam, final_edit_distance, raw_edit_distance]
    with open(config_file, "w") as config_f:
        for config in config_list:
            config_f.writelines(f"{config}\n")


def main(argv):
    global THREADS, WORK_DIR, FULL
    args = parseArgs(argv)
    WORK_DIR = args.work_dir
    try:
        os.mkdir(WORK_DIR)
    except Exception:
        logging.exception("work path already exists!")
    THREADS = args.threads
    read_file = args.input
    # print(read_file)
    reference_file = args.reference
    percentile = args.percentile
    raw_edit_distance = args.raw_edit_distance
    # if_hifi = args.pacbio_hifi
    # pacbio = args.pacbio
    final_output = args.output
    read_type = None
    minimap2_cmd = None
    ngmlr_cmd = None
    if args.full:
        FULL = True
    if args.pacbio_clr:
        read_type = "clr"
    elif args.pacbio_hifi:
        read_type = "hifi"
    elif args.nanopore:
        read_type = "ont"
    elif args.humanclr:
        read_type = "hclr"
    elif args.humanhifi:
        read_type = "hhifi"
    elif args.humannanopore:
        read_type = "hont"
    elif args.custom_cmd:
        read_type = "cmd"
        minimap2_cmd = input(
            "Enter the minimap2 command other than -a, --MD, -t, -o, reference and input: ")
        ngmlr_cmd = input(
            "Enter ngmlr command other than --bam-fix, -t, -r, -q, -o: ")
    else:
        read_type = "any"
    if args.dry:
        generate_config_for_notebook(
            percentile, final_output, raw_edit_distance)
        exit()
    if args.minimap2:
        minimap2_full_sam = args.minimap2
        minimap2_full_sam_primary = os.path.join(
            WORK_DIR, "minimap2_full_primary.sam")
        logger.info("keep the primary mapping for edit distance calculation")
        keep_primary_mapping(minimap2_full_sam, minimap2_full_sam_primary)
        logger.info("...finished")
    else:
        minimap2_full_sam = os.path.join(WORK_DIR, "minimap2_full.sam")
        minimap2_full_sam_primary = os.path.join(
            WORK_DIR, "minimap2_full_primary.sam")
        logger.info("run minimap2 on entire reads")
        if read_type == "cmd":
            run_cmd_minimap2(reference_file, read_file,
                            minimap2_full_sam, minimap2_cmd)
        else:
            run_minimap2(reference_file, read_file, minimap2_full_sam, read_type)
        logger.info("...finished")

        logger.info("keep the primary mapping for edit distance calculation")
        keep_primary_mapping(minimap2_full_sam, minimap2_full_sam_primary)
        logger.info("...finished")

    for percentile_run in percentile:
        above_percentile_reads = os.path.join(
            WORK_DIR, f"above_{percentile_run}.fasta")
        minimap2_above_percentile_bam = os.path.join(
            WORK_DIR, f"minimap2_above{percentile_run}.bam")
        minimap2_under_percentile_bam = os.path.join(
            WORK_DIR, f"minimap2_under{percentile_run}.bam")
        ngmlr_output = os.path.join(
            WORK_DIR, f"ngmlr_above{percentile_run}.sam")
        logger.info("gettng the number of cut-off")
        dist_percentile_num = generate_distance_file(minimap2_full_sam_primary,
                                                     percentile_run, raw_edit_distance)
        logger.info("...finished")
        logger.info("seperate sam files")
        seperate_sam_files(minimap2_full_sam, minimap2_under_percentile_bam,
                           minimap2_above_percentile_bam, dist_percentile_num, raw_edit_distance)
        logger.info("...finished")
        logger.info("extracting reads have edit distance above cut-off value")
        bam_to_reads(minimap2_above_percentile_bam,
                     above_percentile_reads)
        if FULL == False:
            os.system(f"rm {minimap2_above_percentile_bam} &")
        logger.info("...finished")
        logger.info("run NGMLR on extracted reads")
        if read_type == "cmd":
            run_cmd_ngmlr(reference_file, above_percentile_reads,
                          ngmlr_output, ngmlr_cmd)
        else:
            run_ngmlr(reference_file, above_percentile_reads,
                      ngmlr_output, read_type)
        if FULL == False:
            os.system(f"rm {above_percentile_reads} &")
        logger.info("...finished")
        logger.info("merge NGMLR's result and minimap2's under cut-off results")
        merge_bam_files(minimap2_under_percentile_bam,
                        ngmlr_output, f"{final_output}_{percentile_run}.bam")
        if FULL == False:
            os.system(f"rm {minimap2_under_percentile_bam} &")
            os.system(f"rm {ngmlr_output} &")
        logger.info("...finished")
        if FULL:
            logger.info("Generating configs for jupyter notebook evaluation")
            generate_config_for_notebook(
                percentile_run, final_output, raw_edit_distance)
            logger.info("...finished")
        logger.info(f"All Finished, percentile {percentile_run}")


if __name__ == "__main__":
    main(sys.argv[1:])


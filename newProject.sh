#!/bin/bash
# Run with ~/git/shorts/newProject.sh

# Instructions:
# Change the PROJECT_DIR to your path

PROJECT_DIR=~/git/$1

# MY FOLDERS:
IN_DIR=${PROJECT_DIR}/input
OUT_DIR=${PROJECT_DIR}/output
DATA_RAW_DIR=${PROJECT_DIR}/raw
SCRIPTS_DIR=${PROJECT_DIR}/scripts

REPORTS_DIR=${PROJECT_DIR}/reports

# SCRIPTS

mkdir -p ${PROJECT_DIR} ${IN_DIR} ${OUT_DIR} ${DATA_RAW_DIR} ${SCRIPTS_DIR} ${REPORTS_DIR} ${SCRIPTS_DIR}

touch ${PROJECT_DIR}/readme.md

echo -e "temp\noutput\nRplots.pdf\nreports\n.DS_Store" > ${PROJECT_DIR}/.gitignore

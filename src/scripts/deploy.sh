#!/bin/bash
set -e

# Variables
SOURCE_DATASET="MONUSER.SOURCE.COBOL"
OBJ_DATASET="MONUSER.OBJ"
LOADLIB_DATASET="MONUSER.LOADLIB"
JCL_DATASET="MONUSER.JCL"

# Upload des copybooks
for cpy in ../src/copybooks/*.cpy; do
    echo "Uploading $cpy..."
    zowe files upload file-to-ds "$cpy" "$SOURCE_DATASET($(basename $cpy .cpy))"
done

# Upload du code source COBOL
for cbl in ../src/cobol/*.cbl; do
    echo "Uploading $cbl..."
    zowe files upload file-to-ds "$cbl" "$SOURCE_DATASET($(basename $cbl .cbl))"
done

# Upload des JCLs
for jcl in ../src/jcl/*.jcl; do
    echo "Uploading $jcl..."
    zowe files upload file-to-ds "$jcl" "$JCL_DATASET($(basename $jcl .jcl))"
done

# Compiler le programme
COMPILE_JOB=$(zowe jobs submit ds "$JCL_DATASET(COMPILE_TRAITEMENT)" --rff jobid --rft string)
echo "Compilation job submitted: $COMPILE_JOB"
zowe jobs wait-for-job $COMPILE_JOB --timeout 120
zowe jobs download output $COMPILE_JOB --directory ./outputs

# Exécuter le programme
RUN_JOB=$(zowe jobs submit ds "$JCL_DATASET(RUN_TRAITEMENT)" --rff jobid --rft string)
echo "Execution job submitted: $RUN_JOB"
zowe jobs wait-for-job $RUN_JOB --timeout 120
zowe jobs download output $RUN_JOB --directory ./outputs

echo "=== Deployment completed. Logs in ./outputs ==="

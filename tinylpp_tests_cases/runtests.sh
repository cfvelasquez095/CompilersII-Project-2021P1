#!/bin/bash

if [ $LPP"x" == "x" ]; then
    echo "Please set LPP environment variable"
    exit
fi

NASM=$(which nasm 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "\e[31mnasm\e[0m executable not found. Please install nasm"
    exit
fi

GCC=$(which gcc 2>/dev/null)
if [ $? -ne 0 ]; then
    echo -e "\e[31mgcc\e[0m executable not found. Please install gcc"
    exit
fi

EXPECTED_DIR=./expected
OUTPUT_DIR=./output
TEMP_DIR=./temp

rm -fr $TEMP_DIR
mkdir -p $TEMP_DIR

rm -fr $OUTPUT_DIR
mkdir -p $OUTPUT_DIR

passed=0
failed=0
for file in $(ls tests/*); do
    BASENAME=$(basename -s .lpp $file)

    $LPP $file > $TEMP_DIR/$BASENAME.asm
    
    $NASM -f elf32 $TEMP_DIR/$BASENAME.asm
    if [ $? -ne 0 ]; then
        echo -e "\e[31mError\e[0m while assembling $file"
        continue
    fi

    $GCC -o $TEMP_DIR/$BASENAME -m32 $TEMP_DIR/$BASENAME.o 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "\e[31mError\e[0m while linking $file"
        continue
    fi

    $TEMP_DIR/$BASENAME > $OUTPUT_DIR/$BASENAME.txt
    diff $OUTPUT_DIR/$BASENAME.txt $EXPECTED_DIR/$BASENAME.txt 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "Testing $file ... \e[31mFailed\e[0m"
        failed=$((failed + 1))
    else
        echo -e "Testing $file ... \e[32mOK\e[0m"
        passed=$((passed + 1))
    fi 
done

total=$((failed + passed))
echo "============================="
echo -e "Total tests: $total"
echo -e "Failed: \e[31m$failed\e[0m"
echo -e "Passed: \e[32m$passed\e[0m"
echo "============================="

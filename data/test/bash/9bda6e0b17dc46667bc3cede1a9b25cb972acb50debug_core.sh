#!/bin/bash
# ..............
# [K3rn€l_P4n1k]
# ..............

# ==========
# DEBUG_CORE
# ==========
#
# Test les fonctions d'exploitation des chunks

primeDB_DEBUG_CORE_SH="${BASH_SOURCE[0]:-$(realpath ${0})}"
primeDB_DEBUG_CORE_SH_DIR="$( dirname ${primeDB_DEBUG_CORE_SH} )"

#
# Gestion des erreurs
#
source ${primeDB_DEBUG_CORE_SH_DIR}/../lib/error.profile

#
# Import des dépendances
#
source ${primeDB_DEBUG_CORE_SH_DIR}/../lib/base.profile
source ${primeDB_DEBUG_CORE_SH_DIR}/../lib/core.profile

primeDB_test_CORE_chunk_getPath(){
  echo "TEST primeDB_CORE_chunk_getPath"
  for i in $( seq 1 1 50 ); do
    primeDB_CORE_chunk_getPath $i
  done
}

primeDB_test_CORE_chunk_getCartouche(){
  echo "TEST primeDB_CORE_chunk_getCartouche"
  for i in $( seq 1 1 50 ); do
    primeDB_CORE_chunk_getCartouche $i
  done
}

primeDB_test_CORE_chunk_getLine(){
  echo "TEST primeDB_CORE_chunk_getLine"
  for ch in $( seq 1 1 3 ); do
    echo "=== ${ch} ==="
    for of in $( seq 1 1 10 ); do
      primeDB_CORE_chunk_getLine ${ch} ${of}
    done
  done
}

primeDB_test_CORE_chunk_line_getPrime (){
  echo "TEST primeDB_CORE_chunk_line_getPrime"
  ch=1
  for ln in $( seq 1 1 ${primeDB_CHUNK_LINES} ); do
      echo "=== ${ln} ==="
      for of in $( seq 1 1 ${primeDB_COLUMNS} ); do
        echo "[${of}] $( primeDB_CORE_chunk_line_getPrime ${ch} ${ln} ${of} )"
      done
  done
}

primeDB_test_CORE_chunk_line_getMinPrim(){
  echo "TEST primeDB_CORE_chunk_line_getMinPrime"
  ch=1
  for ln in $( seq 1 1 ${primeDB_CHUNK_LINES} ); do
    echo "[${ln}] $( primeDB_CORE_chunk_line_getMinPrime ${ch} ${ln} )"
  done
}

primeDB_test_CORE_chunk_line_getMaxPrime(){ 
  echo "TEST primeDB_CORE_chunk_line_getMaxPrime"
  ch=1
  for ln in $( seq 1 1 ${primeDB_CHUNK_LINES} ); do
    echo "[${ln}] $( primeDB_CORE_chunk_line_getMaxPrime ${ch} ${ln} )"
  done
}

primeDB_test_CORE_chunk_getMinPrime (){
  echo "TEST primeDB_CORE_chunk_getMinPrime"
  for ch in $( seq 1 1 10 ); do
    for ln in $( seq 1 1 10 ); do
      primeDB_CORE_chunk_getMinPrime ${ch} ${ln}
    done
  done
}

primeDB_test_CORE_chunk_getMaxPrime (){
  echo "TEST primeDB_CORE_chunk_getMaxPrime"
  for ch in $( seq 1 1 10 ); do
    primeDB_CORE_chunk_getMaxPrime ${ch}
  done
}

primeDB_test_CORE_chunk_countLines (){
  echo "TEST primeDB_CORE_chunk_countLines"
  primeDB_CORE_chunk_countLines 1
}

primeDB_test_CORE_listChunksFile(){
  echo "TEST primeDB_CORE_listChunksFiles"
  primeDB_CORE_listChunksFiles
}

primeDB_test_CORE_listChunksName(){
  echo "TEST primeDB_CORE_listChunksNames"
  primeDB_CORE_listChunksNames
}

primeDB_test_CORE_countChunk(){
  echo "TEST primeDB_CORE_countChunks"
  primeDB_CORE_countChunks
}

primeDB_test_CORE_getMaxPrim(){
  echo "TEST primeDB_CORE_getMaxPrime"
  primeDB_CORE_getMaxPrime
}

primeDB_test_CORE_chunk_getNt(){
  echo "TEST primeDB_CORE_chunk_getNth"
  for ch in $( seq 1 1 3 ); do
    echo "=== ${ch} ==="
    for of in $( seq 1 1 10 ); do
      echo "[${ch}.${of}] $( primeDB_CORE_chunk_getNth ${ch} ${of} )"
    done
  done
}

run(){
  echo ">> RUNNING test"
  #primeDB_test_CORE_chunk_getPath
  #primeDB_test_CORE_chunk_getCartouche
  #primeDB_test_CORE_chunk_getLine
  #primeDB_test_CORE_chunk_line_getPrime
  #primeDB_test_CORE_chunk_line_getMinPrim
  #primeDB_test_CORE_chunk_line_getMaxPrime
  #primeDB_test_CORE_chunk_getMinPrime
  #primeDB_test_CORE_chunk_getMaxPrime
  #primeDB_test_CORE_chunk_countLines
  #primeDB_test_CORE_listChunksFile
  #primeDB_test_CORE_listChunksName
  #primeDB_test_CORE_countChunk
  #primeDB_test_CORE_getMaxPrim
  #primeDB_test_CORE_chunk_getNt
}

run

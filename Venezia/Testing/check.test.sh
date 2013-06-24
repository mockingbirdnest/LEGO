#! /bin/sh
log=check.test.log
rm ${log}
i=1
while [[ $i -le 61 ]]; do
  echo gold${i}.ldr actual${i}.ldr >> ${log}
  diff gold${i}.ldr actual${i}.ldr >> ${log} 2>&1
  i=$(($i + 1))
done
i=201
while [[ $i -le 225 ]]; do
  echo gold${i}.ldr actual${i}.ldr >> ${log}
  diff gold${i}.ldr actual${i}.ldr >> ${log} 2>&1
  i=$(($i + 1))
done
i=401
while [[ $i -le 436 ]]; do
  echo gold${i}.ldr actual${i}.ldr >> ${log}
  diff gold${i}.ldr actual${i}.ldr >> ${log} 2>&1
  i=$(($i + 1))
done
i=601
while [[ $i -le 621 ]]; do
  echo gold${i}.ldr actual${i}.ldr >> ${log}
  diff gold${i}.ldr actual${i}.ldr >> ${log} 2>&1
  i=$(($i + 1))
done
i=801
while [[ $i -le 808 ]]; do
  echo gold${i}.ldr actual${i}.ldr >> ${log}
  diff gold${i}.ldr actual${i}.ldr >> ${log} 2>&1
  i=$(($i + 1))
done

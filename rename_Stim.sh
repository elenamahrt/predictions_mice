call1s="ls *.call1"

for file in $call1s
do
    mv "${file}" "${file/.call1/Dist4.call1}"
done
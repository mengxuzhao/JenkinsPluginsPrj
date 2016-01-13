#!/bin/bash

injections=($(cat injections/injections.txt | tr '|' " "))
outputHTML=injections/currentInjectionsTab.txt
outputBASH=injections/inject.sh
apphome=/opt/bqtools

echo "" > $outputHTML
echo "#!/bin/bash" > $outputBASH

for injection in ${injections[@]} ; do
    if [[ $injection =~ "=" ]]; then
        placeholder=$(echo $injection | cut -d'=' -f1)
        value=$(echo $injection | cut -d'=' -f2)
        if [[ $placeholder != "" ]] && [[ $value != "" ]]; then
            # Append to output HTML file
            echo "<tr>" >> $outputHTML
            echo "<td><input type='checkbox' name='del'/></td>" >> $outputHTML
            echo "<td><input style='width:100%' name='placeholder' type='text' value='$placeholder' /></td>" >> $outputHTML
            echo "<td><input style='width:100%' name='injectionvalue' type='text' value='$value' /></td>" >> $outputHTML
            echo "</tr>" >> $outputHTML
            # Append to output BASH file
            echo "perl -pi -e \"s{$placeholder}{$value}\" $apphome/env/*.properties" >> $outputBASH
            echo "perl -pi -e \"s{$placeholder}{$value}\" $apphome/bin/*.sh" >> $outputBASH
        fi
    fi
done

sed '/<!--INJECTIONS-->/r injections/currentInjectionsTab.txt' /var/lib/jenkins/userContent/html/injections.form.html > /var/lib/jenkins/userContent/html/bqtools.injections.form.html

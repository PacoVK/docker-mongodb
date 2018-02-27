#!/bin/bash
echo "##############################################################################################"
echo "starting MongoDB with command:"
echo $@
echo "##############################################################################################"

customized_default_entrypoint.sh $@

    ##############################################################################################
    # official startup-script uses this pidfile to determine which pid is our mongodb instance
    ##############################################################################################
    pidfile="${TMPDIR:-/tmp}/docker-entrypoint-temp-mongod.pid"

    "$@" --pidfilepath="$pidfile" --shutdown
            rm -f "$pidfile"

            echo
            echo 'MongoDB init process complete; restart mongodb for further configuration.'
            echo

if  [ $(find /mongo-init.d -maxdepth 1 -type f -name '*.sh' | wc -l) -gt 0 ]; then

   echo "Start provision MongoDB with provided scripts...."

    ##############################################################################################
    # process has to be started in background to be able to go on with this script
    ##############################################################################################
    nohup "$@" >myscript.log 2>&1 &
    echo $! > nohup_pid.txt
    # Default port
    mongoPort=27017
    i=0;
    while [ $i -le $# ];
    do
       j=$((i+1))
       if [ ${!i} = "--port" ]; then
        echo "MongoDB is listening on port: ${!j}"
        mongoPort="${!j}"
       elif [[ ${!i} = "--configdb" ]]; then
        configdb="${!j}"
       fi
       i=$((i+1))
    done

    if [ -z ${configdb+x} ]; then
      until mongo --host "$configdb" --port "$mongoPort" --eval "print(\"waiting for configserver...\")"
        do
          sleep 5
        done
    else
        until mongo --port "$mongoPort" --eval "print(\"waiting that mongo is ready to talk to me...\")"
        do
          sleep 5
        done
    fi

    for f in /mongo-init.d/*; do
        case "$f" in
            *.sh) # this should match the set of files we check for below
                chmod +x $f
                sh $f
        esac
    done

    ##############################################################################################
    # kill background process
    ##############################################################################################
    kill -9 `cat nohup_pid.txt`
    rm -f nohup_pid.txt

    echo "Initialized MongoDB sucessfully!!!!!! Go and eat a cookie."

else
  echo "No additional provision scripts were found skipping this step...."
fi
##############################################################################################
# restart MongoDB in foreground
##############################################################################################
exec "$@"
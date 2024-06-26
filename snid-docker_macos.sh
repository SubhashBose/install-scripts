# Run this installer as 
# $ curl -sL https://install-scripts.bose.dev/snid-docker_macos.sh  | sudo sh

(cat <<"EOF" > /usr/local/bin/doSnid
#!/bin/sh
export DOCKER_DEFAULT_PLATFORM=linux/amd64
xhost + localhost > /dev/null
docker run --rm -it -v ./:/workdir -v /tmp/.X11-unix:/tmp/.X11-unix subhashbose/snid "$@"
EOF

) && chmod 777 /usr/local/bin/doSnid && DOCKER_CLI_HINTS=false docker pull subhashbose/snid && (

echo ''
echo '============================= DONE =============================='
echo ''
echo "I have placed a script named 'doSnid' in your path, that you "
echo "can call from any directory in your terminal. The 'doSnid' "
echo "script in turn runs the docker container 'subhashbose/snid'"
echo "which does the heavy lifting."
echo ""
echo ""
echo "IMPORTANT!!!"
echo "   XQuartz is required for the SNID display. Install XQuartz"
echo "   using .dmg file directly from its website, or use Homebew"
echo "   'brew install --cask xquartz'"
echo ""
echo '   After installation is complete (if not done already), start XQuartz'
echo '   application, open "Settings" from menu, go to the “Security” tab and'
echo '   make sure to enable “Allow connections from network clients”.'
echo ""
echo "   Then close XQuarts application completely. Make sure to close"
echo "   from Dock in case it is running in the background."
echo ""
echo "Then you are all set, you can run SNID as:"
echo "> doSnid spectrum.txt"
echo "This SNID container includes two additional sets of spectral"
echo "templates. One big set of core-collapse SNe templates and a "
echo "superluminous SNe template set. You can invoke each of"
echo "these sets as 'doSnid --templates=Big spectrum.txt' and"
echo "'doSnid --templates=SLSN spectrum.txt'"
echo ""
echo "For command line help use: doSnid --help"

)

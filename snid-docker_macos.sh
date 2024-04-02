#Run as 'curl -sL https://  | sudo sh

(cat <<"EOF" > /usr/local/bin/doSnid
#!/bin/sh

docker run --rm -it -v ./:/workdir  -e DISPLAY=host.docker.internal:0 -v /tmp/.X11-unix:/tmp/.X11-unix subhashbose/snid "$@"
EOF

) && chmod 777 /usr/local/bin/doSnid && (

echo ''
echo "I have placed a script named 'doSnid' in your path, that you "
echo "can call from any directory in your terminal. The 'doSnid' "
echo "script in turn runs the docker container 'subhashbose/snid'"
echo "which does the heavy lifting."
echo ""
echo ""
echo "XQuartz is required for the SNID display. Install XQuartz"
echo "using .dmg file directly from its website, or use Homebew"
echo "'brew install --cask xquartz'"
echo ""
echo 'After intallation complete (if not done already), start XQuartz'
echo 'application, select Preferences menu, go to the “Security” tab'
echo 'and make sure to enable “Allow connections from network clients”'
echo ""

)

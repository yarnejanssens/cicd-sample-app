#!/bin/bash
set -euo pipefail

# AANGEPAST: oude tempdir eerst verwijderen.
# Waarom: Jenkins hergebruikt bij elke build dezelfde workspace. Zonder deze
# regel bestaat 'tempdir' al van de vorige build en faalt 'mkdir' (door set -e
# stopt het script dan meteen).
rm -rf tempdir

# AANGEPAST: 'mkdir -p' in plaats van 'mkdir'.
# Waarom: -p maakt ook de bovenliggende map aan en geeft geen fout als een map
# al bestaat. Zo hebben we maar één commando nodig voor alle drie de mappen.
mkdir -p tempdir/templates tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

cat > tempdir/Dockerfile << _EOF_
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
_EOF_

cd tempdir || exit
docker build -t sampleapp .

# AANGEPAST: oude container verwijderen vlak voor de nieuwe start.
# Waarom: 'docker run --name samplerunning' faalt als er al een container met
# die naam bestaat (ook als die gestopt is). 'docker rm -f' stopt de container
# indien nodig en geeft geen fout als hij niet bestaat. We doen dit pas ná
# 'docker build', zodat de oude versie blijft draaien tot de nieuwe image klaar
# is en de downtime zo kort mogelijk blijft.
docker rm -f samplerunning

docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a

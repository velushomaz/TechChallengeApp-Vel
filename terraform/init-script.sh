#!/bin/bash
wget https://github.com/servian/TechChallengeApp/releases/download/v.0.9.0/TechChallengeApp_v.0.9.0_linux64.zip 
unzip TechChallengeApp_v.0.9.0_linux64.zip

sed -i 's/DbHost\" \= \".*\"/DbHost\" \= \"${database_endpoint}\"/g' ./dist/conf.toml
sed -i 's/DbUser\" \= \".*\"/DbUser\" \= \"${database_user}\"/g' ./dist/conf.toml
sed -i 's/DbName\" \= \".*\"/DbName\" \= \"${database_name}\"/g' ./dist/conf.toml
sed -i 's/ListenHost\" \= \".*\"/ListenHost\" \= \"${listen_host}\"/g' ./dist/conf.toml
sed -i 's/DbPassword\" \= \".*\"/DbPassword\" \= \"${database_password}\"/g' ./dist/conf.toml

cd ./dist/
./TechChallengeApp updatedb -s
./TechChallengeApp serve
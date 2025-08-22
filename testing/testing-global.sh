#!/bin/bash

#USER 1 194.199.113.180:30080       LUCAS
#USER 6 194.199.113.232:30090       CAR 
#USER 8 194.199.113.76:30085        JOE 

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406,"hour_sin":0.9957224,"hour_cos":0.5652631,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.47457504,"longitude":0.35028076,"hour_sin":0.995722,"hour_cos":0.565263,"weekday_sin":0,"weekday_cos":0.356896}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406,"hour_sin":1,"hour_cos":0.5,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.47457504,"longitude":0.35028076,"hour_sin":1,"hour_cos":0.5,"weekday_sin":0,"weekday_cos":0.356896}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.5141258,"longitude":0.43502808,"hour_sin":0.9957224,"hour_cos":0.4347369,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.47457504,"longitude":0.35028076,"hour_sin":0.995722,"hour_cos":0.434737,"weekday_sin":0,"weekday_cos":0.356896}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.40678024,"longitude":0.53108215,"hour_sin":0.9829629,"hour_cos":0.37059048,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.47457504,"longitude":0.35028076,"hour_sin":0.982963,"hour_cos":0.37059,"weekday_sin":0,"weekday_cos":0.356896}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.43502808,"longitude":0.61582947,"hour_sin":0.96193975,"hour_cos":0.3086583,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.47457504,"longitude":0.35028076,"hour_sin":0.96194,"hour_cos":0.308658,"weekday_sin":0,"weekday_cos":0.356896}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.41807938,"longitude":0.5593262,"hour_sin":0.9330127,"hour_cos":0.25,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.47457504,"longitude":0.35028076,"hour_sin":0.933013,"hour_cos":0.25,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":0.8660254,"hour_cos":-0.5,"latitude":35.96937,"longitude":139.9655}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.41807938,"longitude":0.5593262,"hour_sin":0.9330127,"hour_cos":0.25,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.47457504,"longitude":0.35028076,"hour_sin":0.933013,"hour_cos":0.25,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":0.7933533,"hour_cos":-0.6087614,"latitude":35.96937,"longitude":139.9655}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.40678024,"longitude":0.5593262,"hour_sin":0.89667666,"hour_cos":0.19561929,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177,"hour_sin":0.896677,"hour_cos":0.195619,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":0.70710677,"hour_cos":-0.70710677,"latitude":35.96937,"longitude":139.9655}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4463272,"longitude":0.61582947,"hour_sin":0.8535534,"hour_cos":0.14644662,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.36158752,"hour_sin":0.853553,"hour_cos":0.146447,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":0.6087614,"hour_cos":-0.7933533,"latitude":35.96937,"longitude":139.9655}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.41807938,"longitude":0.5593262,"hour_sin":0.8043807,"hour_cos":0.10332334,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.32769775,"hour_sin":0.804381,"hour_cos":0.103323,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":0.5,"hour_cos":-0.8660254,"latitude":35.96487,"longitude":139.971}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4463272,"longitude":0.5762787,"hour_sin":0.75,"hour_cos":0.066987306,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.33898926,"hour_sin":0.75,"hour_cos":0.066987,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":0.38268343,"hour_cos":-0.9238795,"latitude":35.96937,"longitude":139.9655}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.43502808,"longitude":0.61582947,"hour_sin":0.6913417,"hour_cos":0.038060248,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4971733,"longitude":0.41809082,"hour_sin":0.691342,"hour_cos":0.03806,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":0.25881904,"hour_cos":-0.9659258,"latitude":35.96937,"longitude":139.9655}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.5367241,"longitude":0.66101074,"hour_sin":0.62940955,"hour_cos":0.017037094,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4971733,"longitude":0.41809082,"hour_sin":0.62941,"hour_cos":0.017037,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":0.13052619,"hour_cos":-0.9914449,"latitude":35.96937,"longitude":139.9655}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.5028229,"longitude":0.63842773,"hour_sin":0.5652631,"hour_cos":0.004277557,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.41809082,"hour_sin":0.565263,"hour_cos":0.004278,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":1.22E-16,"hour_cos":-1,"latitude":35.96937,"longitude":139.9655}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.43502808,"longitude":0.61582947,"hour_sin":0.5,"hour_cos":0,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4971733,"longitude":0.41809082,"hour_sin":0.5,"hour_cos":0,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.13052619,"hour_cos":-0.9914449,"latitude":35.96937,"longitude":139.9655}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.44067764,"longitude":0.6214752,"hour_sin":0.4347369,"hour_cos":0.004277557,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.42373657,"hour_sin":0.434737,"hour_cos":0.004278,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.25881904,"hour_cos":-0.9659258,"latitude":35.96937,"longitude":139.971}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.40678024,"longitude":0.5480194,"hour_sin":0.37059048,"hour_cos":0.017037094,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.41809082,"hour_sin":0.37059,"hour_cos":0.017037,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.38268343,"hour_cos":-0.9238795,"latitude":35.96487,"longitude":139.971}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.40678024,"longitude":0.5480194,"hour_sin":0.3086583,"hour_cos":0.038060248,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.41809082,"hour_sin":0.308658,"hour_cos":0.03806,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.5,"hour_cos":-0.8660254,"latitude":35.96937,"longitude":139.9655}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.43502808,"longitude":0.61582947,"hour_sin":0.25,"hour_cos":0.066987306,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.41809082,"hour_sin":0.25,"hour_cos":0.066987,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.6087614,"hour_cos":-0.7933533,"latitude":35.96937,"longitude":139.9655}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4463272,"longitude":0.61582947,"hour_sin":0.19561929,"hour_cos":0.10332334,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.41809082,"hour_sin":0.195619,"hour_cos":0.103323,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.70710677,"hour_cos":-0.70710677,"latitude":35.98288,"longitude":139.9821}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.45763016,"longitude":0.627121,"hour_sin":0.14644662,"hour_cos":0.14644662,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.41809082,"hour_sin":0.146447,"hour_cos":0.146447,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.7933533,"hour_cos":-0.6087614,"latitude":35.96487,"longitude":139.971}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.61582947,"hour_sin":0.10332334,"hour_cos":0.19561929,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.41809082,"hour_sin":0.103323,"hour_cos":0.195619,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.8660254,"hour_cos":-0.5,"latitude":35.96937,"longitude":139.9655}' | jq
sleep 15
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.9238795,"hour_cos":-0.38268343,"latitude":35.96937,"longitude":139.9655}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4463272,"longitude":0.61582947,"hour_sin":0.066987306,"hour_cos":0.25,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.41809082,"hour_sin":0.066987,"hour_cos":0.25,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.9659258,"hour_cos":-0.25881904,"latitude":35.98288,"longitude":139.9821}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.45763016,"longitude":0.627121,"hour_sin":0.038060248,"hour_cos":0.3086583,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.41809082,"hour_sin":0.03806,"hour_cos":0.308658,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.9914449,"hour_cos":-0.13052619,"latitude":35.97838,"longitude":139.9821}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.61582947,"hour_sin":0.017037094,"hour_cos":0.37059048,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.41809082,"hour_sin":0.017037,"hour_cos":0.37059,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-1,"hour_cos":-1.84E-16,"latitude":35.92883,"longitude":139.9821}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.485878,"longitude":0.44633484,"hour_sin":0.004277557,"hour_cos":0.4347369,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.41809082,"hour_sin":0.004278,"hour_cos":0.434737,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.9914449,"hour_cos":0.13052619,"latitude":35.9018,"longitude":139.9766}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4971733,"longitude":0.42938232,"hour_sin":0,"hour_cos":0.5,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.45763016,"longitude":0.37852478,"hour_sin":0,"hour_cos":0.5,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.9659258,"hour_cos":0.25881904,"latitude":35.8973,"longitude":139.9766}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4971733,"longitude":0.42938232,"hour_sin":-0.004277557,"hour_cos":0.5652631,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.45763016,"longitude":0.41244507,"hour_sin":-0.004278,"hour_cos":0.565263,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.9238795,"hour_cos":0.38268343,"latitude":35.9018,"longitude":139.9821}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406,"hour_sin":-0.017037094,"hour_cos":0.62940955,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.45763016,"longitude":0.38983154,"hour_sin":-0.017037,"hour_cos":0.62941,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.8660254,"hour_cos":0.5,"latitude":35.9018,"longitude":139.9821}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406,"hour_sin":-0.038060248,"hour_cos":0.6913417,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.43502808,"longitude":0.37287903,"hour_sin":-0.03806,"hour_cos":0.691342,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","hour_sin":-0.7933533,"hour_cos":0.6087614,"latitude":35.96487,"longitude":139.971}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406,"hour_sin":-0.066987306,"hour_cos":0.75,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.41809082,"hour_sin":-0.066987,"hour_cos":0.75,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.9018,"longitude":139.9821}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406,"hour_sin":-0.10332334,"hour_cos":0.8043807,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35028076,"hour_sin":-0.103323,"hour_cos":0.804381,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.96487,"longitude":139.971}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406,"hour_sin":-0.14644662,"hour_cos":0.8535534,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.45763016,"longitude":0.3954773,"hour_sin":-0.146447,"hour_cos":0.853553,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.96487,"longitude":139.971}' | jq
sleep 15

curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406,"hour_sin":-0.19561929,"hour_cos":0.89667666,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.47457504,"longitude":0.35028076,"hour_sin":-0.195619,"hour_cos":0.896677,"weekday_sin":0,"weekday_cos":0.356896}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.96487,"longitude":139.971}' | jq
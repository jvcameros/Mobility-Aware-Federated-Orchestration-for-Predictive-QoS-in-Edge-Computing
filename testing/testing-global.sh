#!/bin/bash

#USER 1 194.199.113.180:30080       LUCAS
#USER 6 194.199.113.232:30090       CAR 
#USER 8 194.199.113.76:30085        JOE 


curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.42372894,"longitude":0.69493103}' | jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.42372894,"longitude":0.69493103}' | jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.5141258,"longitude":0.43502808}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.42372894,"longitude":0.69493103}' | jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.40678024,"longitude":0.53108215}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.42372894,"longitude":0.69493103}' | jq
#Now the predictor will have enough position logs to make a prediction which will be sent to the orchestrator
#Now the orchestrator will have predictions, so it will be able to find the closest edge server to the car, which hasn't logged his position till now 
#Note that in the first car position log, it won't access the service as the orchestrator hasn't received its position for placing the 
#service accordingly 
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.43502808,"longitude":0.61582947}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.45197678,"longitude":0.6779785}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"latitude":35.969368,"longitude":139.9655}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.41807938,"longitude":0.5593262}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.969368,"longitude":139.9655}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.40678024,"longitude":0.5593262}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.969368,"longitude":139.9655}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4463272,"longitude":0.61582947}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.964867,"longitude":139.97104}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.41807938,"longitude":0.5593262}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.969368,"longitude":139.9655}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4463272,"longitude":0.5762787}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.969368,"longitude":139.9655}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.43502808,"longitude":0.61582947}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.969368,"longitude":139.9655}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.5367241,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.969368,"longitude":139.9655}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.5028229,"longitude":0.63842773}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.969368,"longitude":139.9655}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.43502808,"longitude":0.61582947}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.969368,"longitude":139.9655}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.44067764,"longitude":0.6214752}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.969368,"longitude":139.9655}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.40678024,"longitude":0.5480194}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.969368,"longitude":139.97104}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.40678024,"longitude":0.5480194}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.964867,"longitude":139.97104}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.43502808,"longitude":0.61582947}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.969368,"longitude":139.9655}' | jq
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4463272,"longitude":0.61582947}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.969368,"longitude":139.9655}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.45763016,"longitude":0.627121}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.982883,"longitude":139.98212}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.61582947}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4293747,"longitude":0.73446655}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.97838,"longitude":139.98212}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.485878,"longitude":0.44633484}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.92883,"longitude":139.98212}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4971733,"longitude":0.42938232}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.901802,"longitude":139.97658}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4971733,"longitude":0.42938232}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.89279,"longitude":139.97104}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.485878,"longitude":0.42373657}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.897297,"longitude":139.97658}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.901802,"longitude":139.98212}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.901802,"longitude":139.98212}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.964867,"longitude":139.97104}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.901802,"longitude":139.98212}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.901802,"longitude":139.98212}' | jq

sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4802246,"longitude":0.40678406}' | jq
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.66101074}' | jq
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.901802,"longitude":139.98212}' | jq
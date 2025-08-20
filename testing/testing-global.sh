#!/bin/bash


curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}'
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}'
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}'
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}'
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}'
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}'
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}'
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}'
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}'
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}'
#Now the predictor will have enough position logs to make a prediction which will be sent to the orchestrator
#Now the orchestrator will have predictions, so it will be able to find the closest edge server to the car, which hasn't logged his position till now 
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}'
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.47457504,"longitude":0.35028076}'
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.6425666809082,"longitude":139.57231567382812}'|jq 
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}'
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}'
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.6425666809082,"longitude":139.58231567382812}'|jq 
sleep 15
curl -X POST http://194.199.113.76:30085/ -H "Content-Type: application/json" -d '{"latitude":0.4632759,"longitude":0.4011383}'
curl -X POST http://194.199.113.180:30080/ -H "Content-Type: application/json" -d '{"latitude":0.46892548,"longitude":0.35594177}'
curl -X POST http://194.199.113.232:30090/ -H "Content-Type: application/json" -d '{"front_distance": 10,"rear_distance": 35,"details": "interested","latitude":35.6425666809082,"longitude":139.59231567382812}'|jq 


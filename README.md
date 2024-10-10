# track-fusion-capstone

### API Gateway Service Account trackfusionapi@utahjazz24.iam.gserviceaccount.com

gcloud auth login
gcloud config set project PROJECT_ID
gcloud functions deploy FUNCTION_NAME --region us-centeral1

gcloud functions add-invoker-policy-binding createUserFunction --region="us-central1" --member="serviceAccount:trackfusionapi@utahjazz24.iam.gserviceaccount.com"

curl -i "https://track-fusion-api-gateway-t8b6s4l.uc.gateway.dev/trackfusion/users"

curl -i "https://track-fusion-api-gateway-t8b6s4l.uc.gateway.dev/trackfusion/users" -d "{\"name\": \"Luke\"}"

gcloud projects add-iam-policy-binding utahjazz24 --member=serviceAccount:GaragesChat@utahjazz24.iam.gserviceaccount.com --role=roles/serviceusage.serviceUsageConsumer

//Deploy Fully to Google cloud
gcloud run deploy chat-app --source . --vpc-connector redis-connector --allow-unauthenticated --timeout 3600 --service-account GaragesChat --update-env-vars REDISHOST=$REDISHOST

//Test Deployment
gcloud run deploy chat-app --source . --allow-unauthenticated --timeout 3600 --service-account GaragesChat

// Create Redis Connector
gcloud compute networks vpc-access connectors create redis-connector --region us-central1 --range "10.8.0.0/28"

//Create Container for gcloud to use
gcloud builds submit --tag gcr.io/utahjazz24/socket-server

//Deployment Command for garagesWebSocketServer
gcloud run deploy socket-server --image gcr.io/utahjazz24/socket-server --platform managed --allow-unauthenticated --service-account GaragesChat --timeout 3600
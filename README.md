# track-fusion-capstone

### API Gateway Service Account trackfusionapi@utahjazz24.iam.gserviceaccount.com

gcloud auth login
gcloud config set project PROJECT_ID
gcloud functions deploy FUNCTION_NAME --region us-centeral1

gcloud functions add-invoker-policy-binding createUserFunction --region="us-central1" --member="serviceAccount:trackfusionapi@utahjazz24.iam.gserviceaccount.com"

curl -i "https://track-fusion-api-gateway-t8b6s4l.uc.gateway.dev/trackfusion/users"

curl -i "https://track-fusion-api-gateway-t8b6s4l.uc.gateway.dev/trackfusion/users" -d "{\"name\": \"Luke\"}"

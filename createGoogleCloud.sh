if [ -z "$1" ]; then
    echo "Please provide project_id as first parameter"
    exit 1
fi

PROJECT_ID="$1"

cd googleCloud

terraform init

terraform apply \
    -var="project_id=$PROJECT_ID" \
    -auto-approve

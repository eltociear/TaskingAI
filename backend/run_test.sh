# mode
export MODE=dev
#
export PURPOSE=WEB

# service
export SERVICE_PORT=8010
export WEB_SERVICE_PORT=8010

# database
export POSTGRES_URL=postgres://postgres:password@localhost:5433/taskingai-postgres
export POSTGRES_MAX_CONNECTIONS=10
export REDIS_URL=redis://localhost:6379/0

export HTTP_PROXY_URL=http://127.0.0.1:7890
# inference
export TASKINGAI_INFERENCE_URL=http://127.0.0.1:8040

# secret
export AES_ENCRYPTION_KEY=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
export JWT_SECRET_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
export DEFAULT_ADMIN_USERNAME=admin
export DEFAULT_ADMIN_PASSWORD=passWord123

# log
export LOG_LEVEL=INFO

set -e
gunicorn --bind 0.0.0.0:8010 \
         --preload \
         --access-logfile - \
         --error-logfile - \
         --worker-connections 200 \
         -k uvicorn.workers.UvicornWorker \
         app.fastapi_app:app  &
sleep 5
current_dir=$(pwd)
export PYTHONPATH=$PYTHONPATH:$current_dir
pytest tests/services_tests/

export PURPOSE=API
export SERVICE_PORT=8020
export API_SERVICE_PORT=8020
gunicorn --bind 0.0.0.0:8020 \
         --preload \
         --access-logfile - \
         --error-logfile - \
         --worker-connections 200 \
         -k uvicorn.workers.UvicornWorker \
         app.fastapi_app:app  &
sleep 5
pytest tests/services_tests/assistant/
pytest tests/services_tests/inference/
pytest tests/services_tests/retrieval/
pytest tests/services_tests/tool/





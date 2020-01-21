./zap-api-scan.py \
   -t http://webapi:10000/swagger.json \
   -f openapi \
   -O webapi:10000 \
   -r ./zap-report.html \
   -x ./zap-report.xml \
   -z "-configfile /zap/wrk/auth.prop"

sonar-runner

# kubectl get secret -n es01 es-cluster-01-es-elastic-user -o jsonpath={.data.elastic} | base64 --decode; echo

IP=$(kubectl get svc es-cluster-01-es-http -o jsonpath={.spec.clusterIP})
SECRET=$(kubectl get secret es-cluster-01-es-elastic-user -o go-template='{{.data.elastic | base64decode }}')

echo -n "User is elastic, password is "
echo $SECRET

# curl -k --user "elastic:$SECRET" https://$IP:9200

# Expose deployment as NodePort
kubectl expose deployment echo -n echo-sound --name echo-service --type NodePort --port 8080 --target-port 8080
kubectl get svc -n echo-sound echo-service

#Declarative command to generate yaml
#kubectl create ingress echo --rule="example.org/echo=echo-service:8080" -n echo-sound --dry-run=client -o yaml > ingress.yaml

-> manifest in ingress doc first
# Then edit the yaml like so:
cat <<'EOF' > ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo
  namespace: echo-sound
spec:
  rules:
  - host: example.org
    http:
      paths:
      - path: /echo
        pathType: Prefix
        backend:
          service:
            name: echo-service
            port:
              number: 8080
EOF
kubectl apply -f ingress.yaml
kubectl get ingress -n echo-sound

# Optional test (NodePort): curl http://<nodeIP>:<nodePort>/echo

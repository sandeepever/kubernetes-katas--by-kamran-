apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  namespace: default
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.9
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  namespace: default
  name: nginx
  labels:
    name: nginx
    app: nginx
spec:
  ports:
    - port: 80
  selector:
    app: nginx

---

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  namespace: default
  name: nginx-example-com
  labels:
    app: nginx
spec:
  rules:
  - host: nginx.example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: nginx
          servicePort: 80


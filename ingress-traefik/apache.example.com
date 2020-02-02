apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  namespace: default
  name: httpd
  labels:
    app: httpd
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: httpd
    spec:
      containers:
      - name: httpd
        image: httpd:2.4
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  namespace: default
  name: httpd
  labels:
    name: httpd
    app: httpd
spec:
  ports:
    - port: 80
  selector:
    app: httpd

---

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  namespace: default
  name: httpd-example-com
  labels:
    app: httpd
spec:
  rules:
  - host: httpd.example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: httpd
          servicePort: 80


apiVersion: apps/v1
kind: Deployment
metadata:
  name: skcafeapplidocker
  labels:
     app: cafe-app

spec:
  replicas: 2
  selector:
    matchLabels:
      app: cafe-app

  template:
    metadata:
      labels:
        app: cafe-app
    spec:
      containers:
      - name: cafe-app
        image: psykali/cafe-app
        imagePullPolicy: Always
        ports:
        - containerPort: 80
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
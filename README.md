# 🔧 kube-netutils  
> A lightweight and secure diagnostic toolbox for containerized workloads in Kubernetes.  
## 📘 Overview  
**kube-netutils** is a minimal, hardened container image designed for performing network diagnostics and troubleshooting within Kubernetes clusters. It includes essential CLI tools for DNS, TCP/UDP connectivity, ICMP, routing, and more, all bundled in a security-conscious Alpine-based container. This project is ideal for platform engineers, SREs, and Kubernetes administrators who need to debug network connectivity from within pods without deploying heavyweight or privileged tools.  
## 🏗️ Base Image  
The image is built on top of:  
- **[Alpine Linux](https://alpinelinux.org/):latest**  
  - Lightweight (~5MB base)  
  - Designed for security  
  - Fast startup and low overhead  
## 🛠️ Installed Tools  
The image includes the following network utilities:  
| Tool               | Description                                      |  
|--------------------|--------------------------------------------------|  
| `curl`             | HTTP client for API testing and connectivity     |  
| `bind-tools`       | Includes `dig`, `nslookup` for DNS lookups       |  
| `inetutils-telnet` | Telnet client for TCP checks                     |  
| `traceroute`       | Network path visibility                          |  
| `net-tools`        | Includes `ifconfig`, `netstat`                   |  
| `iproute2`         | Modern `ip` utility for routes and interfaces    |  
| `iputils`          | Tools like `ping`, `arping`, `clockdiff`         |  
| `busybox`          | Adds lightweight POSIX tools                     |  
> 🧪 All tools run as a **non-root user** (`nettool`) for added safety inside clusters.  
## 🔐 Security Practices  
- ✅ Non-root execution (`USER nettool`)  
- ✅ `readOnlyRootFilesystem` in the Pod  
- ✅ Linux capabilities dropped (`capabilities.drop: ALL`)  
- ✅ Minimal image size  
- ✅ Vulnerability scanning using **Trivy** in CI  
## 📦 CI/CD Pipeline (GitHub Actions)  
A secure multi-stage CI pipeline is configured to:  
1. **Build** the Docker image with a date-time tag and `latest`  
2. **Scan** the image using [Aqua Trivy](https://github.com/aquasecurity/trivy)  
3. **Push** the image to Docker Hub **only if** no vulnerabilities are found  
You can find the pipeline under `.github/workflows/docker-secure-pipeline.yml`.  
### Example Tags  
- `youruser/kube-netutils:20250526.2335`  
- `youruser/kube-netutils:latest`  
## 🧾 Pod Spec Example  
```yaml  
apiVersion: v1  
kind: Pod  
metadata:  
  name: netutils  
spec:  
  containers:  
    - name: netutils  
      image: yourdockerhubuser/kube-netutils:latest  
      command: ["sleep", "infinity"]  
      securityContext:  
        runAsUser: 1000  
        allowPrivilegeEscalation: false  
        capabilities:  
          drop: ["ALL"]  
        readOnlyRootFilesystem: true  
  securityContext:  
    runAsNonRoot: true  
    fsGroup: 1000  
```  
You can then exec into the pod for diagnostics:  
```bash  
kubectl exec -it netutils -- sh  
```  
## 🧪 Common Commands Inside the Pod  
```bash  
# Check DNS  
dig kubernetes.default.svc.cluster.local  
  
# Ping a service  
ping my-service.namespace.svc.cluster.local  
  
# Curl a cluster service  
curl http://my-api.namespace.svc.cluster.local:8080/healthz  
  
# Traceroute to a pod  
traceroute 10.42.1.15  
  
# Test TCP connectivity  
telnet my-db.namespace.svc.cluster.local 5432  
```  

## 🐳 Building Locally  
```bash  
docker build -t kube-netutils .  
```  

##  Use Cases  
- Debugging network paths between pods and services  
- Validating DNS resolution from within a namespace  
- Diagnosing TCP/UDP service accessibility  
- Verifying network policies, service meshes, or CNI behavior  
## 🔒 Future Enhancements  
- Support for multi-arch builds (amd64, arm64)  
- Optional OpenTelemetry sidecar integration  
- Alpine version pinning & SBOM generation  
## 📜 License  
This project is licensed under the MIT License — see the `LICENSE` file for details.
  
## Contributions  
Contributions, bug reports, and feature requests are welcome! Please open an issue or submit a PR.  

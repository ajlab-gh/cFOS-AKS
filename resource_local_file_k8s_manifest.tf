resource "local_file" "microservices_demo" {
  filename = "microservices-demo.yaml"
  content = data.http.manifest.response_body
}
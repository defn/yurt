job "docker" {
  datacenters = ["spiral"]

  group "shell" {
    task "server" {
      driver = "docker"

      vault {
        policies  = ["admin"]
      }

      config {
        image = "ubuntu"

        args = [
          "sleep",
          "86400"
        ]
      }

      template {
        data = <<EOF
{{ with secret "kv/defn/hello" }}
{{ range $k, $v := .Data.data -}}
{{ $k }}={{ $v }}
{{ end -}}
{{ end }}
EOF
        destination = "secrets/secrets.txt"
      }
    }
  }
}

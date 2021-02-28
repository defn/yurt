job "raw_exec" {
  datacenters = ["spiral"]

  group "shell" {
    task "server" {
      driver = "raw_exec"

      vault {
        policies  = ["admin"]
      }

      config {
        command = "sleep"
        args = [
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

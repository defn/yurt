job "ubuntu" {
  datacenters = ["spiral"]

  group "example" {
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
HELLO={{.Data.data.HELLO}}
{{ end }}
EOF
        destination = "secrets/secrets.txt"
      }
    }
  }
}

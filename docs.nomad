job "docs" {
  datacenters = ["jojo.defn.in"]

  group "example" {
    task "server" {
      driver = "docker"

      vault {
        policies  = ["admin"]
      }

      config {
        image = "hashicorp/http-echo"

        args = [
          "-listen",
          ":5678",
          "-text",
          "hello world",
        ]
      }

      template {
        data = <<EOF
{{ with secret "kv/defn/hello" }}
HELLO={{.Data.data.HELLO}}
{{ end }}
EOF
        destination = "secrets.txt"
      }
    }

    network {
      port "http" {
        static = "5678"
      }
    }
  }
}
